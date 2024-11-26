"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.IdentityService = void 0;
const ethers_1 = require("ethers");
const dotenv_1 = __importDefault(require("dotenv"));
dotenv_1.default.config();
class IdentityService {
    constructor() {
        console.log('Initializing IdentityService...');
        const privateKey = process.env.PRIVATE_KEY;
        if (!privateKey) {
            console.error('PRIVATE_KEY not found in environment variables');
            throw new Error('Private key is not defined in environment variables');
        }
        // Configuration du provider avec timeout et retry
        const rpcUrl = process.env.RPC_URL || 'https://rpc.amoy.polygon.technology';
        console.log('Connecting to RPC:', rpcUrl);
        this.provider = new ethers_1.ethers.providers.JsonRpcProvider({
            url: rpcUrl,
            timeout: 60000,
        });
        // Configuration explicite du réseau
        this.chainId = parseInt(process.env.CHAIN_ID || '80002');
        this.provider.getNetwork().then(network => {
            console.log('Connected to network:', {
                name: network.name,
                chainId: network.chainId
            });
        }).catch(error => {
            console.error('Failed to get network:', error);
        });
        try {
            this.wallet = new ethers_1.ethers.Wallet(privateKey, this.provider);
            console.log('Wallet initialized with address:', this.wallet.address);
        }
        catch (error) {
            console.error('Error initializing wallet:', error);
            throw error;
        }
    }
    async getWalletInfo() {
        try {
            console.log('Getting wallet info...');
            // Vérifier la connexion au réseau
            const network = await this.provider.getNetwork();
            console.log('Current network:', network);
            // Vérifier le wallet
            const address = await this.wallet.getAddress();
            console.log('Wallet address:', address);
            // Obtenir le solde
            const balance = await this.wallet.getBalance();
            console.log('Wallet balance:', ethers_1.ethers.utils.formatEther(balance), 'POL');
            // Tester la connexion RPC
            const blockNumber = await this.provider.getBlockNumber();
            console.log('Current block number:', blockNumber);
            return {
                address,
                balance: ethers_1.ethers.utils.formatEther(balance),
                network: {
                    name: network.name,
                    chainId: network.chainId
                },
                blockNumber
            };
        }
        catch (error) {
            console.error('Error in getWalletInfo:', error);
            throw new Error(`Failed to get wallet info: ${error.message}`);
        }
    }
    async createIdentity(type, metadata) {
        try {
            console.log('Creating identity...');
            console.log('Using wallet address:', this.wallet.address);
            const did = `did:polygon:amoy:${this.wallet.address}`;
            const claim = {
                type: type === 'sanctuary' ? 'SanctuaryClaim' : 'AnimalClaim',
                issuanceDate: new Date().toISOString(),
                expirationDate: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000).toISOString(),
                attributes: {
                    ...metadata,
                    entityType: type,
                    createdAt: new Date().toISOString()
                }
            };
            console.log('Preparing transaction...');
            // Obtenir le nonce actuel
            const nonce = await this.wallet.getTransactionCount();
            console.log('Current nonce:', nonce);
            // Obtenir les prix de gas recommandés
            const feeData = await this.provider.getFeeData();
            console.log('Fee data:', {
                maxFeePerGas: ethers_1.ethers.utils.formatUnits(feeData.maxFeePerGas || 0, 'gwei'),
                maxPriorityFeePerGas: ethers_1.ethers.utils.formatUnits(feeData.maxPriorityFeePerGas || 0, 'gwei')
            });
            // Préparer les paramètres de transaction avec des gas prix plus élevés
            const tx = await this.wallet.sendTransaction({
                to: ethers_1.ethers.constants.AddressZero,
                data: ethers_1.ethers.utils.hexlify(ethers_1.ethers.utils.toUtf8Bytes(JSON.stringify(claim))),
                nonce: nonce,
                // Ajuster les prix de gas (augmentés pour Amoy)
                maxFeePerGas: ethers_1.ethers.utils.parseUnits('100', 'gwei'),
                maxPriorityFeePerGas: ethers_1.ethers.utils.parseUnits('30', 'gwei'),
                // Estimation du gas limit avec une marge
                gasLimit: ethers_1.ethers.utils.hexlify(100000)
            });
            console.log('Transaction sent! Hash:', tx.hash);
            console.log('Waiting for confirmation...');
            const receipt = await tx.wait(1);
            console.log('Transaction confirmed in block:', receipt.blockNumber);
            return {
                did,
                address: this.wallet.address,
                type,
                metadata,
                claim,
                transaction: {
                    hash: tx.hash,
                    blockNumber: receipt.blockNumber
                }
            };
        }
        catch (error) {
            console.error('Error in createIdentity:', error);
            if (error.code === 'INSUFFICIENT_FUNDS') {
                throw new Error('Insufficient funds for transaction. Please ensure your wallet has enough POL tokens.');
            }
            throw new Error(`Failed to create identity: ${error.message}`);
        }
    }
    async issueCredential(issuerDid, subjectDid, credentialData) {
        try {
            console.log('Issuing credential...');
            console.log('Issuer:', issuerDid);
            console.log('Subject:', subjectDid);
            const credential = {
                '@context': [
                    'https://www.w3.org/2018/credentials/v1',
                    'https://schema.privado.io/credentials/animal/v1'
                ],
                id: `urn:uuid:${Date.now()}`,
                type: ['VerifiableCredential', credentialData.type],
                issuer: issuerDid,
                issuanceDate: new Date().toISOString(),
                expirationDate: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000).toISOString(),
                credentialSubject: {
                    id: subjectDid,
                    ...credentialData.attributes
                }
            };
            console.log('Preparing transaction for credential...');
            // Obtenir le nonce actuel
            const nonce = await this.wallet.getTransactionCount();
            console.log('Current nonce:', nonce);
            // Obtenir les prix de gas recommandés
            const feeData = await this.provider.getFeeData();
            console.log('Fee data:', {
                maxFeePerGas: ethers_1.ethers.utils.formatUnits(feeData.maxFeePerGas || 0, 'gwei'),
                maxPriorityFeePerGas: ethers_1.ethers.utils.formatUnits(feeData.maxPriorityFeePerGas || 0, 'gwei')
            });
            // Préparer la transaction avec les paramètres de gas ajustés
            const tx = await this.wallet.sendTransaction({
                to: ethers_1.ethers.constants.AddressZero,
                data: ethers_1.ethers.utils.hexlify(ethers_1.ethers.utils.toUtf8Bytes(JSON.stringify(credential))),
                nonce: nonce,
                maxFeePerGas: ethers_1.ethers.utils.parseUnits('100', 'gwei'),
                maxPriorityFeePerGas: ethers_1.ethers.utils.parseUnits('30', 'gwei'),
                gasLimit: ethers_1.ethers.utils.hexlify(150000) // Augmenté car les credentials sont plus gros
            });
            console.log('Credential transaction sent! Hash:', tx.hash);
            console.log('Waiting for confirmation...');
            const receipt = await tx.wait(1);
            console.log('Transaction confirmed in block:', receipt.blockNumber);
            return {
                ...credential,
                proof: {
                    type: 'PolygonAmoyAnchoring2024',
                    created: new Date().toISOString(),
                    blockchainRef: {
                        chainId: this.chainId,
                        transactionHash: tx.hash,
                        blockNumber: receipt.blockNumber
                    }
                }
            };
        }
        catch (error) {
            console.error('Error in issueCredential:', error);
            throw new Error(`Failed to issue credential: ${error.message}`);
        }
    }
    async verifyCredential(credential) {
        var _a, _b;
        try {
            if (!((_b = (_a = credential.proof) === null || _a === void 0 ? void 0 : _a.blockchainRef) === null || _b === void 0 ? void 0 : _b.transactionHash)) {
                throw new Error('Credential not anchored on blockchain');
            }
            const tx = await this.provider.getTransaction(credential.proof.blockchainRef.transactionHash);
            if (!tx) {
                throw new Error('Transaction not found on blockchain');
            }
            if (tx.blockNumber === null || tx.blockNumber === undefined) {
                throw new Error('Transaction not included in a block');
            }
            const block = await this.provider.getBlock(tx.blockNumber);
            const data = ethers_1.ethers.utils.toUtf8String(tx.data);
            const anchoredData = JSON.parse(data);
            return {
                isValid: true,
                verificationDate: new Date().toISOString(),
                blockchainProof: {
                    transactionHash: tx.hash,
                    blockNumber: tx.blockNumber,
                    timestamp: block.timestamp,
                    anchoredData
                }
            };
        }
        catch (error) {
            console.error('Error in verifyCredential:', error);
            throw new Error(`Verification failed: ${error.message}`);
        }
    }
}
exports.IdentityService = IdentityService;
