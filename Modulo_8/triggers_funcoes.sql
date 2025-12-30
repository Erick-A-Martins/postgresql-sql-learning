-- Funcao que marca uma copia como "loaned" apos inserir emprestimo
CREATE FUNCTION fn_mark_loaned() RETURNS TRIGGER AS $$
BEGIN
	UPDATE book_copies
	SET status = 'loaned'
	WHERE copy_id = NEW.copy_id;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger que chama a funcao apos insert em loans
CREATE TRIGGER trg_after_insert_loan
	AFTER INSERT ON loans
	FOR EACH ROW
	EXECUTE FUNCTION fn_mark_loaned();

INSERT INTO loans (copy_id, member_id, loan_date, due_date, return_date)
VALUES (1, 1, NOW(), CURRENT_DATE + INTERVAL '14 days', NULL);

-- Funcao que impede reserva se a copia nao estiver 'available'
CREATE FUNCTION fn_check_reserver() RETURNS TRIGGER AS $$
BEGIN 
	IF  (SELECT status FROM book_copies WHERE copy_id = NEW.copy_id) <> 'available' THEN
		RAISE EXCEPTION 'Cópia % não está disponível para reserva', NEW.copy_id;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_before_insert_reservation
	BEFORE INSERT ON reservations
	FOR EACH ROW
	EXECUTE FUNCTION fn_check_reserver();

INSERT INTO reservations (copy_id, member_id, reservation_date, status)
VALUES (2, 1, NOW(), 'active');