import mongoose, { Schema, Document, Types } from 'mongoose';

interface Biometrics {
  dna?: string;
  faceHash?: string;
  distinctiveMarks?: string[];
  microchipId?: string;
  weight?: number;
  height?: number;
}

interface Location {
  type: 'Point';
  coordinates: [number, number]; // [longitude, latitude]
}

export interface IAnimal extends Document {
  did: string;
  name: string;
  species: string;
  subspecies?: string;
  birthDate?: Date;
  sanctuaryDid: string;
  status: 'alive' | 'deceased' | 'unknown';
  sex: 'male' | 'female' | 'unknown';
  
  // Généalogie
  parents: {
    father?: Types.ObjectId;
    mother?: Types.ObjectId;
  };
  offspring: Types.ObjectId[];
  
  // Biométrie
  biometrics: Biometrics;
  
  // Localisation
  currentLocation?: Location;
  
  // Santé et identité
  credentials: Array<{
    type: string;
    issuanceDate: Date;
    expirationDate: Date;
    credentialHash: string;
    issuer: string;
  }>;
  
  metadata: {
    breed?: string;
    color?: string;
    diet?: string;
    behavior?: string[];
    medicalHistory?: string[];
    [key: string]: any;
  };
}

const AnimalSchema = new Schema({
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
    father: { type: Schema.Types.ObjectId, ref: 'Animal' },
    mother: { type: Schema.Types.ObjectId, ref: 'Animal' }
  },
  offspring: [{ type: Schema.Types.ObjectId, ref: 'Animal' }],
  
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
    of: Schema.Types.Mixed,
    default: {}
  }
}, {
  timestamps: true
});

AnimalSchema.index({ currentLocation: '2dsphere' });

export const Animal = mongoose.model<IAnimal>('Animal', AnimalSchema);