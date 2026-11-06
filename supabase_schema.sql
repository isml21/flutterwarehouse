-- ==============================================================================
-- BOX MANAGEMENT SYSTEM (SISTEM MANAJEMEN BOX GUDANG)
-- SUPABASE POSTGRESQL SCHEMA & RLS POLICIES
-- ==============================================================================

-- 1. Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Drop existing tables if needed (Clean setup)
-- DROP TABLE IF EXISTS box_transactions CASCADE;
-- DROP TABLE IF EXISTS boxes CASCADE;

-- 3. Create 'boxes' table
CREATE TABLE IF NOT EXISTS public.boxes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    box_code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    length_cm NUMERIC NOT NULL CHECK (length_cm > 0),
    width_cm NUMERIC NOT NULL CHECK (width_cm > 0),
    height_cm NUMERIC NOT NULL CHECK (height_cm > 0),
    material_type TEXT NOT NULL DEFAULT 'Corrugated Cardboard',
    quantity INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    location TEXT NOT NULL DEFAULT 'Unassigned',
    status TEXT NOT NULL DEFAULT 'In Stock',
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- Index for rapid lookups and search
CREATE INDEX IF NOT EXISTS idx_boxes_box_code ON public.boxes(box_code);
CREATE INDEX IF NOT EXISTS idx_boxes_name ON public.boxes(name);
CREATE INDEX IF NOT EXISTS idx_boxes_status ON public.boxes(status);

-- 4. Create 'box_transactions' table
CREATE TABLE IF NOT EXISTS public.box_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    box_id UUID NOT NULL REFERENCES public.boxes(id) ON DELETE CASCADE,
    transaction_type TEXT NOT NULL CHECK (transaction_type IN ('IN', 'OUT')),
    amount INT NOT NULL CHECK (amount > 0),
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- Index for transactions
CREATE INDEX IF NOT EXISTS idx_transactions_box_id ON public.box_transactions(box_id);
CREATE INDEX IF NOT EXISTS idx_transactions_created_at ON public.box_transactions(created_at DESC);

-- 5. Enable Row Level Security (RLS)
ALTER TABLE public.boxes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.box_transactions ENABLE ROW LEVEL SECURITY;

-- 6. RLS Policies for 'boxes'
-- Allow read access for authenticated & anonymous users (for testing/production flexibility)
CREATE POLICY "Allow read access to all users" 
ON public.boxes FOR SELECT 
USING (true);

-- Allow insert access for authenticated & anonymous users
CREATE POLICY "Allow insert access to all users" 
ON public.boxes FOR INSERT 
WITH CHECK (true);

-- Allow update access for all users
CREATE POLICY "Allow update access to all users" 
ON public.boxes FOR UPDATE 
USING (true);

-- Allow delete access for all users
CREATE POLICY "Allow delete access to all users" 
ON public.boxes FOR DELETE 
USING (true);

-- 7. RLS Policies for 'box_transactions'
CREATE POLICY "Allow read access to box_transactions" 
ON public.box_transactions FOR SELECT 
USING (true);

CREATE POLICY "Allow insert access to box_transactions" 
ON public.box_transactions FOR INSERT 
WITH CHECK (true);

-- 8. Seed Initial Warehouse Data (Optional Demo Data)
INSERT INTO public.boxes (id, box_code, name, length_cm, width_cm, height_cm, material_type, quantity, location, status)
VALUES 
    ('11111111-1111-1111-1111-111111111111', 'BOX-STD-001', 'Kardus Standar Kecil (Small Carton)', 25.0, 18.0, 15.0, 'Corrugated Single Wall', 120, 'Rak A-01', 'In Stock'),
    ('22222222-2222-2222-2222-222222222222', 'BOX-MED-002', 'Kardus Sedang Serbaguna (Medium Carton)', 40.0, 30.0, 25.0, 'Corrugated Double Wall', 45, 'Rak B-04', 'In Stock'),
    ('33333333-3333-3333-3333-333333333333', 'BOX-HVY-003', 'Heavy Duty Export Wooden Crate', 80.0, 60.0, 50.0, 'Plywood / Wood', 4, 'Zona C-10 (Pallet)', 'Low Stock'),
    ('44444444-4444-4444-4444-444444444444', 'BOX-PLT-004', 'Tote Container Plastik Industri', 50.0, 35.0, 30.0, 'Heavy Duty PP Plastic', 0, 'Rak D-02', 'Out of Stock')
ON CONFLICT (box_code) DO NOTHING;
