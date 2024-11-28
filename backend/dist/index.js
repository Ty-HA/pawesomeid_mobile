"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const dotenv_1 = require("dotenv");
const path_1 = require("path");
const routes_1 = __importDefault(require("./routes"));
// Configuration de dotenv avec le chemin explicite
const result = (0, dotenv_1.config)({ path: (0, path_1.resolve)(__dirname, '../.env') });
if (result.error) {
    console.error('Error loading .env file:', result.error);
    process.exit(1);
}
// Log pour debug
console.log('Environment variables loaded:');
console.log('PRIVATE_KEY exists:', !!process.env.PRIVATE_KEY);
console.log('RPC_URL:', process.env.RPC_URL);
console.log('CHAIN_ID:', process.env.CHAIN_ID);
const app = (0, express_1.default)();
// Middleware
app.use((0, cors_1.default)());
app.use(express_1.default.json());
app.use((req, res, next) => {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
    next();
});
// Routes
app.use('/api', routes_1.default);
// Error handling middleware
app.use((err, req, res, next) => {
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
