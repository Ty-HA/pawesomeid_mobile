"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
// src/routes/index.ts
const express_1 = require("express");
const identity_routes_1 = __importDefault(require("./identity.routes"));
const router = (0, express_1.Router)();
// Mount identity routes
router.use('/', identity_routes_1.default);
exports.default = router;
