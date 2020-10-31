INSERT INTO inventory (inventory_id) VALUES ('252f3d4c-db01-463a-8900-97fc9b1183c0');
INSERT INTO public.kf_user (user_id, name, inventory_id) VALUES ('auth0|5f9c4fba87dc530069c38077', 'Kühlfrank tester', '252f3d4c-db01-463a-8900-97fc9b1183c0');

-- Herbstlicher Eintopf
-- 1000 g Schweinefleisch aus der Oberschale
INSERT INTO public.inventory_entry (inventory_entry_id, inventory_id, ingredient_id, amount, unit_id) VALUES ('5f6acdbb-9bac-44bc-84a1-e940725aebdd', '252f3d4c-db01-463a-8900-97fc9b1183c0', '6fe7e3ff-72b3-4060-bc22-b1899e2d63c7', 1000.000, '77847061-5186-418d-8584-27492a7b354a');
-- 600 g Steckrübe
INSERT INTO public.inventory_entry (inventory_entry_id, inventory_id, ingredient_id, amount, unit_id) VALUES ('fbbc3f6b-0e81-4d3c-a85e-fcf0a347f196', '252f3d4c-db01-463a-8900-97fc9b1183c0', '0f44d5a0-1fbb-423a-b75d-011b6e840f18', 600.000, '77847061-5186-418d-8584-27492a7b354a');
-- 300 g Schwarzwurzel
INSERT INTO public.inventory_entry (inventory_entry_id, inventory_id, ingredient_id, amount, unit_id) VALUES ('098d6db1-8541-4180-a89a-6f7820cf15a6', '252f3d4c-db01-463a-8900-97fc9b1183c0', 'e83ff5ad-6dd3-40ea-ac8b-c85726a6d3f8', 300.000, '77847061-5186-418d-8584-27492a7b354a');
