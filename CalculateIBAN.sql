/*
#########################################################
Author:			Markus Begerow
Created on:		01.01.2023
Description:	Calculate IBAN for DE, AT & CH
Version:		1.0.0
#########################################################
*/

ALTER FUNCTION dbo.CalculateIBAN (
	@Country VARCHAR(2)
	,@AccountNumber VARCHAR(12)
	,@BankCode VARCHAR(8)
	)
RETURNS VARCHAR(22)
AS
BEGIN
	DECLARE @CountryCode VARCHAR(6);
	DECLARE @IBANKey VARCHAR(50);
	DECLARE @IBANChecksum VARCHAR(2);
	DECLARE @IBAN VARCHAR(50);
	DECLARE @IBANLength INTEGER

	IF @Country = 'DE'
	BEGIN
		SET @CountryCode = '1314';
		SET @IBANKey = @BankCode + RIGHT('0000000000' + @AccountNumber, 10) + @CountryCode + '00';
		SET @IBANLength = 22;
	END
	ELSE IF @Country = 'AT'
	BEGIN
		SET @CountryCode = '1029';
		SET @IBANKey = @BankCode + RIGHT('00000000000' + @AccountNumber, 11) + @CountryCode + '00';
		SET @IBANLength = 20;
	END
	ELSE IF @Country = 'CH'
	BEGIN
		SET @CountryCode = '1217';
		SET @IBANKey = @BankCode + RIGHT('000000000000' + @AccountNumber, 12) + @CountryCode + '00';
		SET @IBANLength = 21;
	END
	ELSE
	BEGIN
		SET @CountryCode = '1314';
		SET @IBANKey = @BankCode + RIGHT('00000000000' + @AccountNumber, 10) + @CountryCode + '00';
		SET @IBANLength = 22;
	END

	SET @IBANChecksum = 98 - (CAST(@IBANKey AS NUMERIC(38, 0)) % 97);
	SET @IBAN = @Country + RIGHT('00' + @IBANChecksum, 2) + LEFT(@IBANKey, @IBANLength - 4)

	RETURN @IBAN
END

