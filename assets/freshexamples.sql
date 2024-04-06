--DEUTSCHE DATEN
INSERT INTO APPOINTMENT (appointment_date, start_time, end_time, text, description, location, participant_ids, reminder_time, platform_id, room_id, building_id, level_id)
VALUES
('2024-04-05', '2024-04-05 08:00:00', '2024-04-05 09:00:00', 'Team Meeting', 'Diskutiere Projektupdates', 'Konferenzraum 1', '1,2,3', '2024-04-12 09:00:00', 1, 1, 1, 1),
('2024-04-06', '2024-04-06 10:00:00', '2024-04-06 11:00:00', 'Kundenbesprechung', 'Überprüfung der Projektanforderungen', 'Konferenzraum 2', '4,5,6', '2024-04-12 09:00:00', 1, 2, 1, 1),
('2024-04-07', '2024-04-07 14:00:00', '2024-04-07 15:00:00', 'Schulungssitzung', 'Schulung für neue Software', 'Schulungsraum', '7,8,9', '2024-04-12 09:00:00', 2, 3, 2, 1),
('2024-04-08', '2024-04-08 09:00:00', '2024-04-08 10:00:00', 'Team Brainstorming', 'Ideenfindung für das kommende Projekt', 'Kreativraum', '10,11,12', '2024-04-12 09:00:00', 3, 4, 2, 2),
('2024-04-09', '2024-04-09 11:00:00', '2024-04-09 12:00:00', 'Vertriebsbesprechung', 'Diskutiere Vertriebsstrategie', 'Vertriebsbüro', '13,14,15', '2024-04-12 09:00:00', 3, 5, 2, 2),
('2024-04-10', '2024-04-10 15:00:00', '2024-04-10 16:00:00', 'Vorstellungsgespräch', 'Bewerbungsgespräch', 'HR Büro', '16', '2024-04-09 16:00:00', 4, 6, 3, 2),
('2024-04-11', '2024-04-11 16:00:00', '2024-04-11 17:00:00', 'Produktdemo', 'Demo für potenzielle Kunden', 'Demo Raum', '17,18,19', '2024-04-10 16:00:00', 4, 7, 3, 3),
('2024-04-12', '2024-04-12 13:00:00', '2024-04-12 14:00:00', 'Projektüberprüfung', 'Überprüfung des aktuellen Projektstatus', 'Projektraum', '20,21,22', '2024-04-11 16:00:00', 5, 8, 4, 3),
('2024-04-13', '2024-04-13 10:00:00', '2024-04-13 11:00:00', 'Teambildung', 'Teambildungsaktivitäten', 'Erholungsraum', '23,24,25', '2024-04-12 16:00:00', 5, 9, 4, 3),
('2024-04-14', '2024-04-14 11:00:00', '2024-04-14 12:00:00', 'Kundenmittagessen', 'Lockeres Mittagessen mit Kunden', 'Cafeteria', '26,27,28', '2024-04-13 16:00:00', 6, 10, 5, 4);

INSERT INTO USERS (email, password, sync_status)
VALUES
('l', 'l', 0),
('demo', 'demo123', 0);

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
('Meeting Reminder', 'Erinnerung: Treffen morgen', 'Sehr geehrte [Empfänger],\n\nHiermit möchten wir Sie daran erinnern, dass Sie morgen um [Uhrzeit] ein Treffen haben.\n\nMit freundlichen Grüßen,\n[Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Password Reset', 'Setzen Sie Ihr Passwort zurück', 'Sehr geehrte [Empfänger],\n\nBitte klicken Sie auf folgenden Link, um Ihr Passwort zurückzusetzen: [Link zurücksetzen].\n\nMit freundlichen Grüßen,\n[Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Welcome Email', 'Willkommen auf unserer Plattform', 'Sehr geehrte [Empfänger],\n\nWillkommen auf unserer Plattform! Wir freuen uns, Sie an Bord zu haben.\n\nMit freundlichen Grüßen,\n[Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Feedback Request', 'Wir möchten von Ihnen hören', 'Sehr geehrte [Empfänger],\n\nIhre Meinung ist uns wichtig. Bitte nehmen Sie sich einen Moment Zeit, um an unserer Umfrage teilzunehmen: [Umfragelink].\n\nMit freundlichen Grüßen,\n[Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Invoice Reminder', 'Erinnerung: Ausstehende Rechnung', 'Sehr geehrte [Empfänger],\n\nHiermit möchten wir Sie daran erinnern, dass Ihre Rechnung #[Rechnungsnummer] noch aussteht. Bitte leisten Sie die Zahlung so bald wie möglich.\n\nMit freundlichen Grüßen,\n[Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('New Order Confirmation', 'Auftragsbestätigung #[Auftragsnummer]', 'Sehr geehrte [Empfänger],\n\nVielen Dank für Ihre Bestellung #[Auftragsnummer]. Ihre Bestellung wurde bestätigt und wird in Kürze bearbeitet.\n\nMit freundlichen Grüßen,\n[Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Account Activation', 'Aktivieren Sie Ihr Konto', 'Sehr geehrte [Empfänger],\n\nBitte klicken Sie auf folgenden Link, um Ihr Konto zu aktivieren: [Aktivierungslink].\n\nMit freundlichen Grüßen,\n[Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Event Invitation', 'Sie sind eingeladen zu [Veranstaltungsname]', 'Sehr geehrte [Empfänger],\n\nSie sind herzlich eingeladen zu [Veranstaltungsname] am [Veranstaltungsdatum]. Bitte melden Sie sich bis zum [RSVP-Datum] an.\n\nMit freundlichen Grüßen,\n[Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Feedback Thank You', 'Danke für Ihr Feedback', 'Sehr geehrte [Empfänger],\n\nVielen Dank für Ihr wertvolles Feedback. Wir schätzen Ihre Meinung.\n\nMit freundlichen Grüßen,\n[Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Account Deactivation', 'Ihr Konto wurde deaktiviert', 'Sehr geehrte [Empfänger],\n\nHiermit möchten wir Sie darüber informieren, dass Ihr Konto deaktiviert wurde. Wenn Sie glauben, dass es sich um einen Fehler handelt, kontaktieren Sie bitte den Support.\n\nMit freundlichen Grüßen,\n[Ihre Firma]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0);

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
('jane@example.com', NULL, NULL, 'Meeting Reminder', 'Sehr geehrte Frau Smith,\n\nHiermit möchten wir Sie daran erinnern, dass Sie morgen um 10:00 Uhr ein Treffen haben.\n\nMit freundlichen Grüßen,\nIhre Firma', 1, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('user1@example.com', NULL, NULL, 'Setzen Sie Ihr Passwort zurück', 'Sehr geehrter Benutzer,\n\nBitte klicken Sie auf folgenden Link, um Ihr Passwort zurückzusetzen: [Link zurücksetzen].\n\nMit freundlichen Grüßen,\nIhre Firma', 2, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('john@example.com', 'jane@example.com', NULL, 'Willkommen auf unserer Plattform', 'Sehr geehrter John Doe,\n\nWillkommen auf unserer Plattform! Wir freuen uns, Sie an Bord zu haben.\n\nMit freundlichen Grüßen,\nIhre Firma', 3, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('emily@example.com', NULL, NULL, 'Wir möchten von Ihnen hören', 'Sehr geehrte Emily Brown,\n\nIhre Meinung ist uns wichtig. Bitte nehmen Sie sich einen Moment Zeit, um an unserer Umfrage teilzunehmen: [Umfragelink].\n\nMit freundlichen Grüßen,\nIhre Firma', 4, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('william@example.com', NULL, NULL, 'Erinnerung: Ausstehende Rechnung', 'Sehr geehrter William Wilson,\n\nHiermit möchten wir Sie daran erinnern, dass Ihre Rechnung #12345 noch aussteht. Bitte leisten Sie die Zahlung so bald wie möglich.\n\nMit freundlichen Grüßen,\nIhre Firma', 5, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('user2@example.com', NULL, NULL, 'Auftragsbestätigung #67890', 'Sehr geehrter Benutzer,\n\nVielen Dank für Ihre Bestellung #67890. Ihre Bestellung wurde bestätigt und wird in Kürze bearbeitet.\n\nMit freundlichen Grüßen,\nIhre Firma', 6, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('sophia@example.com', NULL, NULL, 'Aktivieren Sie Ihr Konto', 'Sehr geehrte Sophia Lee,\n\nBitte klicken Sie auf folgenden Link, um Ihr Konto zu aktivieren: [Aktivierungslink].\n\nMit freundlichen Grüßen,\nIhre Firma', 7, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('david@example.com', NULL, NULL, 'Sie sind eingeladen zu Schulungssitzung', 'Sehr geehrter David Taylor,\n\nSie sind herzlich eingeladen zu Schulungssitzung am 2024-04-07. Bitte melden Sie sich bis zum 2024-04-06 an.\n\nMit freundlichen Grüßen,\nIhre Firma', 8, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('olivia@example.com', NULL, NULL, 'Danke für Ihr Feedback', 'Sehr geehrte Olivia Anderson,\n\nVielen Dank für Ihr wertvolles Feedback. Wir schätzen Ihre Meinung.\n\nMit freundlichen Grüßen,\nIhre Firma', 9, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('james@example.com', NULL, NULL, 'Ihr Konto wurde deaktiviert', 'Sehr geehrter James Martinez,\n\nHiermit möchten wir Sie darüber informieren, dass Ihr Konto deaktiviert wurde. Wenn Sie glauben, dass es sich um einen Fehler handelt, kontaktieren Sie bitte den Support.\n\nMit freundlichen Grüßen,\nIhre Firma', 10, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0);

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--ENGLISCHE DATEN
INSERT INTO APPOINTMENT (appointment_date, start_time, end_time, text, description, location, participant_ids, reminder_time, created_at, updated_at, platform_id, room_id, building_id, level_id, DONE, sync_status)
VALUES
('2024-04-05', '08:00:00', '09:00:00', 'Team Meeting', 'Discuss project updates', 'Conference Room 1', '1,2,3', '2024-04-04 18:00:00', '2024-04-04 16:00:00', '2024-04-04 16:00:00', 1, 1, 1, 1, 1, 0),
('2024-04-06', '10:00:00', '11:00:00', 'Client Meeting', 'Review project requirements', 'Boardroom', '4,5,6', '2024-04-05 18:00:00', '2024-04-05 16:00:00', '2024-04-05 16:00:00', 1, 2, 1, 1, 0, 0),
('2024-04-07', '14:00:00', '15:00:00', 'Training Session', 'New software training', 'Training Room', '7,8,9', '2024-04-06 18:00:00', '2024-04-06 16:00:00', '2024-04-06 16:00:00', 2, 3, 2, 1, 0, 0),
('2024-04-08', '09:00:00', '10:00:00', 'Team Brainstorming', 'Ideation for upcoming project', 'Creative Room', '10,11,12', '2024-04-07 18:00:00', '2024-04-07 16:00:00', '2024-04-07 16:00:00', 3, 4, 2, 2, 1, 0),
('2024-04-09', '11:00:00', '12:00:00', 'Sales Meeting', 'Discuss sales strategy', 'Sales Office', '13,14,15', '2024-04-08 18:00:00', '2024-04-08 16:00:00', '2024-04-08 16:00:00', 3, 5, 2, 2, 0, 0),
('2024-04-10', '15:00:00', '16:00:00', 'Interview', 'Candidate interview', 'HR Office', '16', '2024-04-09 18:00:00', '2024-04-09 16:00:00', '2024-04-09 16:00:00', 4, 6, 3, 2, 0, 0),
('2024-04-11', '16:00:00', '17:00:00', 'Product Demo', 'Demo for potential clients', 'Demo Room', '17,18,19', '2024-04-10 18:00:00', '2024-04-10 16:00:00', '2024-04-10 16:00:00', 4, 7, 3, 3, 1, 0),
('2024-04-12', '13:00:00', '14:00:00', 'Project Review', 'Review current project status', 'Project Room', '20,21,22', '2024-04-11 18:00:00', '2024-04-11 16:00:00', '2024-04-11 16:00:00', 5, 8, 4, 3, 0, 0),
('2024-04-13', '10:00:00', '11:00:00', 'Team Building', 'Team bonding activities', 'Recreation Room', '23,24,25', '2024-04-12 18:00:00', '2024-04-12 16:00:00', '2024-04-12 16:00:00', 5, 9, 4, 3, 1, 0),
('2024-04-14', '11:00:00', '12:00:00', 'Client Lunch', 'Casual lunch with clients', 'Cafeteria', '26,27,28', '2024-04-13 18:00:00', '2024-04-13 16:00:00', '2024-04-13 16:00:00', 6, 10, 5, 4, 0, 0);

INSERT INTO USERS (email, password, sync_status)
VALUES
('user1@example.com', 'password123', 0),
('user2@example.com', 'securepass', 0),
('user3@example.com', 'letmein', 0),
('user4@example.com', 'password123', 0),
('user5@example.com', 'securepass', 0),
('user6@example.com', 'letmein', 0),
('user7@example.com', 'password123', 0),
('user8@example.com', 'securepass', 0),
('user9@example.com', 'letmein', 0),
('user10@example.com', 'password123', 0);

INSERT INTO LOG (action, table_name, record_id, old_data, new_data, sync_status)
VALUES
('INSERT', 'APPOINTMENT', 1, NULL, 'New appointment created', 0),
('UPDATE', 'APPOINTMENT', 2, 'Meeting postponed', 'New meeting time set', 0),
('DELETE', 'APPOINTMENT', 3, 'Canceled appointment', NULL, 0),
('INSERT', 'USERS', 1, NULL, 'New user registered', 0),
('UPDATE', 'USERS', 2, 'Change password', 'Password updated', 0),
('DELETE', 'USERS', 3, 'Inactive user deleted', NULL, 0),
('INSERT', 'BUILDING', 1, NULL, 'New building added', 0),
('UPDATE', 'BUILDING', 2, 'Update building details', 'Building description modified', 0),
('DELETE', 'BUILDING', 3, 'Old building demolished', NULL, 0),
('INSERT', 'LEVEL', 1, NULL, 'New level created', 0);

INSERT INTO LOG (action, table_name, record_id, old_data, new_data, sync_status)
VALUES
('INSERT', 'APPOINTMENT', 1, NULL, 'New appointment created', 0),
('UPDATE', 'APPOINTMENT', 2, 'Meeting postponed', 'New meeting time set', 0),
('DELETE', 'APPOINTMENT', 3, 'Canceled appointment', NULL, 0),
('INSERT', 'USERS', 1, NULL, 'New user registered', 0),
('UPDATE', 'USERS', 2, 'Change password', 'Password updated', 0),
('DELETE', 'USERS', 3, 'Inactive user deleted', NULL, 0),
('INSERT', 'BUILDING', 1, NULL, 'New building added', 0),
('UPDATE', 'BUILDING', 2, 'Update building details', 'Building description modified', 0),
('DELETE', 'BUILDING', 3, 'Old building demolished', NULL, 0),
('INSERT', 'LEVEL', 1, NULL, 'New level created', 0);

INSERT INTO SYNC_HISTORY (table_name, record_id, action, sync_status, response_code, response_message)
VALUES
('APPOINTMENT', 1, 'INSERT', 0, 200, 'Record synced successfully'),
('APPOINTMENT', 2, 'UPDATE', 0, 200, 'Record updated successfully'),
('APPOINTMENT', 3, 'DELETE', 0, 200, 'Record deleted successfully'),
('USERS', 1, 'INSERT', 0, 200, 'Record synced successfully'),
('USERS', 2, 'UPDATE', 0, 200, 'Record updated successfully'),
('USERS', 3, 'DELETE', 0, 200, 'Record deleted successfully'),
('BUILDING', 1, 'INSERT', 0, 200, 'Record synced successfully'),
('BUILDING', 2, 'UPDATE', 0, 200, 'Record updated successfully'),
('BUILDING', 3, 'DELETE', 0, 200, 'Record deleted successfully'),
('LEVEL', 1, 'INSERT', 0, 200, 'Record synced successfully');

INSERT INTO BUILDING (name, description, level_count, sync_status)
VALUES
('Office Building A', 'Headquarters', 5, 0),
('Warehouse', 'Storage facility', 3, 0),
('Retail Store', 'Sales outlet', 1, 0),
('Tech Park', 'Technology hub', 8, 0),
('Hospital', 'Medical center', 6, 0),
('Hotel', 'Accommodation facility', 10, 0),
('School', 'Educational institution', 4, 0),
('Mall', 'Shopping complex', 2, 0),
('Airport', 'Aviation terminal', 7, 0),
('Stadium', 'Sports arena', 1, 0);

INSERT INTO LEVEL (name, building_id, room_count, sync_status)
VALUES
('Ground Floor', 1, 10, 0),
('First Floor', 1, 8, 0),
('Second Floor', 1, 6, 0),
('Third Floor', 1, 6, 0),
('Fourth Floor', 1, 5, 0),
('Basement', 1, 4, 0),
('Main Floor', 2, 15, 0),
('Upper Level', 2, 10, 0),
('Lower Level', 2, 7, 0),
('Storage Level', 2, 5, 0);

INSERT INTO ROOM (name, level_id, access, sync_status)
VALUES
('Conference Room 1', 1, 1, 0),
('Conference Room 2', 1, 1, 0),
('Meeting Room A', 2, 1, 0),
('Meeting Room B', 2, 1, 0),
('Training Room', 3, 1, 0),
('Boardroom', 3, 1, 0),
('Creative Room', 4, 1, 0),
('Collaboration Room', 4, 1, 0),
('Breakout Room', 5, 1, 0),
('Focus Room', 5, 1, 0);

INSERT INTO PLATFORM (name, building_id, sync_status)
VALUES
('Internal Platform', 1, 0),
('External Platform', 2, 0),
('Customer Portal', 3, 0),
('Partner Portal', 4, 0),
('Vendor Portal', 5, 0),
('Admin Dashboard', 6, 0),
('Employee Intranet', 7, 0),
('Management System', 8, 0),
('Booking System', 9, 0),
('Support Portal', 10, 0);

INSERT INTO ADDRESS (title, first_name, last_name, email, second_email, phone_number, landline, position, street, city, postal_code, country, sync_status)
VALUES
('Mr.', 'John', 'Doe', 'john@example.com', 'john.doe@example.com', '1234567890', '0987654321', 'Manager', '123 Main St', 'New York', '10001', 'USA', 0),
('Ms.', 'Jane', 'Smith', 'jane@example.com', 'jane.smith@example.com', '9876543210', '0123456789', 'CEO', '456 Elm St', 'Los Angeles', '90001', 'USA', 0),
('Mr.', 'Michael', 'Johnson', 'michael@example.com', 'michael.johnson@example.com', '7418529630', '0369852147', 'Developer', '789 Oak St', 'Chicago', '60601', 'USA', 0),
('Ms.', 'Emily', 'Brown', 'emily@example.com', 'emily.brown@example.com', '3692581470', '0741852963', 'Marketing', '101 Pine St', 'San Francisco', '94101', 'USA', 0),
('Mr.', 'William', 'Wilson', 'william@example.com', 'william.wilson@example.com', '8523697410', '1472583690', 'Accountant', '202 Maple St', 'Houston', '77001', 'USA', 0),
('Ms.', 'Sophia', 'Lee', 'sophia@example.com', 'sophia.lee@example.com', '6549873210', '0129876543', 'HR Manager', '303 Cedar St', 'Boston', '02101', 'USA', 0),
('Mr.', 'David', 'Taylor', 'david@example.com', 'david.taylor@example.com', '1597534680', '0362148759', 'Sales', '404 Walnut St', 'Seattle', '98101', 'USA', 0),
('Ms.', 'Olivia', 'Anderson', 'olivia@example.com', 'olivia.anderson@example.com', '3691472580', '0741236985', 'Consultant', '505 Spruce St', 'Miami', '33101', 'USA', 0),
('Mr.', 'James', 'Martinez', 'james@example.com', 'james.martinez@example.com', '8527419630', '1478523690', 'Manager', '606 Birch St', 'Dallas', '75201', 'USA', 0),
('Ms.', 'Emma', 'Garcia', 'emma@example.com', 'emma.garcia@example.com', '9876541230', '0123457896', 'Designer', '707 Oak St', 'Atlanta', '30301', 'USA', 0);

INSERT INTO EMAIL_TEMPLATE (name, subject, body, created_at, updated_at, sync_status)
VALUES
('Meeting Reminder', 'Reminder: Meeting Tomorrow', 'Dear [Recipient],\n\nThis is a reminder that you have a meeting scheduled for tomorrow at [Time].\n\nBest regards,\n[Your Company]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Password Reset', 'Reset Your Password', 'Dear [Recipient],\n\nPlease click on the following link to reset your password: [Reset Link].\n\nBest regards,\n[Your Company]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Welcome Email', 'Welcome to Our Platform', 'Dear [Recipient],\n\nWelcome to our platform! We are excited to have you on board.\n\nBest regards,\n[Your Company]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Feedback Request', 'We Want to Hear from You', 'Dear [Recipient],\n\nWe value your feedback. Please take a moment to fill out our survey: [Survey Link].\n\nBest regards,\n[Your Company]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Invoice Reminder', 'Reminder: Outstanding Invoice', 'Dear [Recipient],\n\nThis is a reminder that your invoice #[Invoice Number] is still outstanding. Please make payment at your earliest convenience.\n\nBest regards,\n[Your Company]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('New Order Confirmation', 'Order Confirmation #[Order Number]', 'Dear [Recipient],\n\nThank you for your order #[Order Number]. Your order has been confirmed and will be processed shortly.\n\nBest regards,\n[Your Company]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Account Activation', 'Activate Your Account', 'Dear [Recipient],\n\nPlease click on the following link to activate your account: [Activation Link].\n\nBest regards,\n[Your Company]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Event Invitation', 'Youre Invited to [Event Name]', 'Dear [Recipient],\n\nYou are cordially invited to [Event Name] on [Event Date]. Please RSVP by [RSVP Date].\n\nBest regards,\n[Your Company]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Feedback Thank You', 'Thank You for Your Feedback', 'Dear [Recipient],\n\nThank you for providing your valuable feedback. We appreciate your input.\n\nBest regards,\n[Your Company]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0),
('Account Deactivation', 'Your Account Has Been Deactivated', 'Dear [Recipient],\n\nThis is to inform you that your account has been deactivated. If you believe this is an error, please contact support.\n\nBest regards,\n[Your Company]', '2024-04-05 12:00:00', '2024-04-05 12:00:00', 0);

INSERT INTO EMAIL_CATEGORY (name, sync_status)
VALUES
('Meeting', 0),
('Password Reset', 0),
('Welcome', 0),
('Feedback', 0),
('Invoice', 0),
('Order Confirmation', 0),
('Account', 0),
('Event', 0),
('Feedback Thank You', 0),
('Account Deactivation', 0);

INSERT INTO EMAIL (recipient, cc, bcc, subject, body, template_id, created_at, updated_at, sync_status)
VALUES
('jane@example.com', NULL, NULL, 'Meeting Reminder', 'Dear Jane,\n\nThis is a reminder that you have a meeting scheduled for tomorrow at 10:00 AM.\n\nBest regards,\nYour Company', 1, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('user1@example.com', NULL, NULL, 'Password Reset', 'Dear User,\n\nPlease click on the following link to reset your password: [Reset Link].\n\nBest regards,\nYour Company', 2, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('user2@example.com', NULL, NULL, 'Welcome to Our Platform', 'Dear User,\n\nWelcome to our platform! We are excited to have you on board.\n\nBest regards,\nYour Company', 3, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('user3@example.com', NULL, NULL, 'We Want to Hear from You', 'Dear User,\n\nWe value your feedback. Please take a moment to fill out our survey: [Survey Link].\n\nBest regards,\nYour Company', 4, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('user4@example.com', NULL, NULL, 'Reminder: Outstanding Invoice', 'Dear User,\n\nThis is a reminder that your invoice #12345 is still outstanding. Please make payment at your earliest convenience.\n\nBest regards,\nYour Company', 5, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('user5@example.com', NULL, NULL, 'Order Confirmation #67890', 'Dear User,\n\nThank you for your order #67890. Your order has been confirmed and will be processed shortly.\n\nBest regards,\nYour Company', 6, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('user6@example.com', NULL, NULL, 'Activate Your Account', 'Dear User,\n\nPlease click on the following link to activate your account: [Activation Link].\n\nBest regards,\nYour Company', 7, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('user7@example.com', NULL, NULL, 'Youre Invited to [Event Name]', 'Dear User,\n\nYou are cordially invited to [Event Name] on [Event Date]. Please RSVP by [RSVP Date].\n\nBest regards,\nYour Company', 8, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('user8@example.com', NULL, NULL, 'Thank You for Your Feedback', 'Dear User,\n\nThank you for providing your valuable feedback. We appreciate your input.\n\nBest regards,\nYour Company', 9, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0),
('user9@example.com', NULL, NULL, 'Your Account Has Been Deactivated', 'Dear User,\n\nThis is to inform you that your account has been deactivated. If you believe this is an error, please contact support.\n\nBest regards,\nYour Company', 10, '2024-04-05 14:00:00', '2024-04-05 14:00:00', 0);
