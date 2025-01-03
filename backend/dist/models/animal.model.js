"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.Animal = void 0;
const mongoose_1 = __importStar(require("mongoose"));
const AnimalSchema = new mongoose_1.Schema({
    did: { type: String, required: true, unique: true },
    name: { type: String, required: true },
    species: { type: String, required: true },
    subspecies: String,
    birthDate: Date,
    sanctuaryDid: { type: String, required: true },
    status: {
        type: String,
        enum: ['alive', 'deceased', 'unknown'],
        default: 'alive'
    },
    sex: {
        type: String,
        enum: ['male', 'female', 'unknown'],
        default: 'unknown'
    },
    parents: {
        father: { type: mongoose_1.Schema.Types.ObjectId, ref: 'Animal' },
        mother: { type: mongoose_1.Schema.Types.ObjectId, ref: 'Animal' }
    },
    offspring: [{ type: mongoose_1.Schema.Types.ObjectId, ref: 'Animal' }],
    biometrics: {
        dna: String,
        faceHash: String,
        distinctiveMarks: [String],
        microchipId: String,
        weight: Number,
        height: Number
    },
    currentLocation: {
        type: {
            type: String,
            enum: ['Point'],
            required: true
        },
        coordinates: {
            type: [Number],
            required: true
        }
    },
    credentials: [{
            type: { type: String, required: true },
            issuanceDate: { type: Date, required: true },
            expirationDate: { type: Date, required: true },
            credentialHash: { type: String, required: true },
            issuer: { type: String, required: true }
        }],
    metadata: {
        type: Map,
        of: mongoose_1.Schema.Types.Mixed,
        default: {}
    }
}, {
    timestamps: true
});
AnimalSchema.index({ currentLocation: '2dsphere' });
exports.Animal = mongoose_1.default.model('Animal', AnimalSchema);
