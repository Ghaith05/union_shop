## Feature: Static Homepage 

### 1. Feature Description and Purpose

The Static Homepage serves as the main landing page for the Union Shop Flutter application. Its primary purpose is to replicate the visual structure and static content of the official Union Shop website ([https://shop.upsu.net/](https://shop.upsu.net/)), focusing on a mobile-friendly layout. This initial page provides users with an overview of the shop's sections, including navigation, a prominent banner, product categories, featured items, and essential footer information. It lays the foundational UI structure for the application.

### 2. User Stories

#### 2.1. View Homepage Structure
- As a user, I want to land on a homepage when I open the app, so I can see the main sections of the Union Shop.
- As a user, I want the homepage to be mobile-friendly, so I can browse easily on my phone.

#### 2.2. View Static Content
- As a user, I want to see a static navigation bar at the top, so I can identify the app and potential actions (search, profile, cart).
- As a user, I want to see a hero banner section, so I get an immediate visual impression of the shop.
- As a user, I want to see a section displaying product categories, so I can explore different types of items available.
- As a user, I want to see a section previewing featured products, so I can quickly identify popular or highlighted items.
- As a user, I want to see a footer section, so I can find additional information and links.

### 3. Acceptance Criteria

#### 3.1. Layout and Structure
-  The app launches and displays the MyHomePage as the initial screen.
-  A static navigation bar (using AppBar) is present at the top of the page.
-  The main content area scrolls vertically using a ListView or similar widget.
-  A distinct Hero Banner section is displayed below the navbar.
-  A section for product Categories is displayed.
-  A section for Featured Products (or a product preview grid) is displayed.
-  A Footer section is displayed at the bottom of the scrollable content.
-  The layout adapts appropriately for different screen sizes, prioritizing mobile view.

#### 3.2. Static Content Display
-  The navigation bar includes the Union Shop logo (image) and action icons (search, profile, cart, menu).
-  The Hero Banner section displays a background image, headline text (Union Shop), subtext (Official union merch), and a primary button (Browse Products).
-  The Categories section displays a horizontal list (or grid) of category placeholders (icon and text, e.g., Category 1).
-  The Featured Products section displays a grid/list of product placeholders (image, name like Product 1, price like £12.00).
-  The Footer section displays static text (Union Shop, Help, Terms, Contact, copyright notice).

#### 3.3. UI Responsiveness
-  The layout renders correctly without overflow errors on a simulated mobile screen (e.g., using Chrome DevTools).
-  Elements are appropriately spaced using padding and margins.

### 4. Subtasks

1. Created the HomeScreen widget inside main.dart.
2. Added a placeholder ProductPage in product_page.dart.
3. Ensured the Browse Products button triggers navigation to the /product route.
4. Performed extraction and restoration cycles for the ProductCard widget (moved it out of main.dart then restored it inline based on development workflow preferences).
5. Created a widget test (home_test.dart) verifying the title, CTA button, featured products, and navigation functionality.
