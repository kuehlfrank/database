INSERT INTO inventory (inventory_id) VALUES ('78ee4515-2e41-446c-a8ed-b141a199aedd');


INSERT INTO public.unit (unit_id, label) VALUES ('69de7253-8d05-4b7a-af19-9b26959d2eed', 'TestUnit');
INSERT INTO public.ingredient (ingredient_id, name, common) VALUES ('234488d8-261e-40de-83d3-09c1ef557907', 'TestSalat', false);
INSERT INTO public.ingredient (ingredient_id, name, common) VALUES ('32ad6979-cb22-4f4f-a907-5c08c116cbf4', 'TestBrot', false);
INSERT INTO public.ingredient (ingredient_id, name, common) VALUES ('03527cc0-d028-4ef7-bfb4-66486ee6d617', 'TestWasser', false);
INSERT INTO public.inventory_entry (inventory_entry_id, inventory_id, ingredient_id, amount, unit_id) VALUES ('92f40a9e-8a27-4670-a0ed-2c1c1cb118fe', '78ee4515-2e41-446c-a8ed-b141a199aedd', '234488d8-261e-40de-83d3-09c1ef557907', 1000.000, '69de7253-8d05-4b7a-af19-9b26959d2eed');
INSERT INTO public.inventory_entry (inventory_entry_id, inventory_id, ingredient_id, amount, unit_id) VALUES ('31afa831-ff18-4e6e-96c7-df16be796e1a', '78ee4515-2e41-446c-a8ed-b141a199aedd', '32ad6979-cb22-4f4f-a907-5c08c116cbf4', 5.000, '69de7253-8d05-4b7a-af19-9b26959d2eed');
INSERT INTO public.inventory_entry (inventory_entry_id, inventory_id, ingredient_id, amount, unit_id) VALUES ('08beedd2-0396-4cbf-bd73-f35e9a5ec47d', '78ee4515-2e41-446c-a8ed-b141a199aedd', '03527cc0-d028-4ef7-bfb4-66486ee6d617', 6.000, '69de7253-8d05-4b7a-af19-9b26959d2eed');

INSERT INTO public.kf_user (user_id, name, inventory_id) VALUES ('auth0|5f919f0ea0aa3000751e975b', 'Tom Stein', '78ee4515-2e41-446c-a8ed-b141a199aedd');
INSERT INTO public.kf_user (user_id, name, inventory_id) VALUES ('auth0|5f91274aa0aa3000751e503b', 'Niggo', '78ee4515-2e41-446c-a8ed-b141a199aedd');
INSERT INTO public.kf_user (user_id, name, inventory_id) VALUES ('google-oauth2|117818551775174378858', 'Tom Stein', '78ee4515-2e41-446c-a8ed-b141a199aedd');

INSERT INTO inventory (inventory_id) VALUES ('252f3d4c-db01-463a-8900-97fc9b1183c0');
INSERT INTO public.kf_user (user_id, name, inventory_id) VALUES ('auth0|5f9c4fba87dc530069c38077', 'Kühlfrank tester', '252f3d4c-db01-463a-8900-97fc9b1183c0');

-- Herbstlicher Eintopf
-- 1000 g Schweinefleisch aus der Oberschale
INSERT INTO public.inventory_entry (inventory_entry_id, inventory_id, ingredient_id, amount, unit_id) VALUES ('5f6acdbb-9bac-44bc-84a1-e940725aebdd', '252f3d4c-db01-463a-8900-97fc9b1183c0', '6fe7e3ff-72b3-4060-bc22-b1899e2d63c7', 1000.000, '77847061-5186-418d-8584-27492a7b354a');
-- 600 g Steckrübe
INSERT INTO public.inventory_entry (inventory_entry_id, inventory_id, ingredient_id, amount, unit_id) VALUES ('fbbc3f6b-0e81-4d3c-a85e-fcf0a347f196', '252f3d4c-db01-463a-8900-97fc9b1183c0', '0f44d5a0-1fbb-423a-b75d-011b6e840f18', 600.000, '77847061-5186-418d-8584-27492a7b354a');
-- 300 g Schwarzwurzel
INSERT INTO public.inventory_entry (inventory_entry_id, inventory_id, ingredient_id, amount, unit_id) VALUES ('098d6db1-8541-4180-a89a-6f7820cf15a6', '252f3d4c-db01-463a-8900-97fc9b1183c0', 'e83ff5ad-6dd3-40ea-ac8b-c85726a6d3f8', 300.000, '77847061-5186-418d-8584-27492a7b354a');
