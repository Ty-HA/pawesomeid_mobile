// src/controllers/identity.controller.ts
import { Request, Response } from 'express';
import { IdentityService } from '../services/identity.service';

export class IdentityController {
  private identityService: IdentityService;

  constructor() {
    this.identityService = new IdentityService();
  }

  getWalletInfo = async (req: Request, res: Response) => {
    try {
      const walletInfo = await this.identityService.getWalletInfo();
      console.log('Wallet info retrieved:', walletInfo);
      res.status(200).json({
        success: true,
        wallet: walletInfo
      });
    } catch (error) {
      console.error('Erreur récupération wallet:', error);
      res.status(500).json({
        success: false,
        error: 'Erreur lors de la récupération du wallet',
        details: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  };

createAnimalIdentity = async (req: Request, res: Response) => {
  try {
    const { 
      name, species, birthDate, sanctuaryDid,
      subspecies, sex, biometrics, parents
    } = req.body;

    if (!name || !species || !sanctuaryDid) {
      return res.status(400).json({
        success: false,
        error: 'Missing data'
      });
    }

    // Créer l'identité
    const identity = await this.identityService.createIdentity('animal', {
      name,
      species,
      birthDate,
      sanctuaryDid,
      subspecies,
      sex,
      biometrics,
      parents
    });


    // Log pour debug
    console.log('Identity Response:', identity);

    // Construire la réponse dans le bon format
    res.status(201).json({
      success: true,
      identity: {
        did: identity.did,
        address: identity.address,
        type: identity.type,
        metadata: identity.metadata,
        claim: identity.claim,
        transaction: {
          hash: identity.transactionHash,
          blockNumber: identity.blockNumber
        }
      }
    });

  } catch (error) {
    console.error('Erreur création identité:', error);
    res.status(500).json({
      success: false,
      error: 'Erreur lors de la création de l\'identité',
      details: error instanceof Error ? error.message : 'Unknown error'
    });
  }
};

  issueCredential = async (req: Request, res: Response) => {
    try {
      const { issuerDid, animalDid, credentialType, credentialData } = req.body;

      if (!issuerDid || !animalDid || !credentialType || !credentialData) {
        return res.status(400).json({
          success: false,
          error: 'Missing data'
        });
      }

      const credential = await this.identityService.issueCredential(
        issuerDid,
        animalDid,
        {
          type: credentialType,
          attributes: credentialData
        }
      );

      res.status(201).json({
        success: true,
        credential
      });

    } catch (error) {
      console.error('Erreur émission credential:', error);
      res.status(500).json({
        success: false,
        error: 'Erreur lors de l\'émission du credential',
        details: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  };

  verifyCredential = async (req: Request, res: Response) => {
    try {
      const { credential } = req.body;

      if (!credential) {
        return res.status(400).json({
          success: false,
          error: 'Credential manquant'
        });
      }

      const verification = await this.identityService.verifyCredential(credential);

      res.status(200).json({
        success: true,
        verification
      });
    } catch (error) {
      console.error('Erreur vérification credential:', error);
      res.status(500).json({
        success: false,
        error: 'Erreur lors de la vérification du credential',
        details: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  };
}