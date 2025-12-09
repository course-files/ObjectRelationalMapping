-- Synthetic data for:
-- 1. branch: 20 branches
-- 2. orderstatus: Order Status (Lookup Table): 5 order statuses
-- 3. paymentmethod: Payment Method (Lookup Table): 11 payment methods
-- 4. productcategory: Product Categories: 11 categories
-- 5. product: 100 products

-- More synthetic data is available in separate files for the following:
-- 1. employee: 56 employees
-- 2. customer: 770 customers
-- 3. customerOrder: 5,500 orders
-- 4. orderDetail: 11,026 order details
-- 5. payment: 14,809 payments
-- 6. customerFeedback: 5,500 feedback entries

SET search_path TO siwakadishes;

-- Insert branches
INSERT INTO branch (branchCode, phone, addressLine1, addressLine2, postalCode, county, subCounty) VALUES
(1, '0700000001', 'Westlands Commercial Centre', 'Ring Road, Westlands', '00100', 'Nairobi', 'Westlands'),
(2, '0700000002', 'Yaya Centre', 'Argwings Kodhek Rd', '00100', 'Nairobi', 'Kilimani'),
(3, '0700000003', 'Thika Road Mall', 'Thika Road', '00100', 'Nairobi', 'Kasarani'),
(4, '0700000004', 'Taj Mall', 'Outer Ring Rd', '00100', 'Nairobi', 'Embakasi'),
(5, '0700000005', 'Galleria Mall', 'Langata Rd', '00100', 'Nairobi', 'Langata'),
(6, '0700000006', 'The Junction Mall', 'Ngong Rd', '00100', 'Nairobi', 'Dagoretti'),
(7, '0700000007', 'Garden City Mall', 'Thika Road', '00100', 'Nairobi', 'Ruaraka'),
(8, '0700000008', 'Sarit Centre', 'Karuna Rd', '00100', 'Nairobi', 'Starehe'),
(9, '0700000009', 'Kamukunji Market', 'Kamukunji Rd', '00100', 'Nairobi', 'Kamukunji'),
(10, '0700000010', 'Makadara Law Courts', 'Jogoo Rd', '00100', 'Nairobi', 'Makadara'),
(11, '0700000011', 'Mathare Hospital', 'Hospital Rd', '00100', 'Nairobi', 'Mathare'),
(12, '0700000012', 'Roy Sambu Shopping Centre', 'Roy Sambu Rd', '00100', 'Nairobi', 'Roy Sambu'),
(13, '0700000013', 'Kibra Social Hall', 'Kibra Dr', '00100', 'Nairobi', 'Kibra'),
(14, '0700000014', 'Kangemi Market', 'Waiyaki Way', '00100', 'Nairobi', 'Kangemi'),
(15, '0700000015', 'Githurai Market', 'Githurai Rd', '00100', 'Nairobi', 'Githurai'),
(16, '0710000001', 'City Mall', 'Nyali Rd', '80100', 'Mombasa', 'Nyali'),
(17, '0710000002', 'Mega Plaza', 'Oginga Odinga Rd', '40100', 'Kisumu', 'Kisumu Central'),
(18, '0710000003', 'Westside Mall', 'Kenya Rd', '20100', 'Nakuru', 'Nakuru Town East'),
(19, '0710000004', 'Rupa Mall', 'Uganda Rd', '30100', 'Uasin Gishu', 'Kesses'),
(20, '0710000005', 'Nyeri Mall', 'Gakere Rd', '10100', 'Nyeri', 'Nyeri Central');

-- Insert data into Order Status Lookup Table
INSERT INTO orderStatus (orderStatusID, status) VALUES 
(1, 'Pending'),
(2, 'Processing'),
(3, 'In Transit'),
(4, 'Delivered'),
(5, 'Cancelled');

-- Insert Payment Methods
INSERT INTO paymentMethod (paymentMethodID, paymentMethod) VALUES 
(1, 'Cash'),
(2, 'Debit Card'),
(3, 'Credit Card'),
(4, 'Bank Transfer'),
(5, 'Cheque'),
(6, 'Mobile Money - Safaricom M-Pesa'),
(7, 'Mobile Money - Airtel Money'),
(8, 'Mobile Money - Tigo Pesa'),
(9, 'Mobile Money - Equitel'),
(10, 'Mobile Money - MTN Mobile Money'),
(11, 'Mobile Money - Orange Money');

-- Insert product categories into the productcategory table:
INSERT INTO productcategory (productcategoryID, categoryName, categoryDescription) VALUES
(1, 'Staple Foods', 'Essential carbohydrate-rich foods commonly served as the main part of meals.'),
(2, 'Vegetable-Based Dishes', 'Dishes that primarily consist of vegetables, often sautéed or cooked with spices.'),
(3, 'Meat-Based Dishes', 'Dishes made with different types of meat, such as beef, chicken, or goat.'),
(4, 'Rice Dishes', 'Dishes that use rice as the main ingredient, often spiced or paired with other accompaniments.'),
(5, 'Legume-Based Dishes', 'Dishes featuring beans, lentils, or other legumes, cooked with spices or coconut milk.'),
(6, 'Soup/Stew Dishes', 'Soups or stews made with a variety of ingredients, including meat, vegetables, or plantains.'),
(7, 'Fish Dishes', 'Dishes prepared using fish as the main ingredient, either fried, grilled, or cooked in stews.'),
(8, 'Sweet Snacks/Desserts', 'Sweet dishes or snacks, often fried or baked, served as a dessert or treat.'),
(9, 'Fried Dishes', 'Dishes that are deep-fried, often using batter or dough, and served as snacks or accompaniments.'),
(10, 'Combination Plates', 'Meals that combine multiple components, such as staples paired with vegetables, beans, or meat.'),
(11, 'African Cultural Specials', 'Specialty dishes unique to African cultures, showcasing traditional recipes and flavors.');

-- Insert products into product Table
INSERT INTO product (productCode, productName, productDescription, quantityInStock, costOfProduction, sellingPrice, productcategoryID) VALUES
('P001', 'Ugali', 'A staple food made from maize flour, cooked with water to a dough-like consistency.', 100, 10.00, 20.00, 1),
('P002', 'Sukuma Wiki', 'Collard greens sautéed with onions and tomatoes.', 100, 10.00, 20.00, 2),
('P003', 'Nyama Choma', 'Grilled meat, typically goat or beef, seasoned with salt and spices.', 50, 150.00, 300.00, 3),
('P004', 'Chapati', 'Flatbread made from wheat flour, cooked on a griddle.', 100, 5.00, 20.00, 1),
('P005', 'Githeri', 'A traditional Kikuyu dish of boiled maize and beans.', 80, 30.00, 70.00, 5),
('P006', 'Pilau', 'Spiced rice dish cooked with meat, typically beef or chicken.', 70, 100.00, 200.00, 4),
('P007', 'Mukimo', 'Mashed potatoes mixed with maize, beans, and greens.', 90, 40.00, 80.00, 5),
('P008', 'Kachumbari', 'Fresh tomato and onion salad with cilantro and lime.', 100, 10.00, 30.00, 2),
('P009', 'Samosa', 'Deep-fried pastry filled with spiced meat or vegetables.', 100, 20.00, 50.00, 9),
('P010', 'Mandazi', 'Fried dough snack, similar to a doughnut.', 100, 5.00, 20.00, 8),
('P011', 'Matoke', 'Steamed or boiled plantains, often served with a meat stew.', 70, 30.00, 60.00, 6),
('P012', 'Tilapia Fry', 'Fried whole tilapia fish, seasoned with spices.', 50, 200.00, 350.00, 7),
('P013', 'Omena', 'Small dried fish, typically fried with onions and tomatoes.', 80, 30.00, 70.00, 7),
('P014', 'Mutura', 'Kenyan sausage made from minced meat, blood, and spices.', 60, 70.00, 150.00, 3),
('P015', 'Maharagwe', 'Stewed beans cooked with coconut milk and spices.', 90, 30.00, 60.00, 5),
('P016', 'Kuku Choma', 'Grilled chicken, marinated with spices.', 50, 150.00, 300.00, 3),
('P017', 'Bhajia', 'Potato fritters, deep-fried in a spiced gram flour batter.', 100, 20.00, 50.00, 9),
('P018', 'Mishkaki', 'Skewered and grilled meat, typically beef or chicken.', 70, 100.00, 200.00, 3),
('P019', 'Viazi Karai', 'Potato slices coated in a spiced batter and deep-fried.', 100, 10.00, 30.00, 9),
('P020', 'Ndengu', 'Green grams (mung beans) cooked with onions and tomatoes.', 90, 30.00, 60.00, 5),
('P021', 'Wali wa Nazi', 'Rice cooked with coconut milk.', 80, 30.00, 70.00, 4),
('P022', 'Mbaazi', 'Pigeon peas cooked in coconut milk.', 70, 30.00, 60.00, 5),
('P023', 'Kaimati', 'Sweet dumplings coated in sugar syrup.', 100, 5.00, 20.00, 8),
('P024', 'Mahamri', 'Sweet, fried bread, similar to mandazi.', 100, 5.00, 20.00, 8),
('P025', 'Uji', 'Fermented porridge made from millet or sorghum flour.', 100, 10.00, 30.00, 1),
('P026', 'Supa ya Ndizi', 'Banana soup made with green bananas, meat, and spices.', 70, 30.00, 70.00, 6),
('P027', 'Nyama Stew', 'Beef stew cooked with potatoes, carrots, and peas.', 60, 100.00, 200.00, 3),
('P028', 'Matumbo', 'Tripe stew cooked with onions, tomatoes, and spices.', 50, 70.00, 150.00, 3),
('P029', 'Sukuma na Ugali', 'Collard greens served with ugali.', 100, 20.00, 50.00, 2),
('P030', 'Kuku Stew', 'Chicken stew cooked with potatoes, carrots, and peas.', 60, 100.00, 200.00, 3),
('P031', 'Fish Curry', 'Fish cooked in a spiced coconut milk curry.', 50, 150.00, 300.00, 7),
('P032', 'Mbuzi Choma', 'Grilled goat meat, seasoned with salt and spices.', 50, 200.00, 350.00, 3),
('P033', 'Ugali na Sukuma', 'Ugali served with sautéed collard greens.', 100, 20.00, 50.00, 1),
('P034', 'Kuku Fry', 'Fried chicken, marinated with spices.', 50, 150.00, 300.00, 3),
('P035', 'Ndizi na Nyama', 'Green bananas cooked with meat and spices.', 70, 30.00, 70.00, 6),
('P036', 'Maharagwe ya Nazi', 'Beans cooked in coconut milk.', 90, 30.00, 60.00, 5),
('P037', 'Wali wa Kukaanga', 'Fried rice with vegetables and meat.', 80, 30.00, 70.00, 4),
('P038', 'Supu ya Mbuzi', 'Goat soup cooked with spices.', 60, 70.00, 150.00, 6),
('P039', 'Kuku na Wali', 'Chicken served with rice.', 70, 100.00, 200.00, 3),
('P040', 'Nyama na Wali', 'Beef served with rice.', 60, 100.00, 200.00, 3),
('P041', 'Matoke na Nyama', 'Plantains cooked with meat and spices.', 70, 30.00, 70.00, 6),
('P042', 'Maharagwe na Wali', 'Beans served with rice.', 90, 30.00, 60.00, 5),
('P043', 'Wali wa Pilau', 'Spiced rice cooked with meat.', 80, 30.00, 70.00, 4),
('P044', 'Supu ya Kuku', 'Chicken soup cooked with spices.', 60, 70.00, 150.00, 6),
('P045', 'Kuku na Chapati', 'Chicken served with chapati.', 70, 100.00, 200.00, 3),
('P046', 'Nyama na Chapati', 'Beef served with chapati.', 60, 100.00, 200.00, 3),
('P047', 'Matoke na Maharagwe', 'Plantains cooked with beans.', 70, 30.00, 70.00, 6),
('P048', 'Maharagwe na Chapati', 'Beans served with chapati.', 90, 30.00, 60.00, 5),
('P049', 'Wali wa Nazi na Kuku', 'Coconut rice served with chicken.', 80, 30.00, 70.00, 4),
('P050', 'Supu ya Nyama', 'Beef soup cooked with spices.', 60, 70.00, 150.00, 6),
('P051', 'Kuku na Ugali', 'Chicken served with ugali.', 70, 100.00, 200.00, 3),
('P052', 'Nyama na Ugali', 'Beef served with ugali.', 60, 100.00, 200.00, 3),
('P053', 'Matoke na Sukuma', 'Plantains cooked with collard greens.', 70, 30.00, 70.00, 6),
('P054', 'Maharagwe na Sukuma', 'Beans served with collard greens.', 90, 30.00, 60.00, 5),
('P055', 'Wali wa Nazi na Nyama', 'Coconut rice served with beef.', 80, 30.00, 70.00, 4),
('P056', 'Supu ya Samaki', 'Fish soup cooked with spices.', 60, 70.00, 150.00, 7),
('P057', 'Kuku na Matoke', 'Chicken served with plantains.', 70, 100.00, 200.00, 3),
('P058', 'Nyama na Matoke', 'Beef served with plantains.', 60, 100.00, 200.00, 3),
('P059', 'Matoke na Maharagwe', 'Plantains cooked with beans.', 70, 30.00, 70.00, 6),
('P060', 'Maharagwe na Matoke', 'Beans served with plantains.', 90, 30.00, 60.00, 5),
('P061', 'Wali wa Nazi na Samaki', 'Coconut rice served with fish.', 80, 30.00, 70.00, 4),
('P062', 'Supu ya Kuku na Wali', 'Chicken soup served with rice.', 60, 70.00, 150.00, 6),
('P063', 'Kuku na Maharagwe', 'Chicken served with beans.', 70, 100.00, 200.00, 3),
('P064', 'Nyama na Maharagwe', 'Beef served with beans.', 60, 100.00, 200.00, 3),
('P065', 'Matoke na Wali', 'Plantains served with rice.', 70, 30.00, 70.00, 6),
('P066', 'Maharagwe na Wali', 'Beans served with rice.', 90, 30.00, 60.00, 5),
('P067', 'Wali wa Nazi na Maharagwe', 'Coconut rice served with beans.', 80, 30.00, 70.00, 4),
('P068', 'Supu ya Nyama na Wali', 'Beef soup served with rice.', 60, 70.00, 150.00, 6),
('P069', 'Kuku na Sukuma', 'Chicken served with collard greens.', 70, 100.00, 200.00, 3),
('P070', 'Nyama na Sukuma', 'Beef served with collard greens.', 60, 100.00, 200.00, 3),
('P071', 'Doro Wat', 'Spicy chicken stew made with berbere spice mix.', 50, 150.00, 300.00, 11),
('P072', 'Injera', 'Sourdough flatbread made from teff flour.', 100, 10.00, 20.00, 11),
('P073', 'Kitfo', 'Minced raw beef seasoned with spices and clarified butter.', 60, 200.00, 400.00, 11),
('P074', 'Shiro', 'Chickpea stew seasoned with berbere and other spices.', 80, 30.00, 70.00, 11),
('P075', 'Tibs', 'Sautéed meat, typically beef or lamb, with onions and peppers.', 70, 100.00, 200.00, 11),
('P076', 'Misir Wat', 'Spicy lentil stew made with berbere spice mix.', 90, 30.00, 60.00, 11),
('P077', 'Gomen', 'Collard greens cooked with onions, garlic, and ginger.', 100, 20.00, 50.00, 11),
('P078', 'Atayef', 'Sweet stuffed pancakes, typically filled with nuts or cream.', 100, 10.00, 30.00, 8),
('P079', 'Chechebsa', 'Flatbread pieces mixed with spiced clarified butter.', 80, 20.00, 50.00, 11),
('P080', 'Firfir', 'Shredded injera mixed with spicy sauce.', 70, 30.00, 70.00, 11),
('P081', 'Jollof Rice', 'A popular West African rice dish cooked with tomatoes, onions, and spices.', 80, 30.00, 70.00, 10),
('P082', 'Egusi Soup', 'A Nigerian soup made with melon seeds, leafy vegetables, and meat or fish.', 70, 40.00, 80.00, 10),
('P083', 'Fufu', 'A starchy side dish made from cassava, yams, or plantains, pounded into a dough-like consistency.', 100, 20.00, 50.00, 10),
('P084', 'Suya', 'Spicy skewered meat, typically beef or chicken, grilled and served with onions and tomatoes.', 60, 50.00, 100.00, 10),
('P085', 'Kelewele', 'Spicy fried plantains, seasoned with ginger, garlic, and chili.', 90, 20.00, 50.00, 10),
('P086', 'Banku', 'A fermented corn and cassava dough, cooked into a smooth, starchy side dish.', 80, 30.00, 70.00, 10),
('P087', 'Moi Moi', 'A steamed bean pudding made from blended black-eyed peas, onions, and spices.', 70, 20.00, 50.00, 10),
('P088', 'Banga Soup', 'A rich and flavorful Nigerian soup made from palm nut extract, meat, and spices.', 60, 50.00, 100.00, 10),
('P089', 'Waakye', 'A Ghanaian dish of rice and beans cooked with millet leaves, served with various sides.', 80, 30.00, 70.00, 10),
('P090', 'Akara', 'Deep-fried bean cakes made from black-eyed peas, onions, and spices.', 100, 20.00, 50.00, 10),
('P091', 'Bunny Chow', 'A hollowed-out loaf of bread filled with curry, typically made with chicken, lamb, or beans.', 70, 40.00, 80.00, 10),
('P092', 'Bobotie', 'A spiced minced meat dish baked with an egg-based topping, often served with yellow rice.', 60, 50.00, 100.00, 10),
('P093', 'Biltong', 'Cured and dried meat, typically beef or game, seasoned with spices.', 80, 100.00, 200.00, 10),
('P094', 'Boerewors', 'A traditional South African sausage made from minced beef and pork, seasoned with spices.', 90, 50.00, 100.00, 10),
('P095', 'Chakalaka', 'A spicy vegetable relish made with tomatoes, onions, peppers, and beans.', 100, 20.00, 50.00, 10),
('P096', 'Pap', 'A porridge made from maize meal, often served as a side dish with meat and gravy.', 100, 10.00, 30.00, 10),
('P097', 'Sosaties', 'Marinated meat skewers, typically made with lamb or chicken, grilled and served with apricots.', 70, 50.00, 100.00, 10),
('P098', 'Malva Pudding', 'A sweet, spongy dessert made with apricot jam and served with a creamy sauce.', 80, 30.00, 70.00, 8),
('P099', 'Potjiekos', 'A slow-cooked stew made with meat, vegetables, and spices, traditionally cooked in a cast-iron pot.', 60, 50.00, 100.00, 10),
('P100', 'Vetkoek', 'Deep-fried dough balls, often filled with minced meat or served with syrup.', 90, 20.00, 50.00, 8);