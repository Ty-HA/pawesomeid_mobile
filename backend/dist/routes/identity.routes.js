"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const identity_controller_1 = require("../controllers/identity.controller");
const ethers_1 = require("ethers");
const router = (0, express_1.Router)();
const identityController = new identity_controller_1.IdentityController();
// Route de test réseau
router.get('/network/status', async (req, res) => {
    try {
        const provider = new ethers_1.ethers.providers.JsonRpcProvider(process.env.RPC_URL || 'https://rpc.amoy.polygon.technology');
        const [network, blockNumber] = await Promise.all([
            provider.getNetwork(),
            provider.getBlockNumber()
        ]);
        res.json({
            success: true,
            network: {
                name: network.name,
                chainId: network.chainId,
                blockNumber
            },
            rpcUrl: process.env.RPC_URL || 'https://rpc.amoy.polygon.technology'
        });
    }
    catch (error) {
        console.error('Network test error:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to connect to network',
            details: error instanceof Error ? error.message : 'Unknown error'
        });
    }
});
// Routes existantes
router.get('/wallet/info', identityController.getWalletInfo);
router.post('/identity/animal', identityController.createAnimalIdentity);
router.post('/identity/credential/issue', identityController.issueCredential);
router.post('/identity/credential/verify', identityController.verifyCredential);
exports.default = router;
