// src/routes/index.ts
import { Router } from 'express';
import identityRoutes from './identity.routes';

const router = Router();

// Mount identity routes
router.use('/', identityRoutes);

export default router;