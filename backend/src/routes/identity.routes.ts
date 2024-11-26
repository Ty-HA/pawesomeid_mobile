import { Router } from 'express';
import { IdentityController } from '../controllers/identity.controller';
import { ethers } from 'ethers';

const router = Router();
const identityController = new IdentityController();

// Route de test réseau
router.get('/network/status', async (req, res) => {
  try {
    const provider = new ethers.providers.JsonRpcProvider(
      process.env.RPC_URL || 'https://rpc.amoy.polygon.technology'
    );
    
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
  } catch (error) {
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

export default router;