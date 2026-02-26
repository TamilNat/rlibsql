#!/usr/bin/env node

/**
 * Generate JWT keys and tokens for libsql authentication
 * Run with: node jwtgen.js
 */

const crypto = require('crypto');

function base64UrlEncode(buffer) {
  return buffer.toString('base64')
    .replace(/\+/g, '-')
    .replace(/\//g, '_')
    .replace(/=+$/, '');
}

function generateEd25519KeyPair() {
  const { publicKey, privateKey } = crypto.generateKeyPairSync('ed25519');
  
  const publicKeyPem = publicKey.export({ type: 'spki', format: 'pem' });
  const privateKeyPem = privateKey.export({ type: 'pkcs8', format: 'pem' });
  
  // Extract raw public key for SQLD_AUTH_JWT_KEY
  const publicKeyDer = publicKey.export({ type: 'spki', format: 'der' });
  // Skip the ASN.1 header (first 12 bytes for Ed25519 SPKI)
  const rawPublicKey = publicKeyDer.slice(12);
  const urlSafePublicKey = base64UrlEncode(Buffer.from(rawPublicKey));
  
  return { publicKeyPem, privateKeyPem, urlSafePublicKey, privateKey };
}

function generateJWT(privateKey, access = 'rw') {
  // JWT Header
  const header = {
    alg: 'EdDSA',
    typ: 'JWT'
  };
  
  // JWT Payload
  const now = Math.floor(Date.now() / 1000);
  const payload = {
    a: access,  // 'rw' for read-write, 'ro' for read-only
    exp: now + (365 * 24 * 60 * 60 * 10),  // 10 years expiry
    iat: now
  };
  
  // Encode header and payload
  const encodedHeader = base64UrlEncode(Buffer.from(JSON.stringify(header)));
  const encodedPayload = base64UrlEncode(Buffer.from(JSON.stringify(payload)));
  
  // Create signature using signOneShot
  const signingInput = `${encodedHeader}.${encodedPayload}`;
  const signature = crypto.sign(null, Buffer.from(signingInput), privateKey);
  const encodedSignature = base64UrlEncode(signature);
  
  return `${encodedHeader}.${encodedPayload}.${encodedSignature}`;
}

// Main execution
console.log('=== libsql JWT Key Generator ===\n');

const { publicKeyPem, privateKeyPem, urlSafePublicKey, privateKey } = generateEd25519KeyPair();
const jwtToken = generateJWT(privateKey, 'rw');
const jwtTokenRO = generateJWT(privateKey, 'ro');

console.log('1. RAILWAY ENVIRONMENT VARIABLE:');
console.log('--------------------------------');
console.log(`SQLD_AUTH_JWT_KEY=${urlSafePublicKey}`);
console.log('');

console.log('2. CONNECTION STRINGS:');
console.log('--------------------');
console.log('After deploying to Railway, your connection strings will be:');
console.log('');
console.log('Read-Write access:');
console.log(`libsql://<your-railway-app>.up.railway.app?authToken=${jwtToken}`);
console.log('');
console.log('Read-Only access:');
console.log(`libsql://<your-railway-app>.up.railway.app?authToken=${jwtTokenRO}`);
console.log('');

console.log('3. PRIVATE KEY (keep secure!):');
console.log('------------------------------');
console.log(privateKeyPem);
console.log('');

console.log('4. PUBLIC KEY (for reference):');
console.log('------------------------------');
console.log(publicKeyPem);
console.log('');

console.log('=== SETUP INSTRUCTIONS ===');
console.log('1. Copy SQLD_AUTH_JWT_KEY value to Railway Environment Variables');
console.log('2. Deploy your Railway project');
console.log('3. Use the connection strings above (replace <your-railway-app> with your actual domain)');
console.log('');
