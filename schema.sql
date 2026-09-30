-- Maison Ryx / Supabase database
create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  price numeric(12,2) not null default 0,
  old_price numeric(12,2),
  size_ml integer,
  category text not null default 'perfume' check (category in ('perfume','oil','incense','mist')),
  source text not null default 'own' check (source in ('own','brought')),
  badge text,
  notes text,
  description text,
  image_url text,
  out_of_stock boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  product_id uuid references public.products(id) on delete set null,
  product_name text not null,
  unit_price numeric(12,2) not null,
  quantity integer not null default 1 check (quantity > 0),
  customer_name text not null,
  phone text not null,
  address text not null,
  status text not null default 'new' check (status in ('new','processing','shipped','completed','cancelled')),
  created_at timestamptz not null default now()
);

alter table public.products enable row level security;
alter table public.orders enable row level security;

drop policy if exists "Public can read products" on public.products;
create policy "Public can read products"
on public.products for select
to anon, authenticated
using (true);

drop policy if exists "Admins manage products" on public.products;
create policy "Admins manage products"
on public.products for all
to authenticated
using ((select auth.uid()) is not null)
with check ((select auth.uid()) is not null);

drop policy if exists "Public can create orders" on public.orders;
create policy "Public can create orders"
on public.orders for insert
to anon, authenticated
with check (true);

drop policy if exists "Admins read orders" on public.orders;
create policy "Admins read orders"
on public.orders for select
to authenticated
using ((select auth.uid()) is not null);

drop policy if exists "Admins update orders" on public.orders;
create policy "Admins update orders"
on public.orders for update
to authenticated
using ((select auth.uid()) is not null)
with check ((select auth.uid()) is not null);

-- Create a public Storage bucket named: perfume-images
-- Then add this policy in Storage if you want admin uploads from the dashboard:
drop policy if exists "Admins upload perfume images" on storage.objects;
create policy "Admins upload perfume images"
on storage.objects for insert
to authenticated
with check (bucket_id = 'perfume-images' and (select auth.uid()) is not null);

drop policy if exists "Public read perfume images" on storage.objects;
create policy "Public read perfume images"
on storage.objects for select
to public
using (bucket_id = 'perfume-images');
