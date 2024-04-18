--DEUTSCHE DATEN
INSERT INTO APPOINTMENT (id,appointment_date, start_time, end_time, text, description, location, participant_ids, reminder_time, platform_id, room_id, building_id, level_id)
VALUES
(1,'2024-04-05', '08:00:00', '09:00:00', 'Team Meeting', 'Diskutiere Projektupdates', 'Konferenzraum 1', '1,2,3', '2024-04-12 09:00:00', 1, 1, 1, 1),
(2,'2024-04-06', '10:00:00', '11:00:00', 'Kundenbesprechung', 'Überprüfung der Projektanforderungen', 'Konferenzraum 2', '4,5,6', '2024-04-12 09:00:00', 1, 2, 1, 1),
(3,'2024-04-07', '14:00:00', '15:00:00', 'Schulungssitzung', 'Schulung für neue Software', 'Schulungsraum', '7,8,9', '2024-04-12 09:00:00', 2, 3, 2, 1),
(4,'2024-04-08', '09:00:00', '10:00:00', 'Team Brainstorming', 'Ideenfindung für das kommende Projekt', 'Kreativraum', '10,11,12', '2024-04-12 09:00:00', 3, 4, 2, 2),
(5,'2024-04-09', '11:00:00', '12:00:00', 'Vertriebsbesprechung', 'Diskutiere Vertriebsstrategie', 'Vertriebsbüro', '13,14,15', '2024-04-12 09:00:00', 3, 5, 2, 2),
(6,'2024-04-10', '15:00:00', '16:00:00', 'Vorstellungsgespräch', 'Bewerbungsgespräch', 'HR Büro', '16', '2024-04-09 16:00:00', 4, 6, 3, 2),
(7,'2024-04-11', '16:00:00', '17:00:00', 'Produktdemo', 'Demo für potenzielle Kunden', 'Demo Raum', '17,18,19', '2024-04-10 16:00:00', 4, 7, 3, 3),
(8,'2024-04-12', '13:00:00', '14:00:00', 'Projektüberprüfung', 'Überprüfung des aktuellen Projektstatus', 'Projektraum', '20,21,22', '2024-04-11 16:00:00', 5, 8, 4, 3),
(9,'2024-04-13', '10:00:00', '11:00:00', 'Teambildung', 'Teambildungsaktivitäten', 'Erholungsraum', '23,24,25', '2024-04-12 16:00:00', 5, 9, 4, 3),
(10,'2024-04-14', '11:00:00', '12:00:00', 'Kundenmittagessen', 'Lockeres Mittagessen mit Kunden', 'Cafeteria', '26,27,28', '2024-04-13 16:00:00', 6, 10, 5, 4);

INSERT INTO USERS (email, password, sync_status)
VALUES
('oli', 'pw123', 0),
('l', 'l', 0);

INSERT INTO LOG (action, table_name, record_id, old_data, new_data, sync_status)
VALUES
('INSERT', 'APPOINTMENT', 1, NULL, 'Neue Terminvereinbarung erstellt', 0),
('UPDATE', 'APPOINTMENT', 2, 'Besprechung verschoben', 'Neue Besprechungszeit festgelegt', 0),
('DELETE', 'APPOINTMENT', 3, 'Abgesagter Termin', NULL, 0),
('INSERT', 'USERS', 1, NULL, 'Neuer Benutzer registriert', 0),
('UPDATE', 'USERS', 2, 'Passwortänderung', 'Passwort aktualisiert', 0),
('DELETE', 'USERS', 3, 'Inaktiver Benutzer gelöscht', NULL, 0),
('INSERT', 'BUILDING', 1, NULL, 'Neues Gebäude hinzugefügt', 0),
('UPDATE', 'BUILDING', 2, 'Gebäudedetails aktualisieren', 'Gebäudebeschreibung geändert', 0),
('DELETE', 'BUILDING', 3, 'Altes Gebäude abgerissen', NULL, 0),
('INSERT', 'LEVEL', 1, NULL, 'Neues Level erstellt', 0);

INSERT INTO SYNC_HISTORY (table_name, record_id, action, sync_status, response_code, response_message)
VALUES
('APPOINTMENT', 1, 'INSERT', 0, 200, 'Datensatz erfolgreich synchronisiert'),
('APPOINTMENT', 2, 'UPDATE', 0, 200, 'Datensatz erfolgreich aktualisiert'),
('APPOINTMENT', 3, 'DELETE', 0, 200, 'Datensatz erfolgreich gelöscht'),
('USERS', 1, 'INSERT', 0, 200, 'Datensatz erfolgreich synchronisiert'),
('USERS', 2, 'UPDATE', 0, 200, 'Datensatz erfolgreich aktualisiert'),
('USERS', 3, 'DELETE', 0, 200, 'Datensatz erfolgreich gelöscht'),
('BUILDING', 1, 'INSERT', 0, 200, 'Datensatz erfolgreich synchronisiert'),
('BUILDING', 2, 'UPDATE', 0, 200, 'Datensatz erfolgreich aktualisiert'),
('BUILDING', 3, 'DELETE', 0, 200, 'Datensatz erfolgreich gelöscht'),
('LEVEL', 1, 'INSERT', 0, 200, 'Datensatz erfolgreich synchronisiert');

INSERT INTO BUILDING (name, description, level_count, sync_status)
VALUES
('Bürogebäude A', 'Hauptsitz', 5, 0),
('Lagerhaus', 'Lageranlage', 3, 0),
('Einzelhandelsgeschäft', 'Verkaufsstelle', 1, 0),
('Technologiepark', 'Technologiezentrum', 8, 0),
('Krankenhaus', 'Medizinisches Zentrum', 6, 0),
('Hotel', 'Unterkunftseinrichtung', 10, 0),
('Schule', 'Bildungseinrichtung', 4, 0),
('Einkaufszentrum', 'Einkaufskomplex', 2, 0),
('Flughafen', 'Flughafenterminal', 7, 0),
('Stadion', 'Sportarena', 1, 0);

INSERT INTO LEVEL (name, building_id, room_count, sync_status)
VALUES
('Erdgeschoss', 1, 10, 0),
('Erster Stock', 1, 8, 0),
('Zweiter Stock', 1, 6, 0),
('Dritter Stock', 1, 6, 0),
('Vierter Stock', 1, 5, 0),
('Keller', 1, 4, 0),
('Hauptebene', 2, 15, 0),
('Obere Ebene', 2, 10, 0),
('Untere Ebene', 2, 7, 0),
('Lagerebene', 2, 5, 0);

INSERT INTO ROOM (name, level_id, access, sync_status)
VALUES
('Konferenzraum 1', 1, 1, 0),
('Konferenzraum 2', 1, 1, 0),
('Besprechungsraum A', 2, 1, 0),
('Besprechungsraum B', 2, 1, 0),
('Schulungsraum', 3, 1, 0),
('Boardroom', 3, 1, 0),
('Kreativraum', 4, 1, 0),
('Kollaborationsraum', 4, 1, 0),
('Breakout-Raum', 5, 1, 0),
('Fokusraum', 5, 1, 0);

INSERT INTO PLATFORM (name, building_id, sync_status)
VALUES
('Internes System', 1, 0),
('Externes System', 2, 0),
('Kundenportal', 3, 0),
('Partnerportal', 4, 0),
('Lieferantenportal', 5, 0),
('Admin-Dashboard', 6, 0),
('Mitarbeiter-Intranet', 7, 0),
('Management-System', 8, 0),
('Buchungssystem', 9, 0),
('Support-Portal', 10, 0);

INSERT INTO ADDRESS (title, first_name, last_name, email, second_email, phone_number, landline, position, street, city, postal_code, country, sync_status)
VALUES
('Herr', 'John', 'Doe', 'john@example.com', 'john.doe@example.com', '1234567890', '0987654321', 'Manager', '123 Hauptstraße', 'New York', '10001', 'USA', 0),
('Frau', 'Jane', 'Smith', 'jane@example.com', 'jane.smith@example.com', '9876543210', '0123456789', 'CEO', '456 Elmstraße', 'Los Angeles', '90001', 'USA', 0),
('Herr', 'Michael', 'Johnson', 'michael@example.com', 'michael.johnson@example.com', '7418529630', '0369852147', 'Entwickler', '789 Eichenstraße', 'Chicago', '60601', 'USA', 0),
('Frau', 'Emily', 'Brown', 'emily@example.com', 'emily.brown@example.com', '3692581470', '0741852963', 'Marketing', '101 Kieferstraße', 'San Francisco', '94101', 'USA', 0),
('Herr', 'William', 'Wilson', 'william@example.com', 'william.wilson@example.com', '8523697410', '1472583690', 'Buchhalter', '202 Ahornstraße', 'Houston', '77001', 'USA', 0),
('Frau', 'Sophia', 'Lee', 'sophia@example.com', 'sophia.lee@example.com', '6549873210', '0129876543', 'HR Manager', '303 Zedernstraße', 'Boston', '02101', 'USA', 0),
('Herr', 'David', 'Taylor', 'david@example.com', 'david.taylor@example.com', '1597534680', '0362148759', 'Vertrieb', '404 Walnussstraße', 'Seattle', '98101', 'USA', 0),
('Frau', 'Olivia', 'Anderson', 'olivia@example.com', 'olivia.anderson@example.com', '3691472580', '0741236985', 'Berater', '505 Fichtenstraße', 'Miami', '33101', 'USA', 0),
('Herr', 'James', 'Martinez', 'james@example.com', 'james.martinez@example.com', '8527419630', '1478523690', 'Manager', '606 Birkenstraße', 'Dallas', '75201', 'USA', 0),
('Frau', 'Emma', 'Garcia', 'emma@example.com', 'emma.garcia@example.com', '9876541230', '0123457896', 'Designer', '707 Eichenstraße', 'Atlanta', '30301', 'USA', 0);

INSERT INTO EMAIL_TEMPLATE (name, subject, body, created_at, updated_at, sync_status)
VALUES
('Meeting Reminder', 'Erinnerung: Treffen morgen', 'Sehr geehrte Damen und Herren,Hiermit möchten wir Sie daran erinnern, dass Sie morgen um [Uhrzeit] ein Treffen haben.  Mit freundlichen Grüßen,  [Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Password Reset', 'Setzen Sie Ihr Passwort zurück', 'Sehr geehrte Damen und Herren,  Bitte klicken Sie auf folgenden Link, um Ihr Passwort zurückzusetzen: [Link zurücksetzen].  Mit freundlichen Grüßen,  [Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Welcome Email', 'Willkommen auf unserer Plattform', 'Sehr geehrte Damen und Herren,  Willkommen auf unserer Plattform! Wir freuen uns, Sie an Bord zu haben.  Mit freundlichen Grüßen,  [Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Feedback Request', 'Wir möchten von Ihnen hören', 'Sehr geehrte Damen und Herren,  Ihre Meinung ist uns wichtig. Bitte nehmen Sie sich einen Moment Zeit, um an unserer Umfrage teilzunehmen: [Umfragelink].  Mit freundlichen Grüßen,  [Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Invoice Reminder', 'Erinnerung: Ausstehende Rechnung', 'Sehr geehrte Damen und Herren,  Hiermit möchten wir Sie daran erinnern, dass Ihre Rechnung #[Rechnungsnummer] noch aussteht. Bitte leisten Sie die Zahlung so bald wie möglich.  Mit freundlichen Grüßen,  [Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('New Order Confirmation', 'Auftragsbestätigung #[Auftragsnummer]', 'Sehr geehrte Damen und Herren,  Vielen Dank für Ihre Bestellung #[Auftragsnummer]. Ihre Bestellung wurde bestätigt und wird in Kürze bearbeitet.  Mit freundlichen Grüßen,  [Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Account Activation', 'Aktivieren Sie Ihr Konto', 'Sehr geehrte Damen und Herren,  Bitte klicken Sie auf folgenden Link, um Ihr Konto zu aktivieren: [Aktivierungslink].  Mit freundlichen Grüßen,  [Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Event Invitation', 'Sie sind eingeladen zu [Veranstaltungsname]', 'Sehr geehrte Damen und Herren,  Sie sind herzlich eingeladen zu [Veranstaltungsname] am [Veranstaltungsdatum]. Bitte melden Sie sich bis zum [RSVP-Datum] an.  Mit freundlichen Grüßen,  [Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Feedback Thank You', 'Danke für Ihr Feedback', 'Sehr geehrte Damen und Herren,  Vielen Dank für Ihr wertvolles Feedback. Wir schätzen Ihre Meinung.  Mit freundlichen Grüßen,  [Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Account Deactivation', 'Ihr Konto wurde deaktiviert', 'Sehr geehrte Damen und Herren,  Hiermit möchten wir Sie darüber informieren, dass Ihr Konto deaktiviert wurde. Wenn Sie glauben, dass es sich um einen Fehler handelt, kontaktieren Sie bitte den Support.  Mit freundlichen Grüßen,  [Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0);

INSERT INTO EMAIL_CATEGORY (name, sync_status)
VALUES
('Treffen', 0),
('Passwort zurücksetzen', 0),
('Willkommen', 0),
('Feedback', 0),
('Rechnung', 0),
('Auftragsbestätigung', 0),
('Konto', 0),
('Veranstaltung', 0),
('Feedback Danke', 0),
('Konto Deaktivierung', 0);

INSERT INTO EMAIL (recipient, cc, bcc, subject, body, template_id, created_at, updated_at, sync_status)
VALUES
('jane@example.com', NULL, NULL, 'Meeting Reminder', 'Sehr geehrte Frau Smith,  Hiermit möchten wir Sie daran erinnern, dass Sie morgen um 10:00 Uhr ein Treffen haben.  Mit freundlichen Grüßen,  Ihre Firma', 1, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('user1@example.com', NULL, NULL, 'Setzen Sie Ihr Passwort zurück', 'Sehr geehrter Benutzer,  Bitte klicken Sie auf folgenden Link, um Ihr Passwort zurückzusetzen: [Link zurücksetzen].  Mit freundlichen Grüßen,  Ihre Firma', 2, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('john@example.com', 'jane@example.com', NULL, 'Willkommen auf unserer Plattform', 'Sehr geehrter John Doe,  Willkommen auf unserer Plattform! Wir freuen uns, Sie an Bord zu haben.  Mit freundlichen Grüßen,  Ihre Firma', 3, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('emily@example.com', NULL, NULL, 'Wir möchten von Ihnen hören', 'Sehr geehrte Emily Brown,  Ihre Meinung ist uns wichtig. Bitte nehmen Sie sich einen Moment Zeit, um an unserer Umfrage teilzunehmen: [Umfragelink].  Mit freundlichen Grüßen,  Ihre Firma', 4, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('william@example.com', NULL, NULL, 'Erinnerung: Ausstehende Rechnung', 'Sehr geehrter William Wilson,  Hiermit möchten wir Sie daran erinnern, dass Ihre Rechnung #12345 noch aussteht. Bitte leisten Sie die Zahlung so bald wie möglich.  Mit freundlichen Grüßen,  Ihre Firma', 5, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('user2@example.com', NULL, NULL, 'Auftragsbestätigung #67890', 'Sehr geehrter Benutzer,  Vielen Dank für Ihre Bestellung #67890. Ihre Bestellung wurde bestätigt und wird in Kürze bearbeitet.  Mit freundlichen Grüßen,  Ihre Firma', 6, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('sophia@example.com', NULL, NULL, 'Aktivieren Sie Ihr Konto', 'Sehr geehrte Sophia Lee,  Bitte klicken Sie auf folgenden Link, um Ihr Konto zu aktivieren: [Aktivierungslink].  Mit freundlichen Grüßen,  Ihre Firma', 7, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('david@example.com', NULL, NULL, 'Sie sind eingeladen zu Schulungssitzung', 'Sehr geehrter David Taylor,  Sie sind herzlich eingeladen zu Schulungssitzung am 2024-04-07. Bitte melden Sie sich bis zum 2024-04-06 an.  Mit freundlichen Grüßen,  Ihre Firma', 8, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('olivia@example.com', NULL, NULL, 'Danke für Ihr Feedback', 'Sehr geehrte Olivia Anderson,  Vielen Dank für Ihr wertvolles Feedback. Wir schätzen Ihre Meinung.  Mit freundlichen Grüßen,  Ihre Firma', 9, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('james@example.com', NULL, NULL, 'Ihr Konto wurde deaktiviert', 'Sehr geehrter James Martinez,  Hiermit möchten wir Sie darüber informieren, dass Ihr Konto deaktiviert wurde. Wenn Sie glauben, dass es sich um einen Fehler handelt, kontaktieren Sie bitte den Support.  Mit freundlichen Grüßen,  Ihre Firma', 10, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0);

INSERT INTO EMAIL_VARIABLE (name, description, source_table, source_field, default_value, data_type, required, format)
VALUES
  ('Bestellnummer', 'Die Nummer der Bestellung', 'Orders', 'order_number', NULL, 'TEXT', 1, NULL),
  ('Kundenname', 'Der Name des Kunden', 'Orders', 'customer_name', NULL, 'TEXT', 1, NULL),
  ('Artikelnummer', 'Die Nummer des bestellten Artikels', 'Order_Items', 'item_number', NULL, 'TEXT', 1, NULL),
  ('Artikelname', 'Der Name des bestellten Artikels', 'Order_Items', 'item_name', NULL, 'TEXT', 1, NULL),
  ('Menge', 'Die bestellte Menge des Artikels', 'Order_Items', 'quantity', '1', 'INTEGER', 1, NULL),
  ('Bestelldatum', 'Das Datum der Bestellung', 'Orders', 'order_date', NULL, 'TEXT', 1, 'YYYY-MM-DD'),
  ('Lieferdatum', 'Das erwartete Lieferdatum der Bestellung', 'Orders', 'expected_delivery_date', NULL, 'TEXT', 0, 'YYYY-MM-DD'),
  ('Status', 'Der Status der Bestellung', 'Orders', 'status', 'Pending', 'TEXT', 1, NULL),
  ('Kundenemail', 'Die E-Mail-Adresse des Kunden', 'Customers', 'email', NULL, 'TEXT', 1, NULL),
  ('Kundenadresse', 'Die Adresse des Kunden', 'Customers', 'address', NULL, 'TEXT', 0, NULL);
