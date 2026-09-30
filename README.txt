Maison Ryx — Vercel Ready

1) ارفع كل الملفات إلى Vercel كما هي.
2) الصفحة الرئيسية: index.html
3) لوحة الإدارة: /admin.html
4) Supabase يجب أن يحتوي على schema.sql منفذاً مرة واحدة.
5) أنشئ مستخدم Admin من Supabase Authentication > Users.
6) أنشئ Storage bucket باسم perfume-images واجعله Public.
7) عدّل config.js فقط إذا أردت تغيير WhatsApp. لا تضع Secret/Service Role key.

الملفات:
- index.html / store.html: المتجر
- admin.html: لوحة الإدارة
- config.js: إعدادات Supabase وWhatsApp
- schema.sql: قاعدة البيانات والصلاحيات
- logo.svg: شعار Maison Ryx
