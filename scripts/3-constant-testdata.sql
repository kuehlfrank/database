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