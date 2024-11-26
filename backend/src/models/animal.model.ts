// src/models/animal.model.ts
import mongoose, { Schema, Document } from 'mongoose';

export interface IAnimal extends Document {
  did: string;
  name: string;
  species: string;
  birthDate?: Date;
  sanctuaryDid: string;
  faceHash?: string;
  credentials: Array<{
    type: string;
    issuanceDate: Date;
    expirationDate: Date;
    credentialHash: string;
  }>;
  metadata: {
    breed?: string;
    gender?: string;
    color?: string;
    distinguishingMarks?: string[];
    [key: string]: any;
  };
}

const AnimalSchema: Schema = new Schema({
  did: {
    type: String,
    required: true,
    unique: true
  },
  name: {
    type: String,
    required: true
  },
  species: {
    type: String,
    required: true
  },
  birthDate: {
    type: Date
  },
  sanctuaryDid: {
    type: String,
    required: true
  },
  faceHash: {
    type: String
  },
  credentials: [{
    type: {
      type: String,
      required: true
    },
    issuanceDate: {
      type: Date,
      required: true
    },
    expirationDate: {
      type: Date,
      required: true
    },
    credentialHash: {
      type: String,
      required: true
    }
  }],
  metadata: {
    type: Map,
    of: Schema.Types.Mixed,
    default: {}
  }
}, {
  timestamps: true
});

export const Animal = mongoose.model<IAnimal>('Animal', AnimalSchema);