import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { config } from 'dotenv';
import { resolve } from 'path';
import routes from './routes';

// Configuration de dotenv avec le chemin explicite
const result = config({ path: resolve(__dirname, '../.env') });

if (result.error) {
  console.error('Error loading .env file:', result.error);
  process.exit(1);
}

// Log pour debug
console.log('Environment variables loaded:');
console.log('PRIVATE_KEY exists:', !!process.env.PRIVATE_KEY);
console.log('RPC_URL:', process.env.RPC_URL);
console.log('CHAIN_ID:', process.env.CHAIN_ID);

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
  next();
});

// Routes
app.use('/api', routes);

// Error handling middleware
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
  console.error('Global error handler:', err);
  res.status(500).json({
    success: false,
    error: 'Une erreur interne est survenue',
    details: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on http://192.168.1.86:${PORT}`);
});