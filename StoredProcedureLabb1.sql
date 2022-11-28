CREATE PROCEDURE [sp_FlyttaBok] @MoveFrom integer, @MoveTo integer, @ISBN13 BIGINT, @Amount integer = 1 AS 
	--Ändra MoveFrom
	UPDATE InventoryBalance
	SET Amount -= @Amount
	WHERE ISBN13 = @ISBN13 AND Shop = @MoveFrom
	--Ändra MoveTo
	UPDATE InventoryBalance
	SET Amount += @Amount
	WHERE ISBN13 = @ISBN13 AND Shop = @MoveTo;