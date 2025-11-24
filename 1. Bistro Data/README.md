# Bistro restaurant Data

🍽️ **Project Background**
I recently “joined” the analytics team at **Bistro Restaurant**, a venue known for its diverse menu and loyal customer base. With a new menu launch on the horizon, my role was to dive into historical order data and uncover which dishes are driving sales, where customer preferences are strongest, and how the menu can be refined to increase both customer satisfaction and profitability. In simple terms, the goal was to turn raw order logs into clear, data-backed recommendations that support smarter menu design and pricing decisions.  

---

🎯 **Objectives**  
The analysis was structured around three main objectives:  

1️⃣ **Explore the `menu_items` table** to understand price range, cuisine types, and how the current menu is positioned.  
<img width="521" height="397" alt="image" src="https://github.com/user-attachments/assets/b96e1105-bf56-41d1-8ff2-73bab0ba042a" />

2️⃣ **Analyse the `order_details` table** to study order volume, basket size, and overall purchasing patterns. 
<img width="479" height="318" alt="image" src="https://github.com/user-attachments/assets/5a19001d-dfb1-4d9c-afc4-54a908d07806" />

3️⃣ **Combine both datasets** to connect what’s on the menu with how customers actually respond to it—identifying star dishes, underperformers, and revenue drivers.  
<img width="571" height="401" alt="image" src="https://github.com/user-attachments/assets/b3622e28-9635-4aae-89b4-5df602e4ffab" />

---

🔍 **Key Insights**  

From the **menu perspective**, Edamame emerges as the most affordable item at \$5, while Shrimp Scampi sits at the top end at around \$20. The menu is heavily skewed toward **Italian and Mexican dishes**, with **American items underrepresented**, suggesting an opportunity to either expand or clearly position that segment.  

From the **orders side**, 5,370 orders generated 12,234 items sold, with the largest single order containing 14 items—evidence that some guests place large, sharable or family-style orders.  

When both tables were combined using a **LEFT JOIN**, more detailed patterns emerged. **Hamburgers** surfaced as the most frequently ordered item, while **chicken tacos** were the least popular. The highest-value single order (about \$190) consisted mostly of Italian dishes, reinforcing that **Italian cuisine is both popular and profitable** for Bistro Restaurant.  

---

💡 **Insights & Recommendations**  

- **Lean into Italian cuisine:** Given its strong role in high-value orders, consider adding seasonal Italian specials or premium variants to further grow revenue.  
- **Protect and promote bestsellers:** Items like **hamburgers** and **edamame** act as reliable anchors—feature them prominently on the menu and in combo deals.  
- **Revisit low performers:** Dishes like **chicken tacos** may need recipe improvements, rebranding, better placement on the menu, or targeted promotions—or, if they remain weak, potential removal.  
- **Design bundles around behaviour:** Large orders suggest demand for sharable platters or curated “family-style” sets, especially featuring top Italian and American favourites.  

Overall, the data suggests that doubling down on what customers already love, while refining or replacing weaker items, is the most effective path to a more profitable and customer-centric menu.

