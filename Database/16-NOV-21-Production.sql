PGDMP         1            
    y            oaic    13.2    13.3 %   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16384    oaic    DATABASE     Y   CREATE DATABASE oaic WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_IN.UTF-8';
    DROP DATABASE oaic;
                postgres    false                       1255    24833    Paymnet_Insert_MR()    FUNCTION     �  CREATE FUNCTION public."Paymnet_Insert_MR"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF(NEW.purpose = 'advanceCustomerPayment' OR NEW.purpose = 'customerPaymentAgainstInvoice' OR NEW.purpose = 'farmerAdvancePayment')
	THEN
		NEW."MoneyReceiptNo"= (SELECT "DistCode" FROM "DistrictMaster" WHERE dist_id=NEW."PayToID") || '/MR/' || NEW."fin_year" ||'/' || ( (SELECT COALESCE ( max(cast( COALESCE(split_part("MoneyReceiptNo", '/', 4), '0') as int ) ), 0 ) as max FROM "payment" WHERE "fin_year" = NEW."fin_year" AND "PayToID" = NEW."PayToID") + 1);
	END IF;
	IF(NEW.payment_type = 'Cash')
	THEN
		NEW.payment_no = NEW."MoneyReceiptNo";
	END IF;
	RETURN NEW;
END
$$;
 ,   DROP FUNCTION public."Paymnet_Insert_MR"();
       public          postgres    false                       1255    24778    UpdateDeliveredQuantity()    FUNCTION     �  CREATE FUNCTION public."UpdateDeliveredQuantity"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF(NEW."DeliveredQuantity" IS NOT NULL) 
	THEN
		NEW."DeliveredQuantity" = CAST(OLD."DeliveredQuantity" AS INT) + CAST(NEW."DeliveredQuantity" AS INT);
		NEW."PendingQuantity" = CAST(OLD."ItemQuantity" AS INT) - CAST(NEW."DeliveredQuantity" AS INT);
		
		IF(OLD."ItemQuantity" = NEW."DeliveredQuantity")
		THEN
			NEW."IsDelivered" = 'true';
		END IF;
	END IF;
	RETURN NEW;
END
$$;
 2   DROP FUNCTION public."UpdateDeliveredQuantity"();
       public          postgres    false            )           1255    24848    addCustomerInvoiceMaster()    FUNCTION       CREATE FUNCTION public."addCustomerInvoiceMaster"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
--	IF(NEW.purpose = 'advanceCustomerPayment' OR NEW.purpose = 'customerPaymentAgainstInvoice' OR NEW.purpose = 'farmerAdvancePayment')
--	THEN
--		NEW."MoneyReceiptNo"= (SELECT "DistCode" FROM "DistrictMaster" WHERE dist_id=NEW."PayToID") || '/MR/' || NEW."fin_year" ||'/' || ( (SELECT COALESCE ( max( cast( COALESCE(split_part("MoneyReceiptNo", '/', 4), '0') as int ) ), 0 ) as max FROM "payment" WHERE "fin_year" = NEW."fin_year" AND "PayToID" = NEW."PayToID") + 1);
--	END IF;
	IF(NEW."POType" = 'Subsidy')
	THEN
		UPDATE public."POMaster" SET "IsDeliveredToCustomer"='true' WHERE "PONo"=NEW."PONo" AND "OrderReferenceNo" = NEW."OrderReferenceNo";
	END IF;
	RETURN NEW;
END
$$;
 3   DROP FUNCTION public."addCustomerInvoiceMaster"();
       public          postgres    false                       1255    24593    update_invoice_number()    FUNCTION     R  CREATE FUNCTION public.update_invoice_number() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."POMaster"
	SET "DeliveredQuantity"=NEW."SupplyQuantity", "EngineNumber"=NEW."EngineNumber", "ChassicNumber"=NEW."ChassicNumber"
	WHERE "PONo"=NEW."PONo" AND "OrderReferenceNo"=NEW."OrderReferenceNo";
	RETURN NULL;
END
$$;
 .   DROP FUNCTION public.update_invoice_number();
       public          postgres    false                       1255    24595    update_mrr_id()    FUNCTION     �  CREATE FUNCTION public.update_mrr_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."POMaster"
	SET "MRRID"=NEW."MRRNo", "IsReceived"='true'
	WHERE "PONo"=NEW."PONo" AND "OrderReferenceNo" = NEW."OrderReferenceNo";
	
	UPDATE public."InvoiceMaster"
	SET "ReceivedDate"='NOW()', "IsReceived"='true', "MRRNo"=NEW."MRRNo"
	WHERE  "InvoiceNo"=NEW."InvoiceNo" AND "PONo"=NEW."PONo" AND  "OrderReferenceNo" = NEW."OrderReferenceNo";
	RETURN NULL;
END
$$;
 &   DROP FUNCTION public.update_mrr_id();
       public          postgres    false                       1255    24596    update_order_po_intiate()    FUNCTION     �   CREATE FUNCTION public.update_order_po_intiate() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."orders"
	SET "status"='indent_initiated'
	WHERE "permit_no"=NEW."OrderReferenceNo";
	RETURN NULL;
END
$$;
 0   DROP FUNCTION public.update_order_po_intiate();
       public          postgres    false            �            1259    16385    AccountantMaster    TABLE     k  CREATE TABLE public."AccountantMaster" (
    acc_name character varying(225),
    acc_id character varying(30) NOT NULL,
    dist_id character varying(2) NOT NULL,
    dist_name character varying(30),
    acc_address character varying(1000),
    acc_mobile_no character varying(15),
    "UpdateOn" timestamp without time zone,
    "UpdateBy" character varying
);
 &   DROP TABLE public."AccountantMaster";
       public         heap    postgres    false                       1259    24841 
   BankMaster    TABLE     t   CREATE TABLE public."BankMaster" (
    "BankID" integer NOT NULL,
    "BankName" character varying(255) NOT NULL
);
     DROP TABLE public."BankMaster";
       public         heap    postgres    false                       1259    24839    BankMaster_BankID_seq    SEQUENCE     �   CREATE SEQUENCE public."BankMaster_BankID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."BankMaster_BankID_seq";
       public          postgres    false    280            �           0    0    BankMaster_BankID_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public."BankMaster_BankID_seq" OWNED BY public."BankMaster"."BankID";
          public          postgres    false    279                       1259    24688    CustomerBankAccount    TABLE     :  CREATE TABLE public."CustomerBankAccount" (
    id integer NOT NULL,
    "CustomerID" character varying(255),
    "BankAccountID" integer,
    "bankAccountNo" character varying(255) NOT NULL,
    "accountType" character varying(255) NOT NULL,
    "bankName" character varying(255) NOT NULL,
    "branchName" character varying(255) NOT NULL,
    "ifscCode" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255)
);
 )   DROP TABLE public."CustomerBankAccount";
       public         heap    postgres    false                       1259    24686    CustomerBankAccount_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerBankAccount_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CustomerBankAccount_id_seq";
       public          postgres    false    268            �           0    0    CustomerBankAccount_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."CustomerBankAccount_id_seq" OWNED BY public."CustomerBankAccount".id;
          public          postgres    false    267                       1259    24661    CustomerContactPerson    TABLE     �  CREATE TABLE public."CustomerContactPerson" (
    id integer NOT NULL,
    "CustomerID" character varying(255),
    "ContactPersonID" integer,
    "AuthorisedName" character varying(255),
    "AuthorisedMobileNo" character varying(255),
    "AuthorisedEmailID" character varying(255),
    "Designation" character varying(255),
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255)
);
 +   DROP TABLE public."CustomerContactPerson";
       public         heap    postgres    false                       1259    24659    CustomerContactPerson_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerContactPerson_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."CustomerContactPerson_id_seq";
       public          postgres    false    264            �           0    0    CustomerContactPerson_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."CustomerContactPerson_id_seq" OWNED BY public."CustomerContactPerson".id;
          public          postgres    false    263                       1259    24757    CustomerDistrictMapping    TABLE     �   CREATE TABLE public."CustomerDistrictMapping" (
    "CustomerID" character varying(255) NOT NULL,
    "DistrictID" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL
);
 -   DROP TABLE public."CustomerDistrictMapping";
       public         heap    postgres    false                       1259    24781    CustomerInvoiceMaster    TABLE     n  CREATE TABLE public."CustomerInvoiceMaster" (
    "CustomerInvoiceNo" character varying(255) NOT NULL,
    "MRRNo" character varying(255),
    "InvoiceNo" character varying(255),
    "PONo" character varying(255),
    "OrderReferenceNo" character varying(255) NOT NULL,
    "POType" character varying(255),
    "FinYear" character varying(255),
    "DistrictID" character varying(255),
    "VendorID" character varying(255),
    "InvoiceAmount" character varying(255),
    "NoOfOrderDeliver" character varying(255) NOT NULL,
    "DeliveredQuantity" character varying(255),
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255),
    "CustomerID" character varying,
    "DivisionID" character varying,
    "Implement" character varying,
    "Make" character varying,
    "Model" character varying,
    "HSN" character varying,
    "UnitOfMeasurement" character varying,
    "PackageSize" character varying,
    "PackageUnitOfMeasurement" character varying,
    "PackageQuantity" integer,
    "ItemQuantity" integer,
    "TaxRate" integer,
    "RatePerUnit" numeric(20,2),
    "PurchaseInvoiceValue" numeric(20,2),
    "PurchaseCGST" numeric(20,2),
    "PurchaseSGST" numeric(20,2),
    "PurchaseIGST" numeric(20,2),
    "TotalPurchaseInvoiceValue" numeric(20,2),
    "TotalPurchaseTaxableValue" numeric(20,2),
    "TotalPurchaseCGST" numeric(20,2),
    "TotalPurchaseSGST" numeric(20,2),
    "SellCGST" numeric(20,2),
    "SellSGST" numeric(20,2),
    "SellIGST" numeric(20,2),
    "SellInvoiceValue" numeric(20,2),
    "SellTaxableValue" numeric(20,2),
    "TotalSellCGST" numeric(20,2),
    "TotalSellSGST" numeric(20,2),
    "TotalSellIGST" numeric(20,2),
    "TotalSellInvoiceValue" numeric(20,2),
    "TotalSellTaxableValue" numeric(20,2),
    "PurchaseTaxableValue" numeric(20,2)
);
 +   DROP TABLE public."CustomerInvoiceMaster";
       public         heap    postgres    false                        1259    24581    DivisionMaster    TABLE     �   CREATE TABLE public."DivisionMaster" (
    "DivisionID" character varying(255) NOT NULL,
    "DivisionName" character varying(255) NOT NULL
);
 $   DROP TABLE public."DivisionMaster";
       public         heap    postgres    false                       1259    24810    CustomerInvoiceViews    VIEW     
  CREATE VIEW public."CustomerInvoiceViews" AS
 SELECT a."CustomerInvoiceNo",
    a."MRRNo",
    a."InvoiceNo",
    a."PONo",
    a."OrderReferenceNo",
    a."POType",
    a."FinYear",
    a."DistrictID",
    a."VendorID",
    a."InvoiceAmount",
    a."NoOfOrderDeliver",
    a."DeliveredQuantity",
    a."InsertedDate",
    a."InsertedBy",
    a."UpdatedDate",
    a."UpdatedBy",
    a."CustomerID",
    a."DivisionID",
    a."Implement",
    a."Make",
    a."Model",
    a."HSN",
    a."PackageSize",
    a."PackageUnitOfMeasurement",
    a."PackageQuantity",
    a."ItemQuantity",
    a."TaxRate",
    a."RatePerUnit",
    a."PurchaseInvoiceValue",
    a."PurchaseTaxableValue",
    a."PurchaseCGST",
    a."PurchaseSGST",
    a."PurchaseIGST",
    a."TotalPurchaseInvoiceValue",
    a."TotalPurchaseTaxableValue",
    a."TotalPurchaseCGST",
    a."TotalPurchaseSGST",
    a."SellCGST",
    a."SellSGST",
    a."SellIGST",
    a."SellInvoiceValue",
    a."SellTaxableValue",
    a."TotalSellCGST",
    a."TotalSellSGST",
    a."TotalSellIGST",
    a."TotalSellInvoiceValue",
    a."TotalSellTaxableValue",
    a."UnitOfMeasurement",
    d."DivisionName"
   FROM (public."CustomerInvoiceMaster" a
     JOIN public."DivisionMaster" d ON (((d."DivisionID")::text = (a."DivisionID")::text)));
 )   DROP VIEW public."CustomerInvoiceViews";
       public          postgres    false    256    256    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275                       1259    24698    customer_id_increment    SEQUENCE     ~   CREATE SEQUENCE public.customer_id_increment
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.customer_id_increment;
       public          postgres    false                       1259    24650    CustomerMaster    TABLE     /  CREATE TABLE public."CustomerMaster" (
    id integer NOT NULL,
    "CustomerID" character varying(255) DEFAULT ('CUS'::text || nextval('public.customer_id_increment'::regclass)),
    "LegalCustomerName" character varying(255),
    "TradeName" character varying(255),
    "PAN" character varying(255),
    "BussinessConstitution" character varying(255),
    "GSTN" character varying(255),
    "ContactNumber" character varying(255),
    "EmailID" character varying(255),
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255)
);
 $   DROP TABLE public."CustomerMaster";
       public         heap    postgres    false    269                       1259    24648    CustomerMaster_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerMaster_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."CustomerMaster_id_seq";
       public          postgres    false    262            �           0    0    CustomerMaster_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."CustomerMaster_id_seq" OWNED BY public."CustomerMaster".id;
          public          postgres    false    261            
           1259    24672    CustomerPrincipalPlace    TABLE     �  CREATE TABLE public."CustomerPrincipalPlace" (
    id integer NOT NULL,
    "CustomerID" character varying(255),
    "PrincipalPlaceID" integer,
    "Country" character varying(255),
    "StateCode" integer,
    "DistrictOrCity" character varying(255),
    "Pincode" integer,
    "Address" character varying(255),
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255)
);
 ,   DROP TABLE public."CustomerPrincipalPlace";
       public         heap    postgres    false            	           1259    24670    CustomerPrincipalPlace_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerPrincipalPlace_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public."CustomerPrincipalPlace_id_seq";
       public          postgres    false    266            �           0    0    CustomerPrincipalPlace_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public."CustomerPrincipalPlace_id_seq" OWNED BY public."CustomerPrincipalPlace".id;
          public          postgres    false    265            �            1259    16434    DMMaster    TABLE       CREATE TABLE public."DMMaster" (
    dist_id character varying(2),
    dist_name character varying(30),
    dm_id character varying(30) NOT NULL,
    dm_name character varying(225),
    dm_address character varying(1000),
    dm_mobile_no character varying(15),
    "UpdateOn" timestamp without time zone,
    "UpdateBy" character varying,
    "EmailID" character varying,
    "BankName" character varying,
    "BranchName" character varying,
    "AccountNumber" character varying,
    "IFSCCode" character varying
);
    DROP TABLE public."DMMaster";
       public         heap    postgres    false            �            1259    16419    DistrictMaster    TABLE     �   CREATE TABLE public."DistrictMaster" (
    dist_id character varying(2) NOT NULL,
    dist_name character varying(20),
    "DistCode" character varying
);
 $   DROP TABLE public."DistrictMaster";
       public         heap    postgres    false                       1259    24724    InvoiceMaster    TABLE     G  CREATE TABLE public."InvoiceMaster" (
    "InvoiceNo" character varying(255) NOT NULL,
    "PONo" character varying(255) NOT NULL,
    "OrderReferenceNo" character varying(255) NOT NULL,
    "InvoiceDate" timestamp with time zone NOT NULL,
    "WayBillNo" character varying(255),
    "WayBillDate" timestamp with time zone,
    "TruckNo" character varying(255),
    "FinYear" character varying(255),
    "DistrictID" character varying(255),
    "VendorID" character varying(255),
    "Status" character varying(255) DEFAULT 'notReceived'::character varying,
    "PaymentStatus" character varying(255) DEFAULT 'pending'::character varying,
    "InvoiceAmount" character varying(255),
    "InvoicePath" character varying(255),
    "POType" character varying(255) NOT NULL,
    "NoOfOrderInPO" character varying(255) NOT NULL,
    "NoOfOrderDeliver" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255),
    "IsReceived" boolean DEFAULT false,
    "ReceivedDate" timestamp with time zone,
    "EngineNumber" character varying(255),
    "ChassicNumber" character varying(255),
    "MRRNo" character varying,
    "TotalPurchaseTaxableValue" character varying,
    "TotalPurchaseInvoiceValue" character varying,
    "TotalPurchaseCGST" character varying,
    "TotalPurchaseSGST" character varying,
    "TotalPurchaseIGST" character varying,
    "SupplyQuantity" character varying,
    "SupplyPackageQuantity" character varying,
    "Discount" character varying
);
 #   DROP TABLE public."InvoiceMaster";
       public         heap    postgres    false            �            1259    16467 
   ItemMaster    TABLE     �  CREATE TABLE public."ItemMaster" (
    "Implement" character varying(100) NOT NULL,
    "Make" character varying(100) NOT NULL,
    "Model" character varying(300) NOT NULL,
    p_taxable_value numeric(10,2),
    p_cgst_6 numeric(10,2),
    p_sgst_6 numeric(10,2),
    p_cgst_1 numeric(10,2),
    p_sgst_1 numeric(10,2),
    p_invoice_value numeric(10,2),
    s_taxable_value numeric(10,2),
    s_cgst_6 numeric(10,2),
    s_sgst_6 numeric(10,2),
    s_invoice_value numeric(10,2),
    p_igst_12 numeric(10,2),
    s_igst_12 numeric(10,2),
    add_date timestamp with time zone,
    update_date timestamp without time zone,
    "Division" character varying,
    "HSN" character varying,
    "UnitOfMeasurement" character varying,
    "GSTApplicability" character varying,
    "Taxability" character varying,
    "TaxRate" integer,
    "PurchaseInvoiceValue" numeric(10,2),
    "PurchaseTaxableValue" numeric(10,2),
    "PurchaseCGST" numeric(10,2),
    "PurchaseSGST" numeric(10,2),
    "PurchaseIGST" numeric(10,2),
    "PurchaseSGSTOnePercent" numeric(10,2),
    "PurchaseCGSTOnePercent" numeric(10,2),
    "SellCGST" numeric(10,2),
    "SellSGST" numeric(10,2),
    "SellIGST" numeric(10,2),
    "SellInvoiceValue" numeric(10,2),
    "SellTaxableValue" numeric(10,2),
    "InsertedDate" timestamp without time zone,
    "InsertedBy" character varying,
    "UpdatedDate" timestamp without time zone,
    "UpdatedBy" character varying,
    "DivisionID" character varying
);
     DROP TABLE public."ItemMaster";
       public         heap    postgres    false                       1259    24737    ItemPackageMaster    TABLE     @  CREATE TABLE public."ItemPackageMaster" (
    "DivisionID" character varying(255) NOT NULL,
    "Implement" character varying(255) NOT NULL,
    "Make" character varying(255) NOT NULL,
    "Model" character varying(255) NOT NULL,
    "PackageSize" character varying(255) NOT NULL,
    "UnitOfMeasurement" character varying(255) NOT NULL,
    "PurchaseInvoiceValue" numeric(20,2),
    "PurchaseTaxableValue" numeric(20,2),
    "PurchaseCGST" numeric(20,2),
    "PurchaseSGST" numeric(20,2),
    "PurchaseIGST" numeric(20,2),
    "SellSGST" numeric(20,2),
    "SellIGST" numeric(20,2),
    "SellInvoiceValue" numeric(20,2),
    "SellTaxableValue" numeric(20,2),
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255)
);
 '   DROP TABLE public."ItemPackageMaster";
       public         heap    postgres    false                       1259    24750    ItemPackageSizeMaster    TABLE     s   CREATE TABLE public."ItemPackageSizeMaster" (
    id integer NOT NULL,
    "PackageSize" character varying(255)
);
 +   DROP TABLE public."ItemPackageSizeMaster";
       public         heap    postgres    false                       1259    24748    ItemPackageSizeMaster_id_seq    SEQUENCE     �   CREATE SEQUENCE public."ItemPackageSizeMaster_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."ItemPackageSizeMaster_id_seq";
       public          postgres    false    273            �           0    0    ItemPackageSizeMaster_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."ItemPackageSizeMaster_id_seq" OWNED BY public."ItemPackageSizeMaster".id;
          public          postgres    false    272                       1259    24628 	   MRRMaster    TABLE     K  CREATE TABLE public."MRRMaster" (
    "MRRNo" character varying(255) NOT NULL,
    "InvoiceNo" character varying(255) NOT NULL,
    "PONo" character varying(255) NOT NULL,
    "OrderReferenceNo" character varying(255) NOT NULL,
    "FinYear" character varying(255) NOT NULL,
    "ItemQuantity" integer,
    "MRRAmount" integer,
    "VendorID" character varying(255),
    "DistrictID" character varying(255),
    "DMID" character varying(255),
    "AccID" character varying(255),
    "PaymentStatus" character varying(255) DEFAULT 'Pending'::character varying,
    "POType" character varying(255),
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255),
    "NoOfItemReceived" character varying,
    "ReceivedQuantity" integer
);
    DROP TABLE public."MRRMaster";
       public         heap    postgres    false                       1259    24597    POMaster    TABLE     r  CREATE TABLE public."POMaster" (
    "FinYear" character varying(255),
    "PONo" character varying(255) NOT NULL,
    "OrderReferenceNo" character varying(255) NOT NULL,
    "CustomerID" character varying(255),
    "CustomerOrderRefence" character varying(255),
    "VendorID" character varying(255),
    "DistrictID" character varying(255),
    "DMID" character varying(255),
    "AccID" character varying(255),
    "DivisionID" character varying(255),
    "Implement" character varying(255),
    "Make" character varying(255),
    "Model" character varying(255),
    "UnitOfMeasurement" character varying(255),
    "HSN" character varying(255),
    "TaxRate" character varying(255),
    "PurchaseInvoiceValue" numeric(10,2),
    "PurchaseTaxableValue" numeric(10,2),
    "PurchaseCGST" numeric(10,2),
    "PurchaseSGST" numeric(10,2),
    "PurchaseIGST" numeric(10,2),
    "TotalPurchaseInvoiceValue" numeric(10,2),
    "TotalPurchaseTaxableValue" numeric(10,2),
    "TotalPurchaseCGST" numeric(10,2),
    "TotalPurchaseSGST" numeric(10,2),
    "SellCGST" numeric(10,2),
    "SellSGST" numeric(10,2),
    "SellIGST" numeric(10,2),
    "SellInvoiceValue" numeric(10,2),
    "SellTaxableValue" numeric(10,2),
    "TotalSellCGST" numeric(10,2),
    "TotalSellSGST" numeric(10,2),
    "TotalSellIGST" numeric(10,2),
    "TotalSellInvoiceValue" numeric(10,2),
    "TotalSellTaxableValue" numeric(10,2),
    "POAmount" character varying(255),
    "NoOfItemsInPO" character varying(255) DEFAULT 1,
    "ItemQuantity" character varying(255),
    "ItemQuantitySold" character varying(255),
    "EngineNumber" character varying(255),
    "ChassicNumber" character varying(255),
    "IsDelivered" boolean DEFAULT false,
    "IsReceived" boolean DEFAULT false,
    "IsDeliveredToCustomer" boolean DEFAULT false,
    "Status" character varying(255) DEFAULT 'indentInitiated'::character varying,
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255),
    "IsApproved" boolean DEFAULT false,
    "ApprovalStatus" character varying(255) DEFAULT 'Pending'::character varying,
    "ApprovedDate" timestamp with time zone,
    "ApprovedBy" character varying(255),
    "IsDeleted" boolean DEFAULT false,
    "DeletedDate" timestamp with time zone,
    "DeletedBy" character varying(255),
    "IsCancelled" boolean DEFAULT false,
    "CancellationStatus" character varying(255),
    "CancelledDate" timestamp with time zone,
    "CancelledBy" character varying(255),
    "POType" character varying(255),
    "VendorInvoiceNo" character varying(255),
    "MRRID" character varying(255),
    "RatePerUnit" numeric(20,2),
    "PackageQuantity" character varying,
    "PackageSize" character varying,
    "PackageUnitOfMeasurement" character varying,
    "DeliveredQuantity" character varying,
    "PendingQuantity" character varying
);
    DROP TABLE public."POMaster";
       public         heap    postgres    false                       1259    24794    MRRViews    VIEW     �  CREATE VIEW public."MRRViews" AS
 SELECT a."MRRNo",
    a."InvoiceNo",
    a."PONo",
    a."OrderReferenceNo",
    a."FinYear",
    a."ItemQuantity",
    a."VendorID",
    a."DistrictID",
    a."DMID",
    a."AccID",
    a."PaymentStatus",
    a."POType",
    a."InsertedDate",
    a."InsertedBy",
    a."UpdatedDate",
    a."UpdatedBy",
    a."MRRAmount",
    a."NoOfItemReceived",
    c."CustomerID",
    d."DivisionID",
    d."DivisionName",
    c."Implement",
    c."Make",
    c."Model",
    c."UnitOfMeasurement",
    c."HSN",
    c."TaxRate",
    c."PurchaseInvoiceValue",
    c."PurchaseTaxableValue",
    c."PurchaseCGST",
    c."PurchaseSGST",
    c."PurchaseIGST",
    c."TotalPurchaseInvoiceValue",
    c."TotalPurchaseTaxableValue",
    c."TotalPurchaseCGST",
    c."TotalPurchaseSGST",
    c."SellCGST",
    c."SellSGST",
    c."SellIGST",
    c."SellInvoiceValue",
    c."SellTaxableValue",
    c."TotalSellCGST",
    c."TotalSellSGST",
    c."TotalSellIGST",
    c."TotalSellInvoiceValue",
    c."TotalSellTaxableValue",
    c."POAmount",
    c."NoOfItemsInPO",
    c."EngineNumber",
    c."ChassicNumber",
    c."PackageSize",
    c."PackageUnitOfMeasurement",
    c."RatePerUnit",
    c."PackageQuantity",
    c."DeliveredQuantity",
    c."PendingQuantity"
   FROM (((public."MRRMaster" a
     JOIN public."InvoiceMaster" b ON (((b."InvoiceNo")::text = (a."InvoiceNo")::text)))
     JOIN public."POMaster" c ON ((((c."PONo")::text = (a."PONo")::text) AND ((c."OrderReferenceNo")::text = (a."OrderReferenceNo")::text))))
     JOIN public."DivisionMaster" d ON (((d."DivisionID")::text = (c."DivisionID")::text)))
  WHERE ((a."POType")::text = 'NonSubsidy'::text);
    DROP VIEW public."MRRViews";
       public          postgres    false    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    257    260    260    260    260    260    257    256    256    257    257    260    260    260    260    260    260    260    260    260    260    260    260    260    270                       1259    24616    NonSubsidyPODetails    TABLE       CREATE TABLE public."NonSubsidyPODetails" (
    id integer NOT NULL,
    "OrderReferenceNo" character varying(255),
    "PONo" character varying(255) NOT NULL,
    "CustomerID" character varying(255),
    "DivisionID" character varying(255),
    "Implement" character varying(255),
    "Make" character varying(255),
    "Model" character varying(255),
    "UnitOfMeasurement" character varying(255),
    "HSN" character varying(255),
    "TaxRate" character varying(255),
    "PurchaseInvoiceValue" numeric(10,2),
    "PurchaseTaxableValue" numeric(10,2),
    "PurchaseCGST" numeric(10,2),
    "PurchaseSGST" numeric(10,2),
    "PurchaseIGST" numeric(10,2),
    "SellCGST" numeric(10,2),
    "SellSGST" numeric(10,2),
    "SellIGST" numeric(10,2),
    "SellInvoiceValue" numeric(10,2),
    "SellTaxableValue" numeric(10,2),
    "ItemQuantity" character varying(255),
    "ItemQuantitySold" character varying(255),
    "EngineNumber" character varying(255),
    "ChassicNumber" character varying(255),
    "IsDelivered" boolean DEFAULT false,
    "IsReceived" boolean DEFAULT false,
    "IsDeliveredToCustomer" boolean DEFAULT false,
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255)
);
 )   DROP TABLE public."NonSubsidyPODetails";
       public         heap    postgres    false                       1259    24614    NonSubsidyPODetails_id_seq    SEQUENCE     �   CREATE SEQUENCE public."NonSubsidyPODetails_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."NonSubsidyPODetails_id_seq";
       public          postgres    false    259            �           0    0    NonSubsidyPODetails_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."NonSubsidyPODetails_id_seq" OWNED BY public."NonSubsidyPODetails".id;
          public          postgres    false    258            �            1259    16793    StateMaster    TABLE     y   CREATE TABLE public."StateMaster" (
    "StateCode" integer NOT NULL,
    "StateName" character varying(255) NOT NULL
);
 !   DROP TABLE public."StateMaster";
       public         heap    postgres    false                       1259    24815    StockMaster    VIEW     Q  CREATE VIEW public."StockMaster" AS
 SELECT a."DistrictID",
    a."DivisionID",
    a."DivisionName",
    a."Implement",
    a."Make",
    a."Model",
    a."UnitOfMeasurement",
    a."PackageSize",
    a."PackageUnitOfMeasurement",
    COALESCE(sum(a."ItemQuantity"), (0)::bigint) AS "ReceivedQuantity",
    COALESCE(sum(b."ItemQuantity"), (0)::bigint) AS "DeliveredQuantity",
    (COALESCE(sum(a."ItemQuantity"), (0)::bigint) - COALESCE(sum(b."ItemQuantity"), (0)::bigint)) AS "AvailableQuantity"
   FROM (public."MRRViews" a
     LEFT JOIN public."CustomerInvoiceViews" b ON ((((a."DistrictID")::text = (b."DistrictID")::text) AND ((a."DivisionID")::text = (b."DivisionID")::text) AND ((a."DivisionName")::text = (b."DivisionName")::text) AND ((a."Implement")::text = (b."Implement")::text) AND ((a."Make")::text = (b."Make")::text) AND ((a."Model")::text = (b."Model")::text) AND ((a."PackageSize")::text = (b."PackageSize")::text))))
  GROUP BY a."DistrictID", a."DivisionID", a."DivisionName", a."Implement", a."Make", a."Model", a."UnitOfMeasurement", a."PackageUnitOfMeasurement", a."PackageSize";
     DROP VIEW public."StockMaster";
       public          postgres    false    277    277    277    277    277    277    277    277    276    276    276    276    276    276    276    276    276    276            �            1259    16953    VendorBankAccount    TABLE     j  CREATE TABLE public."VendorBankAccount" (
    "VendorID" character varying(255) NOT NULL,
    "BankAccountID" integer NOT NULL,
    "AccountNumber" character varying(255) NOT NULL,
    "AccountType" character varying(255) NOT NULL,
    "BankName" character varying(255) NOT NULL,
    "BranchName" character varying(255) NOT NULL,
    "IFSCCode" character varying(255) NOT NULL,
    "BankDocument" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255) NOT NULL,
    "UpdatedDate" timestamp without time zone,
    "UpdatedBy" character varying
);
 '   DROP TABLE public."VendorBankAccount";
       public         heap    postgres    false            �            1259    16951 #   VendorBankAccount_BankAccountID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorBankAccount_BankAccountID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public."VendorBankAccount_BankAccountID_seq";
       public          postgres    false    253            �           0    0 #   VendorBankAccount_BankAccountID_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public."VendorBankAccount_BankAccountID_seq" OWNED BY public."VendorBankAccount"."BankAccountID";
          public          postgres    false    252            �            1259    16916    VendorContactPerson    TABLE     �  CREATE TABLE public."VendorContactPerson" (
    "VendorID" character varying(255) NOT NULL,
    "ContactPersonID" integer NOT NULL,
    "Name" character varying(255) NOT NULL,
    "FathersName" character varying(255) NOT NULL,
    "MobileNumber" bigint NOT NULL,
    "EmailID" character varying(255) NOT NULL,
    "Designation" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255) NOT NULL
);
 )   DROP TABLE public."VendorContactPerson";
       public         heap    postgres    false            �            1259    16914 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorContactPerson_ContactPersonID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 @   DROP SEQUENCE public."VendorContactPerson_ContactPersonID_seq";
       public          postgres    false    249            �           0    0 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE public."VendorContactPerson_ContactPersonID_seq" OWNED BY public."VendorContactPerson"."ContactPersonID";
          public          postgres    false    248            �            1259    16980    VendorDistrictMapping    TABLE     �   CREATE TABLE public."VendorDistrictMapping" (
    "VendorID" character varying(255) NOT NULL,
    "DistrictID" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL
);
 +   DROP TABLE public."VendorDistrictMapping";
       public         heap    postgres    false            �            1259    16903    VendorMaster    TABLE       CREATE TABLE public."VendorMaster" (
    "VendorID" character varying(255) NOT NULL,
    "LegalBussinessName" character varying(255),
    "TradeName" character varying(255),
    "PAN" character varying(255),
    "PANDocument" character varying(255),
    "BussinessConstitution" character varying(255),
    "GSTN" character varying(255),
    "GSTNDocument" character varying(255),
    "IncorporationDate" timestamp with time zone,
    "ContactNumber" character varying(255),
    "EmailID" character varying(255),
    "ApprovalStatus" character varying(255) DEFAULT 'Pending'::character varying,
    "ApplyStatus" character varying(255) DEFAULT 'Pending'::character varying NOT NULL,
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255),
    "IsDeleted" boolean DEFAULT false,
    "ApproveOrRejectDate" timestamp with time zone,
    "ApproveOrRejectBy" character varying(255),
    "WhetherSSIUnit" character varying(255),
    "WhetherMSME" character varying(255),
    "SSIUnitRegistrationCertificate" character varying(255),
    "MSMECertificate" character varying(255),
    "CoreBussinessActivity" character varying(255),
    "Turnover1" character varying(255),
    "Turnover2" character varying(255),
    "Turnover3" character varying(255),
    "Password" character varying
);
 "   DROP TABLE public."VendorMaster";
       public         heap    postgres    false            �            1259    16932    VendorPrincipalPlace    TABLE     �  CREATE TABLE public."VendorPrincipalPlace" (
    "VendorID" character varying(255) NOT NULL,
    "PrincipalPlaceID" integer NOT NULL,
    "Country" character varying(255) NOT NULL,
    "StateCode" integer NOT NULL,
    "DistrictOrCity" character varying(255) NOT NULL,
    "Pincode" integer NOT NULL,
    "Address" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255) NOT NULL
);
 *   DROP TABLE public."VendorPrincipalPlace";
       public         heap    postgres    false            �            1259    16930 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 B   DROP SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq";
       public          postgres    false    251            �           0    0 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq" OWNED BY public."VendorPrincipalPlace"."PrincipalPlaceID";
          public          postgres    false    250            �            1259    16967    VendorServices    TABLE     �   CREATE TABLE public."VendorServices" (
    "VendorID" character varying(255) NOT NULL,
    "Service" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255) NOT NULL
);
 $   DROP TABLE public."VendorServices";
       public         heap    postgres    false            �            1259    16388    approval    TABLE     H  CREATE TABLE public.approval (
    sl_no integer NOT NULL,
    invoice_no character varying(30) NOT NULL,
    fin_year character varying(10),
    dist_id character varying(2),
    dl_id character varying(50),
    status character varying(50),
    approval_id character varying(30),
    indent_no character varying(30),
    approval_date timestamp without time zone,
    ammount integer,
    transaction_id character varying(30),
    deduction_amount numeric(100,20),
    pay_now_amount numeric(100,20),
    payment_status character varying(30),
    remark character varying(500),
    dl_remark character varying(500),
    paid_amount numeric(100,20),
    pp_id character varying(50),
    pp_status character varying(50),
    dm_approved_on timestamp without time zone,
    bank_approved_on timestamp without time zone,
    items integer
);
    DROP TABLE public.approval;
       public         heap    postgres    false            �            1259    16394    approval_desc    TABLE     �   CREATE TABLE public.approval_desc (
    approval_id character varying(30) NOT NULL,
    permit_no character varying(50) NOT NULL,
    serial integer NOT NULL,
    mrr_id character varying
);
 !   DROP TABLE public.approval_desc;
       public         heap    postgres    false            �            1259    16400    approval_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.approval_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.approval_desc_serial_seq;
       public          postgres    false    202            �           0    0    approval_desc_serial_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.approval_desc_serial_seq OWNED BY public.approval_desc.serial;
          public          postgres    false    203            �            1259    16402    approval_status_desc    TABLE     ~   CREATE TABLE public.approval_status_desc (
    status_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
 (   DROP TABLE public.approval_status_desc;
       public         heap    postgres    false            �            1259    16405 
   components    TABLE     �   CREATE TABLE public.components (
    comp_id character varying(10) NOT NULL,
    schema_id character varying(10),
    comp_name character varying(30)
);
    DROP TABLE public.components;
       public         heap    postgres    false            �            1259    16408    dept_expenditure_payment_desc    TABLE     �  CREATE TABLE public.dept_expenditure_payment_desc (
    sl_no integer NOT NULL,
    reference_no character varying(30),
    transaction_id character varying(30),
    source_id character varying(10),
    schem_id character varying(10),
    comp_id character varying(10),
    head_id character varying(10),
    subhead_id character varying(10),
    head_name character varying(70),
    subhead_name character varying(70),
    sd_path character varying(100)
);
 1   DROP TABLE public.dept_expenditure_payment_desc;
       public         heap    postgres    false            �            1259    16411    govt_share_config    TABLE     �   CREATE TABLE public.govt_share_config (
    sl integer NOT NULL,
    fin_year character varying(10),
    head character varying(30),
    govt_share_ammount integer
);
 %   DROP TABLE public.govt_share_config;
       public         heap    postgres    false            �            1259    16414    dept_money_config_sl_seq    SEQUENCE     �   CREATE SEQUENCE public.dept_money_config_sl_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.dept_money_config_sl_seq;
       public          postgres    false    207            �           0    0    dept_money_config_sl_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.dept_money_config_sl_seq OWNED BY public.govt_share_config.sl;
          public          postgres    false    208            �            1259    16437    farmer_receipt    TABLE     S  CREATE TABLE public.farmer_receipt (
    sl_no integer NOT NULL,
    receipt_no character varying(225) NOT NULL,
    fin_year character varying(10),
    farmer_name character varying(225),
    farmer_id character varying(225),
    full_ammount character varying(30),
    permit_no character varying(225),
    implement character varying(225),
    payment_mode character varying(225),
    payment_no character varying(255),
    source_bank character varying(225),
    date timestamp without time zone,
    dist_id character varying(5),
    office character varying(225),
    payment_date date
);
 "   DROP TABLE public.farmer_receipt;
       public         heap    postgres    false            �            1259    16440    farmer_receipts_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.farmer_receipts_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.farmer_receipts_sl_no_seq;
       public          postgres    false    211            �           0    0    farmer_receipts_sl_no_seq    SEQUENCE OWNED BY     V   ALTER SEQUENCE public.farmer_receipts_sl_no_seq OWNED BY public.farmer_receipt.sl_no;
          public          postgres    false    212            �            1259    16442    head_master    TABLE     u   CREATE TABLE public.head_master (
    head_id character varying(10) NOT NULL,
    head_name character varying(30)
);
    DROP TABLE public.head_master;
       public         heap    postgres    false            �            1259    16473 !   jalanidhi_dept_expnd_payment_desc    TABLE     �   CREATE TABLE public.jalanidhi_dept_expnd_payment_desc (
    serial integer NOT NULL,
    transaction_id character varying(50),
    scheme_id character varying(10),
    scheme_name character varying(50),
    comp_id character varying(10)
);
 5   DROP TABLE public.jalanidhi_dept_expnd_payment_desc;
       public         heap    postgres    false            �            1259    16476 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 C   DROP SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq;
       public          postgres    false    215            �           0    0 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq OWNED BY public.jalanidhi_dept_expnd_payment_desc.serial;
          public          postgres    false    216            �            1259    16478    jalanidhi_payment_desc    TABLE     N  CREATE TABLE public.jalanidhi_payment_desc (
    transaction_id character varying(50),
    farmer_id character varying(70),
    farmer_name character varying(50),
    implement character varying(50),
    make character varying(50),
    model character varying(50),
    serial integer NOT NULL,
    project_id character varying(60)
);
 *   DROP TABLE public.jalanidhi_payment_desc;
       public         heap    postgres    false            �            1259    16481 !   jalanidhi_payment_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jalanidhi_payment_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.jalanidhi_payment_desc_serial_seq;
       public          postgres    false    217            �           0    0 !   jalanidhi_payment_desc_serial_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.jalanidhi_payment_desc_serial_seq OWNED BY public.jalanidhi_payment_desc.serial;
          public          postgres    false    218            �            1259    16483    jn_expenditure_desc    TABLE     �   CREATE TABLE public.jn_expenditure_desc (
    transaction_id character varying(70) NOT NULL,
    item_name character varying(50) NOT NULL,
    item_price numeric(10,5) NOT NULL,
    quantity integer NOT NULL,
    serial integer NOT NULL
);
 '   DROP TABLE public.jn_expenditure_desc;
       public         heap    postgres    false            �            1259    16486    jn_expenditure_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jn_expenditure_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.jn_expenditure_desc_serial_seq;
       public          postgres    false    219            �           0    0    jn_expenditure_desc_serial_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.jn_expenditure_desc_serial_seq OWNED BY public.jn_expenditure_desc.serial;
          public          postgres    false    220            �            1259    16488 	   jn_orders    TABLE     ~  CREATE TABLE public.jn_orders (
    fin_year character varying(10),
    dist_id character varying(2),
    cluster_id character varying(70) NOT NULL,
    farmer_id character varying(70) NOT NULL,
    dist_name character varying(50),
    farmer_name character varying(70),
    status character varying(30),
    date timestamp(6) without time zone,
    system character varying(30)
);
    DROP TABLE public.jn_orders;
       public         heap    postgres    false            �            1259    16491    jn_stock    TABLE     �  CREATE TABLE public.jn_stock (
    fin_year character varying(10) NOT NULL,
    dist_id character varying(2) NOT NULL,
    dl_id character varying(4) NOT NULL,
    system character varying(30) NOT NULL,
    po_no character varying(50) NOT NULL,
    cluster_id character varying(70) NOT NULL,
    farmer_id character varying(70) NOT NULL,
    farmer_name character varying(50),
    implement character varying(50) NOT NULL,
    make character varying(50) NOT NULL,
    model character varying(50) NOT NULL,
    engine_no character varying(50),
    chassic_no character varying(50),
    status character varying(50) NOT NULL,
    receive_date timestamp without time zone,
    deliver_date timestamp without time zone,
    dl_name character varying(50)
);
    DROP TABLE public.jn_stock;
       public         heap    postgres    false            �            1259    16497    lgd_block_master    TABLE     �   CREATE TABLE public.lgd_block_master (
    dist_code character varying(500),
    block_code character varying(20) NOT NULL,
    block_name character varying(200)
);
 $   DROP TABLE public.lgd_block_master;
       public         heap    postgres    false            �            1259    16503    lgd_dist_master    TABLE     |   CREATE TABLE public.lgd_dist_master (
    dist_code character varying(20) NOT NULL,
    dist_name character varying(200)
);
 #   DROP TABLE public.lgd_dist_master;
       public         heap    postgres    false            �            1259    16506    lgd_gp_master    TABLE     �   CREATE TABLE public.lgd_gp_master (
    dist_code character varying(20),
    block_code character varying(20),
    gp_code character varying(20) NOT NULL,
    gp_name character varying(100)
);
 !   DROP TABLE public.lgd_gp_master;
       public         heap    postgres    false            �            1259    16509    log    TABLE     �  CREATE TABLE public.log (
    sl_no integer NOT NULL,
    date_time timestamp without time zone,
    user_id character varying,
    action character varying,
    status character varying,
    ref_url character varying,
    route character varying,
    ip character varying,
    browser_name character varying,
    browser_version character varying,
    fin_year character varying,
    remark character varying
);
    DROP TABLE public.log;
       public         heap    postgres    false            �            1259    16515    log_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.log_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.log_sl_no_seq;
       public          postgres    false    226            �           0    0    log_sl_no_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.log_sl_no_seq OWNED BY public.log.sl_no;
          public          postgres    false    227            �            1259    16517    mrr    TABLE     g  CREATE TABLE public.mrr (
    sl_no integer NOT NULL,
    mrr_id character varying(30) NOT NULL,
    dist_id character varying(2),
    invoice_no character varying(20),
    fin_year character varying(10),
    dl_id character varying(50),
    date timestamp without time zone,
    items integer,
    indent_no character varying(100),
    mrr_amount integer
);
    DROP TABLE public.mrr;
       public         heap    postgres    false            �            1259    16520    mrr_desc    TABLE     z   CREATE TABLE public.mrr_desc (
    mrr_id character varying(30) NOT NULL,
    permit_no character varying(40) NOT NULL
);
    DROP TABLE public.mrr_desc;
       public         heap    postgres    false            �            1259    16523    mrr_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.mrr_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.mrr_sl_no_seq;
       public          postgres    false    228            �           0    0    mrr_sl_no_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.mrr_sl_no_seq OWNED BY public.mrr.sl_no;
          public          postgres    false    230            �            1259    16525    new_item_price    TABLE     ?  CREATE TABLE public.new_item_price (
    implement character varying(100) NOT NULL,
    make character varying(100) NOT NULL,
    model character varying(500) NOT NULL,
    purchase_price character varying(100),
    taxable_value character varying(100),
    cgst_6 character varying(100),
    sags_6 character varying(100),
    invoice_alue character varying(100),
    selling_price character varying(100),
    sl_taxable_value character varying(100),
    sl_cgst_6 character varying(100),
    sl_sgst_6 character varying(100),
    sl_invoice_value character varying(100)
);
 "   DROP TABLE public.new_item_price;
       public         heap    postgres    false            �            1259    16531    opening_balance    TABLE     e  CREATE TABLE public.opening_balance (
    fin_year character varying(10),
    date date,
    system character varying(50),
    dist_id character varying(2),
    transaction_id character varying(100) NOT NULL,
    ammount numeric(100,2),
    remark character varying(500),
    purpose character varying(50),
    reference_no character varying(100),
    "from" character varying(50),
    "to" character varying(50),
    head character varying(100),
    subhead character varying(100),
    payment_type character varying(30),
    payment_date date,
    payment_no character varying(50),
    test double precision
);
 #   DROP TABLE public.opening_balance;
       public         heap    postgres    false            �            1259    16537    orders    TABLE     E  CREATE TABLE public.orders (
    permit_no character varying(50) NOT NULL,
    farmer_id character varying(30),
    farmer_name character varying(30),
    farmer_father_name character varying(30),
    dist_name character varying(30),
    block_name character varying(30),
    gp_name character varying(30),
    village_name character varying(30),
    implement character varying(30),
    make character varying(30),
    model character varying(50),
    status character varying(30),
    permit_validity character varying(30),
    permit_issue_date character varying(30),
    fin_year character varying(30),
    dist_id character varying(2),
    engine_no character varying(30),
    chassic_no character varying(30),
    ammount integer,
    remark character varying(100),
    expected_delivery_date date,
    delivery_date timestamp(4) without time zone,
    c_fin_year character varying(10),
    date timestamp without time zone,
    system character varying(20),
    paid_amount integer,
    order_type character varying(30),
    "FullCost" numeric(20,2),
    "PendingCost" numeric(20,2)
);
    DROP TABLE public.orders;
       public         heap    postgres    false            �            1259    16543    payment    TABLE     D  CREATE TABLE public.payment (
    sl_no integer NOT NULL,
    date timestamp without time zone,
    reference_no character varying(50),
    transaction_id character varying(30) NOT NULL,
    "from" character varying(30),
    "to" character varying(30),
    remark character varying(30),
    payment_type character varying(30),
    payment_no character varying(40),
    fin_year character varying(10),
    purpose character varying(30),
    payment_date date,
    ammount numeric(100,10),
    status character varying(30),
    system character varying(50),
    source_bank character varying,
    "DivisionID" character varying,
    "Implement" character varying,
    "MoneyReceiptNo" character varying,
    "PayFrom" character varying,
    "PayTo" character varying,
    "PayFromID" character varying,
    "PayToID" character varying
);
    DROP TABLE public.payment;
       public         heap    postgres    false            �            1259    16546    payment1_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment1_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.payment1_sl_no_seq;
       public          postgres    false    234            �           0    0    payment1_sl_no_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.payment1_sl_no_seq OWNED BY public.payment.sl_no;
          public          postgres    false    235            �            1259    16548    payment_desc    TABLE     �   CREATE TABLE public.payment_desc (
    transaction_id character varying(70) NOT NULL,
    reference_no character varying(70) NOT NULL
);
     DROP TABLE public.payment_desc;
       public         heap    postgres    false            �            1259    16551    payment_desc_2_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_desc_2_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.payment_desc_2_sl_no_seq;
       public          postgres    false    206            �           0    0    payment_desc_2_sl_no_seq    SEQUENCE OWNED BY     d   ALTER SEQUENCE public.payment_desc_2_sl_no_seq OWNED BY public.dept_expenditure_payment_desc.sl_no;
          public          postgres    false    237            �            1259    16553    payment_invoice_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_invoice_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.payment_invoice_sl_no_seq;
       public          postgres    false    201            �           0    0    payment_invoice_sl_no_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.payment_invoice_sl_no_seq OWNED BY public.approval.sl_no;
          public          postgres    false    238            �            1259    16555    payment_purpose_desc    TABLE        CREATE TABLE public.payment_purpose_desc (
    purpose_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
 (   DROP TABLE public.payment_purpose_desc;
       public         heap    postgres    false            �            1259    16558    schem_master    TABLE     x   CREATE TABLE public.schem_master (
    schem_id character varying(10) NOT NULL,
    schem_name character varying(30)
);
     DROP TABLE public.schem_master;
       public         heap    postgres    false            �            1259    16561    source_master    TABLE     {   CREATE TABLE public.source_master (
    source_id character varying(10) NOT NULL,
    source_name character varying(30)
);
 !   DROP TABLE public.source_master;
       public         heap    postgres    false            �            1259    16564    subheads    TABLE     �   CREATE TABLE public.subheads (
    subhead_id character varying(10) NOT NULL,
    head_id character varying(10),
    subhead_name character varying(30)
);
    DROP TABLE public.subheads;
       public         heap    postgres    false            �            1259    16567    system_desc    TABLE     u   CREATE TABLE public.system_desc (
    system_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
    DROP TABLE public.system_desc;
       public         heap    postgres    false            �            1259    16570 
   tax_config    TABLE     r   CREATE TABLE public.tax_config (
    tax_mode character varying(2) NOT NULL,
    "desc" character varying(100)
);
    DROP TABLE public.tax_config;
       public         heap    postgres    false            �            1259    16573    users    TABLE     �   CREATE TABLE public.users (
    user_id character varying(225) NOT NULL,
    password character varying(300),
    role character varying(20)
);
    DROP TABLE public.users;
       public         heap    postgres    false            _           2604    24844    BankMaster BankID    DEFAULT     |   ALTER TABLE ONLY public."BankMaster" ALTER COLUMN "BankID" SET DEFAULT nextval('public."BankMaster_BankID_seq"'::regclass);
 D   ALTER TABLE public."BankMaster" ALTER COLUMN "BankID" DROP DEFAULT;
       public          postgres    false    280    279    280            Z           2604    24691    CustomerBankAccount id    DEFAULT     �   ALTER TABLE ONLY public."CustomerBankAccount" ALTER COLUMN id SET DEFAULT nextval('public."CustomerBankAccount_id_seq"'::regclass);
 G   ALTER TABLE public."CustomerBankAccount" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    268    267    268            X           2604    24664    CustomerContactPerson id    DEFAULT     �   ALTER TABLE ONLY public."CustomerContactPerson" ALTER COLUMN id SET DEFAULT nextval('public."CustomerContactPerson_id_seq"'::regclass);
 I   ALTER TABLE public."CustomerContactPerson" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    264    263    264            V           2604    24653    CustomerMaster id    DEFAULT     z   ALTER TABLE ONLY public."CustomerMaster" ALTER COLUMN id SET DEFAULT nextval('public."CustomerMaster_id_seq"'::regclass);
 B   ALTER TABLE public."CustomerMaster" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    262    261    262            Y           2604    24675    CustomerPrincipalPlace id    DEFAULT     �   ALTER TABLE ONLY public."CustomerPrincipalPlace" ALTER COLUMN id SET DEFAULT nextval('public."CustomerPrincipalPlace_id_seq"'::regclass);
 J   ALTER TABLE public."CustomerPrincipalPlace" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    266    265    266            ^           2604    24753    ItemPackageSizeMaster id    DEFAULT     �   ALTER TABLE ONLY public."ItemPackageSizeMaster" ALTER COLUMN id SET DEFAULT nextval('public."ItemPackageSizeMaster_id_seq"'::regclass);
 I   ALTER TABLE public."ItemPackageSizeMaster" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    273    272    273            Q           2604    24619    NonSubsidyPODetails id    DEFAULT     �   ALTER TABLE ONLY public."NonSubsidyPODetails" ALTER COLUMN id SET DEFAULT nextval('public."NonSubsidyPODetails_id_seq"'::regclass);
 G   ALTER TABLE public."NonSubsidyPODetails" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    259    258    259            G           2604    16956    VendorBankAccount BankAccountID    DEFAULT     �   ALTER TABLE ONLY public."VendorBankAccount" ALTER COLUMN "BankAccountID" SET DEFAULT nextval('public."VendorBankAccount_BankAccountID_seq"'::regclass);
 R   ALTER TABLE public."VendorBankAccount" ALTER COLUMN "BankAccountID" DROP DEFAULT;
       public          postgres    false    252    253    253            E           2604    16919 #   VendorContactPerson ContactPersonID    DEFAULT     �   ALTER TABLE ONLY public."VendorContactPerson" ALTER COLUMN "ContactPersonID" SET DEFAULT nextval('public."VendorContactPerson_ContactPersonID_seq"'::regclass);
 V   ALTER TABLE public."VendorContactPerson" ALTER COLUMN "ContactPersonID" DROP DEFAULT;
       public          postgres    false    249    248    249            F           2604    16935 %   VendorPrincipalPlace PrincipalPlaceID    DEFAULT     �   ALTER TABLE ONLY public."VendorPrincipalPlace" ALTER COLUMN "PrincipalPlaceID" SET DEFAULT nextval('public."VendorPrincipalPlace_PrincipalPlaceID_seq"'::regclass);
 X   ALTER TABLE public."VendorPrincipalPlace" ALTER COLUMN "PrincipalPlaceID" DROP DEFAULT;
       public          postgres    false    251    250    251            7           2604    16582    approval sl_no    DEFAULT     w   ALTER TABLE ONLY public.approval ALTER COLUMN sl_no SET DEFAULT nextval('public.payment_invoice_sl_no_seq'::regclass);
 =   ALTER TABLE public.approval ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    238    201            8           2604    16583    approval_desc serial    DEFAULT     |   ALTER TABLE ONLY public.approval_desc ALTER COLUMN serial SET DEFAULT nextval('public.approval_desc_serial_seq'::regclass);
 C   ALTER TABLE public.approval_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    203    202            9           2604    16584 #   dept_expenditure_payment_desc sl_no    DEFAULT     �   ALTER TABLE ONLY public.dept_expenditure_payment_desc ALTER COLUMN sl_no SET DEFAULT nextval('public.payment_desc_2_sl_no_seq'::regclass);
 R   ALTER TABLE public.dept_expenditure_payment_desc ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    237    206            ;           2604    16585    farmer_receipt sl_no    DEFAULT     }   ALTER TABLE ONLY public.farmer_receipt ALTER COLUMN sl_no SET DEFAULT nextval('public.farmer_receipts_sl_no_seq'::regclass);
 C   ALTER TABLE public.farmer_receipt ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    212    211            :           2604    16586    govt_share_config sl    DEFAULT     |   ALTER TABLE ONLY public.govt_share_config ALTER COLUMN sl SET DEFAULT nextval('public.dept_money_config_sl_seq'::regclass);
 C   ALTER TABLE public.govt_share_config ALTER COLUMN sl DROP DEFAULT;
       public          postgres    false    208    207            <           2604    16589 (   jalanidhi_dept_expnd_payment_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc ALTER COLUMN serial SET DEFAULT nextval('public.jalanidhi_dept_expnd_payment_desc_serial_seq'::regclass);
 W   ALTER TABLE public.jalanidhi_dept_expnd_payment_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    216    215            =           2604    16590    jalanidhi_payment_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jalanidhi_payment_desc ALTER COLUMN serial SET DEFAULT nextval('public.jalanidhi_payment_desc_serial_seq'::regclass);
 L   ALTER TABLE public.jalanidhi_payment_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    218    217            >           2604    16591    jn_expenditure_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jn_expenditure_desc ALTER COLUMN serial SET DEFAULT nextval('public.jn_expenditure_desc_serial_seq'::regclass);
 I   ALTER TABLE public.jn_expenditure_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    220    219            ?           2604    16592 	   log sl_no    DEFAULT     f   ALTER TABLE ONLY public.log ALTER COLUMN sl_no SET DEFAULT nextval('public.log_sl_no_seq'::regclass);
 8   ALTER TABLE public.log ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    227    226            @           2604    16593 	   mrr sl_no    DEFAULT     f   ALTER TABLE ONLY public.mrr ALTER COLUMN sl_no SET DEFAULT nextval('public.mrr_sl_no_seq'::regclass);
 8   ALTER TABLE public.mrr ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    230    228            A           2604    16594    payment sl_no    DEFAULT     o   ALTER TABLE ONLY public.payment ALTER COLUMN sl_no SET DEFAULT nextval('public.payment1_sl_no_seq'::regclass);
 <   ALTER TABLE public.payment ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    235    234            o          0    16385    AccountantMaster 
   TABLE DATA           �   COPY public."AccountantMaster" (acc_name, acc_id, dist_id, dist_name, acc_address, acc_mobile_no, "UpdateOn", "UpdateBy") FROM stdin;
    public          postgres    false    200   ��      �          0    24841 
   BankMaster 
   TABLE DATA           <   COPY public."BankMaster" ("BankID", "BankName") FROM stdin;
    public          postgres    false    280   ��      �          0    24688    CustomerBankAccount 
   TABLE DATA           �   COPY public."CustomerBankAccount" (id, "CustomerID", "BankAccountID", "bankAccountNo", "accountType", "bankName", "branchName", "ifscCode", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    268   j�      �          0    24661    CustomerContactPerson 
   TABLE DATA           �   COPY public."CustomerContactPerson" (id, "CustomerID", "ContactPersonID", "AuthorisedName", "AuthorisedMobileNo", "AuthorisedEmailID", "Designation", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    264   �      �          0    24757    CustomerDistrictMapping 
   TABLE DATA           _   COPY public."CustomerDistrictMapping" ("CustomerID", "DistrictID", "InsertedDate") FROM stdin;
    public          postgres    false    274   K      �          0    24781    CustomerInvoiceMaster 
   TABLE DATA           N  COPY public."CustomerInvoiceMaster" ("CustomerInvoiceNo", "MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo", "POType", "FinYear", "DistrictID", "VendorID", "InvoiceAmount", "NoOfOrderDeliver", "DeliveredQuantity", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "CustomerID", "DivisionID", "Implement", "Make", "Model", "HSN", "UnitOfMeasurement", "PackageSize", "PackageUnitOfMeasurement", "PackageQuantity", "ItemQuantity", "TaxRate", "RatePerUnit", "PurchaseInvoiceValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "TotalPurchaseInvoiceValue", "TotalPurchaseTaxableValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "TotalSellCGST", "TotalSellSGST", "TotalSellIGST", "TotalSellInvoiceValue", "TotalSellTaxableValue", "PurchaseTaxableValue") FROM stdin;
    public          postgres    false    275   �      �          0    24650    CustomerMaster 
   TABLE DATA           �   COPY public."CustomerMaster" (id, "CustomerID", "LegalCustomerName", "TradeName", "PAN", "BussinessConstitution", "GSTN", "ContactNumber", "EmailID", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    262   �      �          0    24672    CustomerPrincipalPlace 
   TABLE DATA           �   COPY public."CustomerPrincipalPlace" (id, "CustomerID", "PrincipalPlaceID", "Country", "StateCode", "DistrictOrCity", "Pincode", "Address", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    266   vG      y          0    16434    DMMaster 
   TABLE DATA           �   COPY public."DMMaster" (dist_id, dist_name, dm_id, dm_name, dm_address, dm_mobile_no, "UpdateOn", "UpdateBy", "EmailID", "BankName", "BranchName", "AccountNumber", "IFSCCode") FROM stdin;
    public          postgres    false    210   q_      x          0    16419    DistrictMaster 
   TABLE DATA           J   COPY public."DistrictMaster" (dist_id, dist_name, "DistCode") FROM stdin;
    public          postgres    false    209   �h      �          0    24581    DivisionMaster 
   TABLE DATA           H   COPY public."DivisionMaster" ("DivisionID", "DivisionName") FROM stdin;
    public          postgres    false    256   j      �          0    24724    InvoiceMaster 
   TABLE DATA           I  COPY public."InvoiceMaster" ("InvoiceNo", "PONo", "OrderReferenceNo", "InvoiceDate", "WayBillNo", "WayBillDate", "TruckNo", "FinYear", "DistrictID", "VendorID", "Status", "PaymentStatus", "InvoiceAmount", "InvoicePath", "POType", "NoOfOrderInPO", "NoOfOrderDeliver", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsReceived", "ReceivedDate", "EngineNumber", "ChassicNumber", "MRRNo", "TotalPurchaseTaxableValue", "TotalPurchaseInvoiceValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "TotalPurchaseIGST", "SupplyQuantity", "SupplyPackageQuantity", "Discount") FROM stdin;
    public          postgres    false    270   Rj      }          0    16467 
   ItemMaster 
   TABLE DATA           n  COPY public."ItemMaster" ("Implement", "Make", "Model", p_taxable_value, p_cgst_6, p_sgst_6, p_cgst_1, p_sgst_1, p_invoice_value, s_taxable_value, s_cgst_6, s_sgst_6, s_invoice_value, p_igst_12, s_igst_12, add_date, update_date, "Division", "HSN", "UnitOfMeasurement", "GSTApplicability", "Taxability", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "PurchaseSGSTOnePercent", "PurchaseCGSTOnePercent", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "DivisionID") FROM stdin;
    public          postgres    false    214   ��      �          0    24737    ItemPackageMaster 
   TABLE DATA           W  COPY public."ItemPackageMaster" ("DivisionID", "Implement", "Make", "Model", "PackageSize", "UnitOfMeasurement", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    271    �      �          0    24750    ItemPackageSizeMaster 
   TABLE DATA           D   COPY public."ItemPackageSizeMaster" (id, "PackageSize") FROM stdin;
    public          postgres    false    273   ��      �          0    24628 	   MRRMaster 
   TABLE DATA           '  COPY public."MRRMaster" ("MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo", "FinYear", "ItemQuantity", "MRRAmount", "VendorID", "DistrictID", "DMID", "AccID", "PaymentStatus", "POType", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "NoOfItemReceived", "ReceivedQuantity") FROM stdin;
    public          postgres    false    260   �      �          0    24616    NonSubsidyPODetails 
   TABLE DATA             COPY public."NonSubsidyPODetails" (id, "OrderReferenceNo", "PONo", "CustomerID", "DivisionID", "Implement", "Make", "Model", "UnitOfMeasurement", "HSN", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "ItemQuantity", "ItemQuantitySold", "EngineNumber", "ChassicNumber", "IsDelivered", "IsReceived", "IsDeliveredToCustomer", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    259   
�      �          0    24597    POMaster 
   TABLE DATA           �  COPY public."POMaster" ("FinYear", "PONo", "OrderReferenceNo", "CustomerID", "CustomerOrderRefence", "VendorID", "DistrictID", "DMID", "AccID", "DivisionID", "Implement", "Make", "Model", "UnitOfMeasurement", "HSN", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "TotalPurchaseInvoiceValue", "TotalPurchaseTaxableValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "TotalSellCGST", "TotalSellSGST", "TotalSellIGST", "TotalSellInvoiceValue", "TotalSellTaxableValue", "POAmount", "NoOfItemsInPO", "ItemQuantity", "ItemQuantitySold", "EngineNumber", "ChassicNumber", "IsDelivered", "IsReceived", "IsDeliveredToCustomer", "Status", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsApproved", "ApprovalStatus", "ApprovedDate", "ApprovedBy", "IsDeleted", "DeletedDate", "DeletedBy", "IsCancelled", "CancellationStatus", "CancelledDate", "CancelledBy", "POType", "VendorInvoiceNo", "MRRID", "RatePerUnit", "PackageQuantity", "PackageSize", "PackageUnitOfMeasurement", "DeliveredQuantity", "PendingQuantity") FROM stdin;
    public          postgres    false    257   '�      �          0    16793    StateMaster 
   TABLE DATA           A   COPY public."StateMaster" ("StateCode", "StateName") FROM stdin;
    public          postgres    false    246   ~      �          0    16953    VendorBankAccount 
   TABLE DATA           �   COPY public."VendorBankAccount" ("VendorID", "BankAccountID", "AccountNumber", "AccountType", "BankName", "BranchName", "IFSCCode", "BankDocument", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    253   �      �          0    16916    VendorContactPerson 
   TABLE DATA           �   COPY public."VendorContactPerson" ("VendorID", "ContactPersonID", "Name", "FathersName", "MobileNumber", "EmailID", "Designation", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    249   i/      �          0    16980    VendorDistrictMapping 
   TABLE DATA           [   COPY public."VendorDistrictMapping" ("VendorID", "DistrictID", "InsertedDate") FROM stdin;
    public          postgres    false    255   &L      �          0    16903    VendorMaster 
   TABLE DATA           �  COPY public."VendorMaster" ("VendorID", "LegalBussinessName", "TradeName", "PAN", "PANDocument", "BussinessConstitution", "GSTN", "GSTNDocument", "IncorporationDate", "ContactNumber", "EmailID", "ApprovalStatus", "ApplyStatus", "InsertedDate", "InsertedBy", "IsDeleted", "ApproveOrRejectDate", "ApproveOrRejectBy", "WhetherSSIUnit", "WhetherMSME", "SSIUnitRegistrationCertificate", "MSMECertificate", "CoreBussinessActivity", "Turnover1", "Turnover2", "Turnover3", "Password") FROM stdin;
    public          postgres    false    247   �W      �          0    16932    VendorPrincipalPlace 
   TABLE DATA           �   COPY public."VendorPrincipalPlace" ("VendorID", "PrincipalPlaceID", "Country", "StateCode", "DistrictOrCity", "Pincode", "Address", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    251   S�      �          0    16967    VendorServices 
   TABLE DATA           _   COPY public."VendorServices" ("VendorID", "Service", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    254   B�      p          0    16388    approval 
   TABLE DATA           $  COPY public.approval (sl_no, invoice_no, fin_year, dist_id, dl_id, status, approval_id, indent_no, approval_date, ammount, transaction_id, deduction_amount, pay_now_amount, payment_status, remark, dl_remark, paid_amount, pp_id, pp_status, dm_approved_on, bank_approved_on, items) FROM stdin;
    public          postgres    false    201   ��      q          0    16394    approval_desc 
   TABLE DATA           O   COPY public.approval_desc (approval_id, permit_no, serial, mrr_id) FROM stdin;
    public          postgres    false    202   0�      s          0    16402    approval_status_desc 
   TABLE DATA           A   COPY public.approval_status_desc (status_id, "desc") FROM stdin;
    public          postgres    false    204   �      t          0    16405 
   components 
   TABLE DATA           C   COPY public.components (comp_id, schema_id, comp_name) FROM stdin;
    public          postgres    false    205   q�      u          0    16408    dept_expenditure_payment_desc 
   TABLE DATA           �   COPY public.dept_expenditure_payment_desc (sl_no, reference_no, transaction_id, source_id, schem_id, comp_id, head_id, subhead_id, head_name, subhead_name, sd_path) FROM stdin;
    public          postgres    false    206   ��      z          0    16437    farmer_receipt 
   TABLE DATA           �   COPY public.farmer_receipt (sl_no, receipt_no, fin_year, farmer_name, farmer_id, full_ammount, permit_no, implement, payment_mode, payment_no, source_bank, date, dist_id, office, payment_date) FROM stdin;
    public          postgres    false    211   1�      v          0    16411    govt_share_config 
   TABLE DATA           S   COPY public.govt_share_config (sl, fin_year, head, govt_share_ammount) FROM stdin;
    public          postgres    false    207   8      |          0    16442    head_master 
   TABLE DATA           9   COPY public.head_master (head_id, head_name) FROM stdin;
    public          postgres    false    213   n      ~          0    16473 !   jalanidhi_dept_expnd_payment_desc 
   TABLE DATA           t   COPY public.jalanidhi_dept_expnd_payment_desc (serial, transaction_id, scheme_id, scheme_name, comp_id) FROM stdin;
    public          postgres    false    215   �      �          0    16478    jalanidhi_payment_desc 
   TABLE DATA           �   COPY public.jalanidhi_payment_desc (transaction_id, farmer_id, farmer_name, implement, make, model, serial, project_id) FROM stdin;
    public          postgres    false    217   -      �          0    16483    jn_expenditure_desc 
   TABLE DATA           f   COPY public.jn_expenditure_desc (transaction_id, item_name, item_price, quantity, serial) FROM stdin;
    public          postgres    false    219         �          0    16488 	   jn_orders 
   TABLE DATA           {   COPY public.jn_orders (fin_year, dist_id, cluster_id, farmer_id, dist_name, farmer_name, status, date, system) FROM stdin;
    public          postgres    false    221         �          0    16491    jn_stock 
   TABLE DATA           �   COPY public.jn_stock (fin_year, dist_id, dl_id, system, po_no, cluster_id, farmer_id, farmer_name, implement, make, model, engine_no, chassic_no, status, receive_date, deliver_date, dl_name) FROM stdin;
    public          postgres    false    222   �      �          0    16497    lgd_block_master 
   TABLE DATA           M   COPY public.lgd_block_master (dist_code, block_code, block_name) FROM stdin;
    public          postgres    false    223   �      �          0    16503    lgd_dist_master 
   TABLE DATA           ?   COPY public.lgd_dist_master (dist_code, dist_name) FROM stdin;
    public          postgres    false    224   �      �          0    16506    lgd_gp_master 
   TABLE DATA           P   COPY public.lgd_gp_master (dist_code, block_code, gp_code, gp_name) FROM stdin;
    public          postgres    false    225   �      �          0    16509    log 
   TABLE DATA           �   COPY public.log (sl_no, date_time, user_id, action, status, ref_url, route, ip, browser_name, browser_version, fin_year, remark) FROM stdin;
    public          postgres    false    226   �      �          0    16517    mrr 
   TABLE DATA           v   COPY public.mrr (sl_no, mrr_id, dist_id, invoice_no, fin_year, dl_id, date, items, indent_no, mrr_amount) FROM stdin;
    public          postgres    false    228   �E      �          0    16520    mrr_desc 
   TABLE DATA           5   COPY public.mrr_desc (mrr_id, permit_no) FROM stdin;
    public          postgres    false    229   xJ      �          0    16525    new_item_price 
   TABLE DATA           �   COPY public.new_item_price (implement, make, model, purchase_price, taxable_value, cgst_6, sags_6, invoice_alue, selling_price, sl_taxable_value, sl_cgst_6, sl_sgst_6, sl_invoice_value) FROM stdin;
    public          postgres    false    231   XL      �          0    16531    opening_balance 
   TABLE DATA           �   COPY public.opening_balance (fin_year, date, system, dist_id, transaction_id, ammount, remark, purpose, reference_no, "from", "to", head, subhead, payment_type, payment_date, payment_no, test) FROM stdin;
    public          postgres    false    232   d      �          0    16537    orders 
   TABLE DATA           y  COPY public.orders (permit_no, farmer_id, farmer_name, farmer_father_name, dist_name, block_name, gp_name, village_name, implement, make, model, status, permit_validity, permit_issue_date, fin_year, dist_id, engine_no, chassic_no, ammount, remark, expected_delivery_date, delivery_date, c_fin_year, date, system, paid_amount, order_type, "FullCost", "PendingCost") FROM stdin;
    public          postgres    false    233   h      �          0    16543    payment 
   TABLE DATA             COPY public.payment (sl_no, date, reference_no, transaction_id, "from", "to", remark, payment_type, payment_no, fin_year, purpose, payment_date, ammount, status, system, source_bank, "DivisionID", "Implement", "MoneyReceiptNo", "PayFrom", "PayTo", "PayFromID", "PayToID") FROM stdin;
    public          postgres    false    234   ��      �          0    16548    payment_desc 
   TABLE DATA           D   COPY public.payment_desc (transaction_id, reference_no) FROM stdin;
    public          postgres    false    236   �      �          0    16555    payment_purpose_desc 
   TABLE DATA           B   COPY public.payment_purpose_desc (purpose_id, "desc") FROM stdin;
    public          postgres    false    239   �      �          0    16558    schem_master 
   TABLE DATA           <   COPY public.schem_master (schem_id, schem_name) FROM stdin;
    public          postgres    false    240   }      �          0    16561    source_master 
   TABLE DATA           ?   COPY public.source_master (source_id, source_name) FROM stdin;
    public          postgres    false    241   �      �          0    16564    subheads 
   TABLE DATA           E   COPY public.subheads (subhead_id, head_id, subhead_name) FROM stdin;
    public          postgres    false    242   �      �          0    16567    system_desc 
   TABLE DATA           8   COPY public.system_desc (system_id, "desc") FROM stdin;
    public          postgres    false    243   �      �          0    16570 
   tax_config 
   TABLE DATA           6   COPY public.tax_config (tax_mode, "desc") FROM stdin;
    public          postgres    false    244   �      �          0    16573    users 
   TABLE DATA           8   COPY public.users (user_id, password, role) FROM stdin;
    public          postgres    false    245         �           0    0    BankMaster_BankID_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."BankMaster_BankID_seq"', 27, true);
          public          postgres    false    279            �           0    0    CustomerBankAccount_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."CustomerBankAccount_id_seq"', 39, true);
          public          postgres    false    267            �           0    0    CustomerContactPerson_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public."CustomerContactPerson_id_seq"', 163, true);
          public          postgres    false    263            �           0    0    CustomerMaster_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."CustomerMaster_id_seq"', 205, true);
          public          postgres    false    261            �           0    0    CustomerPrincipalPlace_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."CustomerPrincipalPlace_id_seq"', 230, true);
          public          postgres    false    265            �           0    0    ItemPackageSizeMaster_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public."ItemPackageSizeMaster_id_seq"', 19, true);
          public          postgres    false    272            �           0    0    NonSubsidyPODetails_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."NonSubsidyPODetails_id_seq"', 1, false);
          public          postgres    false    258            �           0    0 #   VendorBankAccount_BankAccountID_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public."VendorBankAccount_BankAccountID_seq"', 124, true);
          public          postgres    false    252            �           0    0 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE SET     Y   SELECT pg_catalog.setval('public."VendorContactPerson_ContactPersonID_seq"', 150, true);
          public          postgres    false    248            �           0    0 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE SET     [   SELECT pg_catalog.setval('public."VendorPrincipalPlace_PrincipalPlaceID_seq"', 133, true);
          public          postgres    false    250            �           0    0    approval_desc_serial_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.approval_desc_serial_seq', 107, true);
          public          postgres    false    203            �           0    0    customer_id_increment    SEQUENCE SET     E   SELECT pg_catalog.setval('public.customer_id_increment', 205, true);
          public          postgres    false    269            �           0    0    dept_money_config_sl_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.dept_money_config_sl_seq', 1, true);
          public          postgres    false    208            �           0    0    farmer_receipts_sl_no_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.farmer_receipts_sl_no_seq', 656, true);
          public          postgres    false    212            �           0    0 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE SET     [   SELECT pg_catalog.setval('public.jalanidhi_dept_expnd_payment_desc_serial_seq', 12, true);
          public          postgres    false    216            �           0    0 !   jalanidhi_payment_desc_serial_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.jalanidhi_payment_desc_serial_seq', 24, true);
          public          postgres    false    218            �           0    0    jn_expenditure_desc_serial_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.jn_expenditure_desc_serial_seq', 36, true);
          public          postgres    false    220            �           0    0    log_sl_no_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.log_sl_no_seq', 6507, true);
          public          postgres    false    227            �           0    0    mrr_sl_no_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.mrr_sl_no_seq', 229, true);
          public          postgres    false    230            �           0    0    payment1_sl_no_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.payment1_sl_no_seq', 1449, true);
          public          postgres    false    235            �           0    0    payment_desc_2_sl_no_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.payment_desc_2_sl_no_seq', 93, true);
          public          postgres    false    237            �           0    0    payment_invoice_sl_no_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.payment_invoice_sl_no_seq', 114, true);
          public          postgres    false    238            �           2606    24846    BankMaster BankMaster_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public."BankMaster"
    ADD CONSTRAINT "BankMaster_pkey" PRIMARY KEY ("BankID");
 H   ALTER TABLE ONLY public."BankMaster" DROP CONSTRAINT "BankMaster_pkey";
       public            postgres    false    280            �           2606    24696 ,   CustomerBankAccount CustomerBankAccount_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."CustomerBankAccount"
    ADD CONSTRAINT "CustomerBankAccount_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."CustomerBankAccount" DROP CONSTRAINT "CustomerBankAccount_pkey";
       public            postgres    false    268            �           2606    24669 0   CustomerContactPerson CustomerContactPerson_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."CustomerContactPerson"
    ADD CONSTRAINT "CustomerContactPerson_pkey" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public."CustomerContactPerson" DROP CONSTRAINT "CustomerContactPerson_pkey";
       public            postgres    false    264            �           2606    24764 4   CustomerDistrictMapping CustomerDistrictMapping_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CustomerDistrictMapping"
    ADD CONSTRAINT "CustomerDistrictMapping_pkey" PRIMARY KEY ("CustomerID", "DistrictID");
 b   ALTER TABLE ONLY public."CustomerDistrictMapping" DROP CONSTRAINT "CustomerDistrictMapping_pkey";
       public            postgres    false    274    274            �           2606    24809 0   CustomerInvoiceMaster CustomerInvoiceMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CustomerInvoiceMaster"
    ADD CONSTRAINT "CustomerInvoiceMaster_pkey" PRIMARY KEY ("CustomerInvoiceNo", "OrderReferenceNo");
 ^   ALTER TABLE ONLY public."CustomerInvoiceMaster" DROP CONSTRAINT "CustomerInvoiceMaster_pkey";
       public            postgres    false    275    275            �           2606    24658 "   CustomerMaster CustomerMaster_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."CustomerMaster"
    ADD CONSTRAINT "CustomerMaster_pkey" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public."CustomerMaster" DROP CONSTRAINT "CustomerMaster_pkey";
       public            postgres    false    262            �           2606    24680 2   CustomerPrincipalPlace CustomerPrincipalPlace_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."CustomerPrincipalPlace"
    ADD CONSTRAINT "CustomerPrincipalPlace_pkey" PRIMARY KEY (id);
 `   ALTER TABLE ONLY public."CustomerPrincipalPlace" DROP CONSTRAINT "CustomerPrincipalPlace_pkey";
       public            postgres    false    266            �           2606    24588 "   DivisionMaster DivisionMaster_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."DivisionMaster"
    ADD CONSTRAINT "DivisionMaster_pkey" PRIMARY KEY ("DivisionID");
 P   ALTER TABLE ONLY public."DivisionMaster" DROP CONSTRAINT "DivisionMaster_pkey";
       public            postgres    false    256            �           2606    24734     InvoiceMaster InvoiceMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."InvoiceMaster"
    ADD CONSTRAINT "InvoiceMaster_pkey" PRIMARY KEY ("InvoiceNo", "PONo", "OrderReferenceNo");
 N   ALTER TABLE ONLY public."InvoiceMaster" DROP CONSTRAINT "InvoiceMaster_pkey";
       public            postgres    false    270    270    270            �           2606    24772 (   ItemPackageMaster ItemPackageMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."ItemPackageMaster"
    ADD CONSTRAINT "ItemPackageMaster_pkey" PRIMARY KEY ("DivisionID", "Implement", "Make", "Model", "PackageSize", "UnitOfMeasurement");
 V   ALTER TABLE ONLY public."ItemPackageMaster" DROP CONSTRAINT "ItemPackageMaster_pkey";
       public            postgres    false    271    271    271    271    271    271            �           2606    24755 0   ItemPackageSizeMaster ItemPackageSizeMaster_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."ItemPackageSizeMaster"
    ADD CONSTRAINT "ItemPackageSizeMaster_pkey" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public."ItemPackageSizeMaster" DROP CONSTRAINT "ItemPackageSizeMaster_pkey";
       public            postgres    false    273            �           2606    24636    MRRMaster MRRMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."MRRMaster"
    ADD CONSTRAINT "MRRMaster_pkey" PRIMARY KEY ("MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo");
 F   ALTER TABLE ONLY public."MRRMaster" DROP CONSTRAINT "MRRMaster_pkey";
       public            postgres    false    260    260    260    260            �           2606    24627 ,   NonSubsidyPODetails NonSubsidyPODetails_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."NonSubsidyPODetails"
    ADD CONSTRAINT "NonSubsidyPODetails_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."NonSubsidyPODetails" DROP CONSTRAINT "NonSubsidyPODetails_pkey";
       public            postgres    false    259            �           2606    24613    POMaster POMaster_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."POMaster"
    ADD CONSTRAINT "POMaster_pkey" PRIMARY KEY ("PONo", "OrderReferenceNo");
 D   ALTER TABLE ONLY public."POMaster" DROP CONSTRAINT "POMaster_pkey";
       public            postgres    false    257    257            �           2606    16797    StateMaster StateMaster_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public."StateMaster"
    ADD CONSTRAINT "StateMaster_pkey" PRIMARY KEY ("StateCode");
 J   ALTER TABLE ONLY public."StateMaster" DROP CONSTRAINT "StateMaster_pkey";
       public            postgres    false    246            �           2606    16961 (   VendorBankAccount VendorBankAccount_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."VendorBankAccount"
    ADD CONSTRAINT "VendorBankAccount_pkey" PRIMARY KEY ("BankAccountID");
 V   ALTER TABLE ONLY public."VendorBankAccount" DROP CONSTRAINT "VendorBankAccount_pkey";
       public            postgres    false    253            �           2606    16924 ,   VendorContactPerson VendorContactPerson_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public."VendorContactPerson"
    ADD CONSTRAINT "VendorContactPerson_pkey" PRIMARY KEY ("ContactPersonID");
 Z   ALTER TABLE ONLY public."VendorContactPerson" DROP CONSTRAINT "VendorContactPerson_pkey";
       public            postgres    false    249            �           2606    16987 0   VendorDistrictMapping VendorDistrictMapping_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_pkey" PRIMARY KEY ("VendorID", "DistrictID");
 ^   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_pkey";
       public            postgres    false    255    255            �           2606    16913    VendorMaster VendorMaster_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."VendorMaster"
    ADD CONSTRAINT "VendorMaster_pkey" PRIMARY KEY ("VendorID");
 L   ALTER TABLE ONLY public."VendorMaster" DROP CONSTRAINT "VendorMaster_pkey";
       public            postgres    false    247            �           2606    16940 .   VendorPrincipalPlace VendorPrincipalPlace_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_pkey" PRIMARY KEY ("PrincipalPlaceID");
 \   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_pkey";
       public            postgres    false    251            �           2606    16974 "   VendorServices VendorServices_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."VendorServices"
    ADD CONSTRAINT "VendorServices_pkey" PRIMARY KEY ("VendorID", "Service");
 P   ALTER TABLE ONLY public."VendorServices" DROP CONSTRAINT "VendorServices_pkey";
       public            postgres    false    254    254            a           2606    16596 (   AccountantMaster accountants_master_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."AccountantMaster"
    ADD CONSTRAINT accountants_master_pkey PRIMARY KEY (acc_id, dist_id);
 T   ALTER TABLE ONLY public."AccountantMaster" DROP CONSTRAINT accountants_master_pkey;
       public            postgres    false    200    200            e           2606    16598     approval_desc approval_desc_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.approval_desc
    ADD CONSTRAINT approval_desc_pkey PRIMARY KEY (serial);
 J   ALTER TABLE ONLY public.approval_desc DROP CONSTRAINT approval_desc_pkey;
       public            postgres    false    202            g           2606    16600 .   approval_status_desc approval_status_desc_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.approval_status_desc
    ADD CONSTRAINT approval_status_desc_pkey PRIMARY KEY (status_id);
 X   ALTER TABLE ONLY public.approval_status_desc DROP CONSTRAINT approval_status_desc_pkey;
       public            postgres    false    204            i           2606    16602    components components_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.components
    ADD CONSTRAINT components_pkey PRIMARY KEY (comp_id);
 D   ALTER TABLE ONLY public.components DROP CONSTRAINT components_pkey;
       public            postgres    false    205            m           2606    16604 (   govt_share_config dept_money_config_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.govt_share_config
    ADD CONSTRAINT dept_money_config_pkey PRIMARY KEY (sl);
 R   ALTER TABLE ONLY public.govt_share_config DROP CONSTRAINT dept_money_config_pkey;
       public            postgres    false    207            o           2606    16608 !   DistrictMaster dist_master_1_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public."DistrictMaster"
    ADD CONSTRAINT dist_master_1_pkey PRIMARY KEY (dist_id);
 M   ALTER TABLE ONLY public."DistrictMaster" DROP CONSTRAINT dist_master_1_pkey;
       public            postgres    false    209            q           2606    16616    DMMaster dm_master_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public."DMMaster"
    ADD CONSTRAINT dm_master_pkey PRIMARY KEY (dm_id);
 C   ALTER TABLE ONLY public."DMMaster" DROP CONSTRAINT dm_master_pkey;
       public            postgres    false    210            s           2606    24577 #   farmer_receipt farmer_receipts_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.farmer_receipt
    ADD CONSTRAINT farmer_receipts_pkey PRIMARY KEY (receipt_no);
 M   ALTER TABLE ONLY public.farmer_receipt DROP CONSTRAINT farmer_receipts_pkey;
       public            postgres    false    211            u           2606    16620    head_master head_master_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.head_master
    ADD CONSTRAINT head_master_pkey PRIMARY KEY (head_id);
 F   ALTER TABLE ONLY public.head_master DROP CONSTRAINT head_master_pkey;
       public            postgres    false    213            w           2606    16632 !   ItemMaster item_price_map_1_pkey1 
   CONSTRAINT     {   ALTER TABLE ONLY public."ItemMaster"
    ADD CONSTRAINT item_price_map_1_pkey1 PRIMARY KEY ("Implement", "Make", "Model");
 M   ALTER TABLE ONLY public."ItemMaster" DROP CONSTRAINT item_price_map_1_pkey1;
       public            postgres    false    214    214    214            y           2606    16634 H   jalanidhi_dept_expnd_payment_desc jalanidhi_dept_expnd_payment_desc_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc
    ADD CONSTRAINT jalanidhi_dept_expnd_payment_desc_pkey PRIMARY KEY (serial);
 r   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc DROP CONSTRAINT jalanidhi_dept_expnd_payment_desc_pkey;
       public            postgres    false    215            {           2606    16636 2   jalanidhi_payment_desc jalanidhi_payment_desc_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.jalanidhi_payment_desc
    ADD CONSTRAINT jalanidhi_payment_desc_pkey PRIMARY KEY (serial);
 \   ALTER TABLE ONLY public.jalanidhi_payment_desc DROP CONSTRAINT jalanidhi_payment_desc_pkey;
       public            postgres    false    217            }           2606    16638 ,   jn_expenditure_desc jn_expenditure_desc_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.jn_expenditure_desc
    ADD CONSTRAINT jn_expenditure_desc_pkey PRIMARY KEY (serial);
 V   ALTER TABLE ONLY public.jn_expenditure_desc DROP CONSTRAINT jn_expenditure_desc_pkey;
       public            postgres    false    219                       2606    16640    jn_orders jn_orders_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.jn_orders
    ADD CONSTRAINT jn_orders_pkey PRIMARY KEY (cluster_id, farmer_id);
 B   ALTER TABLE ONLY public.jn_orders DROP CONSTRAINT jn_orders_pkey;
       public            postgres    false    221    221            �           2606    16642    jn_stock jn_stock_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.jn_stock
    ADD CONSTRAINT jn_stock_pkey PRIMARY KEY (po_no, cluster_id, farmer_id, implement, make, model);
 @   ALTER TABLE ONLY public.jn_stock DROP CONSTRAINT jn_stock_pkey;
       public            postgres    false    222    222    222    222    222    222            �           2606    16644 &   lgd_block_master lgd_block_master_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.lgd_block_master
    ADD CONSTRAINT lgd_block_master_pkey PRIMARY KEY (block_code);
 P   ALTER TABLE ONLY public.lgd_block_master DROP CONSTRAINT lgd_block_master_pkey;
       public            postgres    false    223            �           2606    16646 $   lgd_dist_master lgd_dist_master_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.lgd_dist_master
    ADD CONSTRAINT lgd_dist_master_pkey PRIMARY KEY (dist_code);
 N   ALTER TABLE ONLY public.lgd_dist_master DROP CONSTRAINT lgd_dist_master_pkey;
       public            postgres    false    224            �           2606    16648     lgd_gp_master lgd_gp_master_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT lgd_gp_master_pkey PRIMARY KEY (gp_code);
 J   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT lgd_gp_master_pkey;
       public            postgres    false    225            �           2606    16650    log log_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (sl_no);
 6   ALTER TABLE ONLY public.log DROP CONSTRAINT log_pkey;
       public            postgres    false    226            �           2606    16652    mrr_desc mrr_desc_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_pkey PRIMARY KEY (mrr_id, permit_no);
 @   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_pkey;
       public            postgres    false    229    229            �           2606    16654    mrr mrr_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.mrr
    ADD CONSTRAINT mrr_pkey PRIMARY KEY (mrr_id);
 6   ALTER TABLE ONLY public.mrr DROP CONSTRAINT mrr_pkey;
       public            postgres    false    228            �           2606    16656 "   new_item_price new_item_price_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.new_item_price
    ADD CONSTRAINT new_item_price_pkey PRIMARY KEY (implement, make, model);
 L   ALTER TABLE ONLY public.new_item_price DROP CONSTRAINT new_item_price_pkey;
       public            postgres    false    231    231    231            �           2606    16658 $   opening_balance opening_balance_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.opening_balance
    ADD CONSTRAINT opening_balance_pkey PRIMARY KEY (transaction_id);
 N   ALTER TABLE ONLY public.opening_balance DROP CONSTRAINT opening_balance_pkey;
       public            postgres    false    232            �           2606    16660    orders orders_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (permit_no);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    233            �           2606    16662    payment payment1_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment1_pkey PRIMARY KEY (transaction_id);
 ?   ALTER TABLE ONLY public.payment DROP CONSTRAINT payment1_pkey;
       public            postgres    false    234            k           2606    16664 1   dept_expenditure_payment_desc payment_desc_2_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.dept_expenditure_payment_desc
    ADD CONSTRAINT payment_desc_2_pkey PRIMARY KEY (sl_no);
 [   ALTER TABLE ONLY public.dept_expenditure_payment_desc DROP CONSTRAINT payment_desc_2_pkey;
       public            postgres    false    206            �           2606    16666    payment_desc payment_desc_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.payment_desc
    ADD CONSTRAINT payment_desc_pkey PRIMARY KEY (reference_no, transaction_id);
 H   ALTER TABLE ONLY public.payment_desc DROP CONSTRAINT payment_desc_pkey;
       public            postgres    false    236    236            c           2606    16668 !   approval payment_instruction_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.approval
    ADD CONSTRAINT payment_instruction_pkey PRIMARY KEY (sl_no);
 K   ALTER TABLE ONLY public.approval DROP CONSTRAINT payment_instruction_pkey;
       public            postgres    false    201            �           2606    16670 .   payment_purpose_desc payment_purpose_desc_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.payment_purpose_desc
    ADD CONSTRAINT payment_purpose_desc_pkey PRIMARY KEY (purpose_id);
 X   ALTER TABLE ONLY public.payment_purpose_desc DROP CONSTRAINT payment_purpose_desc_pkey;
       public            postgres    false    239            �           2606    16672    schem_master schema_master_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.schem_master
    ADD CONSTRAINT schema_master_pkey PRIMARY KEY (schem_id);
 I   ALTER TABLE ONLY public.schem_master DROP CONSTRAINT schema_master_pkey;
       public            postgres    false    240            �           2606    16674     source_master source_master_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.source_master
    ADD CONSTRAINT source_master_pkey PRIMARY KEY (source_id);
 J   ALTER TABLE ONLY public.source_master DROP CONSTRAINT source_master_pkey;
       public            postgres    false    241            �           2606    16676    subheads subhead_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.subheads
    ADD CONSTRAINT subhead_pkey PRIMARY KEY (subhead_id);
 ?   ALTER TABLE ONLY public.subheads DROP CONSTRAINT subhead_pkey;
       public            postgres    false    242            �           2606    16678    system_desc system_desc_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.system_desc
    ADD CONSTRAINT system_desc_pkey PRIMARY KEY (system_id);
 F   ALTER TABLE ONLY public.system_desc DROP CONSTRAINT system_desc_pkey;
       public            postgres    false    243            �           2606    16680    tax_config tax_config_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.tax_config
    ADD CONSTRAINT tax_config_pkey PRIMARY KEY (tax_mode);
 D   ALTER TABLE ONLY public.tax_config DROP CONSTRAINT tax_config_pkey;
       public            postgres    false    244            �           2606    17014    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    245            �           2620    24834    payment Generate_MR    TRIGGER     y   CREATE TRIGGER "Generate_MR" BEFORE INSERT ON public.payment FOR EACH ROW EXECUTE FUNCTION public."Paymnet_Insert_MR"();
 .   DROP TRIGGER "Generate_MR" ON public.payment;
       public          postgres    false    234    284            �           2620    24779     POMaster updateDeliveredQuantity    TRIGGER     �   CREATE TRIGGER "updateDeliveredQuantity" BEFORE UPDATE ON public."POMaster" FOR EACH ROW EXECUTE FUNCTION public."UpdateDeliveredQuantity"();
 =   DROP TRIGGER "updateDeliveredQuantity" ON public."POMaster";
       public          postgres    false    283    257            �           2620    24849 $   CustomerInvoiceMaster updatePOMaster    TRIGGER     �   CREATE TRIGGER "updatePOMaster" BEFORE INSERT ON public."CustomerInvoiceMaster" FOR EACH ROW EXECUTE FUNCTION public."addCustomerInvoiceMaster"();
 A   DROP TRIGGER "updatePOMaster" ON public."CustomerInvoiceMaster";
       public          postgres    false    297    275            �           2620    24735    InvoiceMaster update_invoice_no    TRIGGER     �   CREATE TRIGGER update_invoice_no AFTER INSERT ON public."InvoiceMaster" FOR EACH ROW EXECUTE FUNCTION public.update_invoice_number();
 :   DROP TRIGGER update_invoice_no ON public."InvoiceMaster";
       public          postgres    false    270    282            �           2620    24736    MRRMaster update_mrr_id    TRIGGER     v   CREATE TRIGGER update_mrr_id AFTER INSERT ON public."MRRMaster" FOR EACH ROW EXECUTE FUNCTION public.update_mrr_id();
 2   DROP TRIGGER update_mrr_id ON public."MRRMaster";
       public          postgres    false    285    260            �           2620    24637    POMaster update_order    TRIGGER     ~   CREATE TRIGGER update_order AFTER INSERT ON public."POMaster" FOR EACH ROW EXECUTE FUNCTION public.update_order_po_intiate();
 0   DROP TRIGGER update_order ON public."POMaster";
       public          postgres    false    257    281            �           2606    24765 ?   CustomerDistrictMapping CustomerDistrictMapping_DistrictID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomerDistrictMapping"
    ADD CONSTRAINT "CustomerDistrictMapping_DistrictID_fkey" FOREIGN KEY ("DistrictID") REFERENCES public."DistrictMaster"(dist_id) ON UPDATE CASCADE;
 m   ALTER TABLE ONLY public."CustomerDistrictMapping" DROP CONSTRAINT "CustomerDistrictMapping_DistrictID_fkey";
       public          postgres    false    3951    209    274            �           2606    24681 <   CustomerPrincipalPlace CustomerPrincipalPlace_StateCode_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomerPrincipalPlace"
    ADD CONSTRAINT "CustomerPrincipalPlace_StateCode_fkey" FOREIGN KEY ("StateCode") REFERENCES public."StateMaster"("StateCode") ON UPDATE CASCADE ON DELETE SET NULL;
 j   ALTER TABLE ONLY public."CustomerPrincipalPlace" DROP CONSTRAINT "CustomerPrincipalPlace_StateCode_fkey";
       public          postgres    false    4007    246    266            �           2606    16962 1   VendorBankAccount VendorBankAccount_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorBankAccount"
    ADD CONSTRAINT "VendorBankAccount_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 _   ALTER TABLE ONLY public."VendorBankAccount" DROP CONSTRAINT "VendorBankAccount_VendorID_fkey";
       public          postgres    false    253    247    4009            �           2606    16925 5   VendorContactPerson VendorContactPerson_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorContactPerson"
    ADD CONSTRAINT "VendorContactPerson_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 c   ALTER TABLE ONLY public."VendorContactPerson" DROP CONSTRAINT "VendorContactPerson_VendorID_fkey";
       public          postgres    false    247    4009    249            �           2606    16993 ;   VendorDistrictMapping VendorDistrictMapping_DistrictID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_DistrictID_fkey" FOREIGN KEY ("DistrictID") REFERENCES public."DistrictMaster"(dist_id) ON UPDATE CASCADE;
 i   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_DistrictID_fkey";
       public          postgres    false    255    3951    209            �           2606    16988 9   VendorDistrictMapping VendorDistrictMapping_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 g   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_VendorID_fkey";
       public          postgres    false    255    247    4009            �           2606    16946 8   VendorPrincipalPlace VendorPrincipalPlace_StateCode_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_StateCode_fkey" FOREIGN KEY ("StateCode") REFERENCES public."StateMaster"("StateCode") ON UPDATE CASCADE;
 f   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_StateCode_fkey";
       public          postgres    false    251    246    4007            �           2606    16941 7   VendorPrincipalPlace VendorPrincipalPlace_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 e   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_VendorID_fkey";
       public          postgres    false    251    4009    247            �           2606    16975 +   VendorServices VendorServices_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorServices"
    ADD CONSTRAINT "VendorServices_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 Y   ALTER TABLE ONLY public."VendorServices" DROP CONSTRAINT "VendorServices_VendorID_fkey";
       public          postgres    false    4009    247    254            �           2606    16685 *   approval_desc approval_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.approval_desc
    ADD CONSTRAINT approval_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 T   ALTER TABLE ONLY public.approval_desc DROP CONSTRAINT approval_desc_permit_no_fkey;
       public          postgres    false    233    202    3987            �           2606    16690    approval approval_status_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.approval
    ADD CONSTRAINT approval_status_fkey FOREIGN KEY (status) REFERENCES public.approval_status_desc(status_id) NOT VALID;
 G   ALTER TABLE ONLY public.approval DROP CONSTRAINT approval_status_fkey;
       public          postgres    false    3943    201    204            �           2606    16695    lgd_gp_master block_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT block_master FOREIGN KEY (block_code) REFERENCES public.lgd_block_master(block_code) NOT VALID;
 D   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT block_master;
       public          postgres    false    3971    225    223            �           2606    16705    lgd_gp_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 C   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT dist_master;
       public          postgres    false    225    3973    224            �           2606    16710    lgd_block_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_block_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 F   ALTER TABLE ONLY public.lgd_block_master DROP CONSTRAINT dist_master;
       public          postgres    false    223    224    3973            �           2606    16755 +   jn_stock jn_stock_cluster_id_farmer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.jn_stock
    ADD CONSTRAINT jn_stock_cluster_id_farmer_id_fkey FOREIGN KEY (cluster_id, farmer_id) REFERENCES public.jn_orders(cluster_id, farmer_id) NOT VALID;
 U   ALTER TABLE ONLY public.jn_stock DROP CONSTRAINT jn_stock_cluster_id_farmer_id_fkey;
       public          postgres    false    3967    222    222    221    221            �           2606    16760    mrr_desc mrr_desc_mrr_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_mrr_id_fkey FOREIGN KEY (mrr_id) REFERENCES public.mrr(mrr_id) NOT VALID;
 G   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_mrr_id_fkey;
       public          postgres    false    229    228    3979            �           2606    16765     mrr_desc mrr_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 J   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_permit_no_fkey;
       public          postgres    false    229    3987    233            �           2606    16770    mrr mrr_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr
    ADD CONSTRAINT mrr_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public."DistrictMaster"(dist_id) NOT VALID;
 >   ALTER TABLE ONLY public.mrr DROP CONSTRAINT mrr_dist_id_fkey;
       public          postgres    false    228    3951    209            �           2606    16775 ,   opening_balance opening_balance_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.opening_balance
    ADD CONSTRAINT opening_balance_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public."DistrictMaster"(dist_id);
 V   ALTER TABLE ONLY public.opening_balance DROP CONSTRAINT opening_balance_dist_id_fkey;
       public          postgres    false    3951    232    209            �           2606    16780 -   payment_desc payment_desc_transaction_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.payment_desc
    ADD CONSTRAINT payment_desc_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.payment(transaction_id) NOT VALID;
 W   ALTER TABLE ONLY public.payment_desc DROP CONSTRAINT payment_desc_transaction_id_fkey;
       public          postgres    false    234    3989    236            o   �  x�}W]S�:}����I��Ix�A*r�ܙ���V�uJ{ﯿ+)E��8�.�k���fU�:���$f4�\����.�K)��pSn�}SvW��6�E0�uV��]q��˃ݽ���L�	�I����8!��%���
��d �F1��M��޾�}���-�a����ܫ��fIhD���򊤙��Q8Mxw��>���Wuv)EB�#.���'v��V‽��&�^�9^��Î'W�̤�PM>n��uU6A�;eeS��Ǽ�v��/h�km�vs�����1G/���YQ2�i����<���,��a�c����u��:˚�`a�����K[n0�k��~6��"J��bMe�?OA�
cοNa�N�fym��)9y��n�,+W�0ˋr�۰i�'��EQ_�T7ި�K))���f��g�I�8���!���x�c���f���-�CZ�*�4ȫ��
�)X��>�^�}�]n"��&�P%Tcbg�bɀː����a���Yi��ej��h��K�\�+�u��K0@�#U�u;")�D*3�@����C����b����D���y�{�%1�厠@#��W�}b��(
�`��*�p&�^c#��[��௶.�������e�֠��^�|j)4æ�DG*V�8����`!��ޮ�MA��/ ��w�Q�|1�&���Y�W��\��iW�U(����H�X$1g�U`I�D��힂n����z�&�"����4�۶��(~�g I�h��7��|���E�i�LT"�<�D�L�P���aJ��	�
���01㥙�>L'�į�l�rd��s�����!�$\Fc)��Q{��Xx��Zc5�SԻ�xB �]��>��M�~�wt��+��ӌ�DɄS�DX�3T)Cޯ���͆�|�����f�R%���-h�[4� ��Ū?��K�����R�6X8=�z���,;�۵I�fN#�Ȕ�vW'�:s%g5�)8酅��|'�~��-�w;����%���n	1�'L�>�=_ݦ�<���U�]��:Pa���q/�	��O����d؟q�Y��a:�|<�ݩ�6�S�{
r�٫nߠ3=��7I�?�[:�A>.h���j@�P
�u:K��cC"I�񵓳�Ԏ��|���f�b��]��=	K���̄�Lc��!N3ct���
���lnng^�����<9?
�p>Wo[�G�����'DK)�Ʊ�g�P�H�J|s��	�Ñ;4�oV��A�FӑƢz�e�4�/<	����l���Z��>j7�2��!rNnk��}�L�j�$��C?�X�!��X�c^l��s��M�r��^c�P��'7�?���@�M�֡���z�:V���N���i�tp��K�>Զ	nݥ�Q�*��.��$����<�v����:!� �GJk�اCSAgBM��J_��m�6Y/]͊"-�	ݩ�'6a�w����Pq\8�p��ϊ���*��x�]ݥ���~��@>�w�y9U��wWiU>�[�ޙp%�>'�vj��7�97���p�tJ"FN����� Ϟ�ū�N��������(��K��ﱈ�>��o�7���k�ԝd1��c��0�g�<P&�� ��ɞzF�c�ZŤ�o3w���'g�� �ڮ�6-p���N��]����?�vgRw��%Ŀ.����H0�}A����e8��(�������s|u�i�"���qVu�4���_���;�y#5`�V?�_�?�� �#      �   y  x�eRMo�0=;�"�	.��58B+4�6&!8�bH�Z�)��~�(��C���g��l-Z�Hg�����B6�&^��ygE�$�~�^���� I�H�2�!�uF��c4��� C��JÓ���،�e%����x�P���<I\��Z`�$n��d�g3�����Vij�;�!�1�u��.��4��(˝w����\V��>񭢊g� \��v��lN"6���6m�њ�C؅�Zo�6�oV�Xp7��:QGg�yS��De��P��ɫL�%u���H���O!����ʇg��B>ޤ}x�����
��C��c�٪6�F���i�;���<Re|rk4�����;��/��EL`�]��ڜ��Ź���@=��c���h�x      �   �  x��WMs�8=;����q��m�d�I<C�Ps��f�&�IA����ے0��M��bq(�=u�~�bI��3�|o��SB��� ���^w�����e߽%�}���H��~��&-m��&����N�*���z~�N��ssW��lѦek��6�-������A�����L@�#��Սc�����¾;s�Ei
�`�`��aHqO
*8ѐT��vٽ	����2�x�3����M��rg�?��n�yY7x��	:	Uՙ汐.BD�������x<F+��_�f�N���&$M�(˔�f�S �Ƅք���/H�Sw���r�[�݁�|�=췯��rk������wp۝a���LP#���{u��"�e(���zk���f12革�����!' �ʁ�.8�@��yh�9M�$�qWM��>��w�\4~ᷳ�v��C0��{.P "3 �<�ܽ
�sJ �)~.8؜1(���1�m�7�<V�,P|�k�$
2_W���L��s|�#�u��9��$*���k�^5g��Z\�/�i_ˍ�-����"�:��L�؉����)
T1���4�
_�}%�Bn6���r٦>DVhFYK6����1	���<hTx���'t�^��`M�����e�c�w������1%� �?��_�}g��m�sM��u4B��Ǘ>�B:#<*�S��faffd�T��g�X[��<�*&.��_{�aXZ�j�h���!EOޘoߚԌ����9瀂p���'������\�B0�M����_O��E[���\��@^ Aۍ��۝�1 �f�8ct�ڴ��������1����Ѓ��I����O=�fڣ��U@iAt�S������9�`'e2F����ڃ�z�UM[:k��\<`���zkÈ�s��&X4���6G��u��b�/8�k�p�w:�,����>X�c�=����m�]���.��y��w;,� �Pt�Kgwv�J���a�/f+�;��²9���Td9�1t�}�A��C��{Nv3^��Ǿ▝A��pg�,�I��8�a�dN�n.�)�e�^n^^����6�-f^77��0���R��,&ɨ*'�6n� �̈;<g8�eQ�1�x�A�T�P���/��~�R_���w?;�V�:�7��ʝy�E����'A ������_��i��P7���w���i�3��k�ԧF��d`� 5%^���K|4\n�w�Yܗ51�d,��0�c#��?���ELO�r��TR��H��m��|�$	�S!�)?�ٗ�Gx3��G���x
�F\C�TܑTHD�F4/O�/q���/7b�z#v+O1ׇ�_�,�|o�8n+��p�6r9�'3��Qk�|�㙓�O��9"��.ҙ�6]�?��r��]�M� �W�Ҵ33��a����7/�㑍K:�2��}�������o2�      �      x��[�n�H�}f���e1D^��L?5�ҔY�/Х{
`A[*��,�T�5_�'"�Kզ%��6\ȭ�afF�8qI����Cm��ӏϴ͕�L&�ٺz{��m���[U/���7��J�M��ɼ#��L_	�Jo�S�+-��{Wއ���,?]���rx�0�܎�AgX܌/d�K��<��ׯ��#���}�ԛ��4}e�+iR#M-�d�	 ���� ��Z�3�ϝI��l��H3�~m������Ju���암�y3cL޿a��6���[�t��I��VJ������뗓kx�aSSid�0�����u9�f�����?5�KZ�z:�����+��<����r���qP|�`�Z/����@�z���� ������bxӹ������
���[�Vm���l�H����`D�Nǈ9o�w7w;���{S_�:���l[��ʮ���.�Ay����y>�^��L�?6�����X�w)�B֛��p� �3i�UI�l+Û���s]�[2Kx���$o���z����.X�f.�%+������/qv�~�N�r/��v�V-k!$�vO�+%R�c�i���T�Q`��Ӡ���3d���w�99d��TVm.���8�.sLΌ�-��c�7�J�s���X!\��g"y�>y޾M��u�� T�+�S�Ŭ�0����/��8G_���
�l��~zip��T�I3s}�T���?P71j��f���Z�k���ȧ!3fpu%u��d�q�>��%�"ǠH�&s��$�����Z��/��W:K}�Q���q]��[���}ѹ/��g4h'�9)�[5�ΰ\F<@����� sBS�]���l� !�I�9����'��;]V�j���3��|'5YԀ��3^q}Sb������͝�o��Sm�l�&;�	rW*KU2gr�|-�_��8"��"SJ&�=h�7*�A���(��^�3�l�����1�]��G�r[��2�.�v��\�8%TGtu�D������й��G"!��/.�
0mbr#g��L{XS9*�b4(S����/_��)^y�bX�:>P̣l�����+���I���e�<�5�)EZ����L7����=��.�A��������tU͝�#N�/.�5$���L8�	�����k��ܼo�d����d2�/����<d .�pr&��E�E���8����5�k��������,
�T�j�߃;
{�^�i��ɬjj�!9apF00t������2�Y�SqOW|*�IVYm�M^�%�mQ�g$��8��J�T���[��\���s�/;�+��E��N����1/��Ī/X-BNUFŏe��L87��T���&�(����h geG�]%s�g����7��oq�Y�!f!�z��&�E������0�X �Vʸ&�� ���	����*5�<�4���b\'�(e$e�D��Q�H@2��z�H���.j��㳬��r�#����TDӝ��`�� x���)	�^I�d��U�Y=�%"2��Ӯq��F-B�?䮜@���R¥��Hh���	hpaҨX爵Yr��V�9��\U�&��0���,�A,�
�� ^�t��VI�L�y"'?����åYTG2�JѮ��Hv�!9-K$}o�y�n�i�m�&]*��9�1�6��㰸k��n}����z��\W���i2?�v���)�g̒�G��ޱ��4~��:��4��>ͪ�?��馞Փ�h8���X2���	yp��r�2�L�Ţ^�lW�ʙ_�W���Ӡ��,�yl�%;�d?�	�݆��~{�L2o��ٲz��i�d	8�NgE��+����d?�.$E��?���Z},2�%o}n�� XK���|H��J�C� �f��(�*���2w:����)BD���V�?y�v�je���]��g} �n	�)'�3�Hϖ�?C�₺]�̰�T���&+#�K�oz��q���$R�te�������>=]�Ќ�4ˣ����f�L��ɬzK'�˯��i�L~�v�Ua��$����~�<����~*�j�}YZ̟S�2��U�(�3�����#8��R���g�כ�{����|�����/�9@ٰ��i��>!��fG�����5
�}K�i�o~~z���S�+(v-�+Ϳ��}Kߑ�������O�E��D���w]t�#�:��M��>8z�\׋�X�S�ܜN�B�^J�*d]Q�-i��aAj ��-Qk����PxF@�4��t�Ο�*���Eu�f��&�@1G��i9�=|�S8�@g�Lltjc��*��*Y��/�3�T���	?�H�
��(�h6'�3'���YM�\��5UH��y�Q5����6Y����{���7���������q��������7�|q��F��K���,0�7&7
�n�g;���6�2��E4g�A~����2�C�=W�a��31O�=�b�d��Ņ'g�o(�A�)%���E\~6E@��5 8�ݖP���W�t|�ڜ�>����.�R�J�P�.�Q��e�����FVO2~N~�^��ĕ򩍶0l�䙙n�������ak��T�ZP��L�; �T*��i] dJ���+X�N�<Y��~���%��J��GC�)�`6����da@C���l_=o8�kE�7��]Ȫ���2�btӹ���Q:C����<�e�c�s!C�t�s9j�g�V�r�	x�R�U���ޜo�X�
N9}4t!?̓����3(�u��~����dY7oբ���oHUN�(��R�bn�����w�����t3�MV��Z�u�l�E��is�Mp��6���4$��ڦ��U�����	턔<E��0���~t.pPH=$!�Ѡ���-�;3e V�j9�r�T_��Ԉ"UhR���@ER�p?*�ER���-z1��eL�H�	�J5R;C��-�
\���Zcy�`V��֪s��hf��Ծ�b���([s2>�<����8������b����3C]`���Ǉ�_��R�OZ����o�|v�+�J��VS7������!�+�����6�)e�g7[^q{>ͣk���B^?���-��n�j3��=�����f�E�7�dp��>�0=eH^�ySSc2�V�Q�����h���Bb�� �x��+Y�i�%=<sg��Q/��@N!���74 u4x!w��d�xj�73�ş:Bɒ���*�>�TH����g���(cB���`��Zi��X��B����˰�v�e�d����jV���^N�J���ܮ�|*�Y�,
mo�ˮ*�s�f<U�h"�u��'�q�_�:c)X*T��~q}s(��{ IV1�x
kp22��t9?�9EA%�(p ��r_C�p�=L{Agȣ��5Pդ���],���м������NYc�zx�3�A�����<Ĥjֳ�ݶ^O�U�0T@ϩ�Wb0:�1��{�]�18/����2�x��O �Oc�ݐ�I��Q��S���)�|�R#YU�Y�4������ր������2D���>���n�K�]f�g��z�d��O��o�Β�^�2���]8l��
J8ȹ�m�Z)D�3M�������>���Y��q�_�K���b`5����>�6K����dv�L-u�<�q#&>Ǐ=�Զ�S�������K��
f��f�$3g���Q]K�w:0�n��G�v��
���f:� ھ�
y�HP!7��<�Z��`~����D`,�����pT��#r�!&�z9�����S#,n䁸B�$r��(��x���:j�\���e)�1�"j��ǹ��=@;��;`oU����C?,���m߀��8�����&�w�)�\d�~��tz�^,�}�9:E�dۣ
�&��i
�Кw԰1&Y���Y-3w�|�恋x{�mPe�a�����Ǳ9R���Iռn��)u	���3�SJ۔��������DP`d����{5G��O��8�5��Nʶ'eZӢܾ�&�3{<�ꜗ4��Z��ǠR�M�#(��`M��̏���oc��V D|�.aT   ؚ3��:���Eŝ�*i�<���nLI:#� �9��+�9W'�N��:㶧��U`-�Kh�;��]ߎ��B�y�{��Vo�Q�=�NN��=xF�	��y�2fo��aH:G�`U0hc�pD�C�{P#Y��W�[2�fߗ<�ǎ�%��Z$�ߗ5��)��B���~Pΐ�m��F�G42}|_�:�������Pv��I�\m����X�"C�L�����͟�r�e�0�f�����γ��������Gh��0���ޔ;�bSkk癡b+�Ro�V��$>!
�*W�EI��0�M��˕��D�@���zv<�-/��Tܱ2��*pX���q�5�F�k��A���i�:K���{�0�}�CSor� :���Ȕ�6:�&����ֻ�8�o2;�+ֱ͒W͔����"<�{j�h�]��kyvT���E�LҸՓɲ̝�t�W4�y�Mj>���d�	���A��b_&uH>TF�e��U<y,[��Do~��^��a�<�ϭw;��9̜��I�N�ɷ��9I�L0#(u�X�@��/wH�:�Fe����{Lv�N�DX�u��(r��9�{���˯�G�sx���6I�T���L��'�<Z�p]��r�������9M�>A~G��쩓�X����R�B��e�PN-�PA���ʝ%�'��7��S�'��Zј�������r 5�o
��-��0k��)U43P_0��=P�1l��vpIg�Z�q����6i2�.O��]���DwC�R�jQ����]{I��a�"�cN��e�[�=t�R<�#��P�k�"�]�v3;��6'xH6№�Za��sK[� 
��t��Ýq{�A�Q4P���0+\��c�#��M��p+O��2�p�h܇E�j-h� �D|�lպnW|��O������d��'�u���Y١�Tⵦ������j��w���`|��8Z�nG�_�����è�ȕ�P��6}�U5��К�?�x�"�ғ������]��K#��0d�����ȝ��"D�϶'��A���@n��p_����!s���x��sK�6>M�N+�=�%�2�n��pe����J%R_!p(�-���y���/9f�C+R�P�d�=�����ڹ�-�$4(�N�$�t	����6le��'��,�K�SS���a�bC�ʠ�DdbLI��$��n�I�f8��}/B)}��G&T��3R}��ڣ��a��0`��'�-	�\�F#���TH��᮫9�r:��dC������C�iw��E��Xva5'���2��Q�K���}��A��7���#$��wO���[�Xh�4S���tX�vle�w`��2���v��U��7����#���I<����L�%�ܕ�q[b=��]�`�P{
dt�@�{}*"���v���s���,�3Mi\�f��8�5=Yk;� 7d�x
n�)��@R�8��uq���7�n]�%���U��>-�(�����-�p�O�٤���ոM\���d�p��L�mq5��hOQ�KJ��,@�:\`�&�����+�9s�f��L����T��      �   6  x�m�M�%�
��U��y�,��mb�Kh�������R�����������ܙ~w�M���#�����<��������������d�&��?��G�1��I�gO[�URC�܎��v:�C�LM~foG�����3p/�^P��ٜ��H��k);�0�y`0G����h��TXb�{�}8�2�6%m�U�8f}�qe}�`2w7���t��ra5�f��%�Q`�0�I�a���K�q���34p�r!�������ƅ
2�v+T�+�:�n�0����������1�E��Ԕ��c�uJ�>���4����h�����C=f��%6���4���`7Z2�~:��K̞0�ݨ��>z�3Ht�K!��Dp2wȤ��<�;�#eʓ����mM�N���bD�7�VW�ۖ�www��1&���I��nT���HƐ'��˙V��iA%/�d�1����O����L��B��l��7��jQƸ?ݒ���\`�צ��B��6Lv��B�;�,�m�T�դ��(byk�16�CP��.0��@�c���=t����^|n޽��9��"l��3R�3��������w^��g��D 6-��pN��
7^P!';��B�kCa�B�ѯ�?�Pm�؍}��ư�a��O��2�q�8�H͌�7=f}���zW�Z�������KN�C6:��N��	w�;���Ƀ/΀!��n���N��R��ьYr�m���^`�B!��rƐAP�fw��(��]���3c�?�P�\Ĩde��|���nh�І��_�l������n��u}�h��D���7�=Yw]�P��؝2��F
	\�a�Z���I�eu��L.	a��N�F�����ϋR�_x,����+�c�Z���C����o� ݁��]�j;�����X���2�����=�w'S��0���@�FM�]hܲ�	�ɛ�aw��'����8�$���{�aM�u��36Q̯҃� ��~@I��	������_��z/'=�����$����oM�������Po>����DN��27�3h�箂�[}B�P��Pi�fn�
�0��i�Y c�����>��j=��>�0�d�f�v:y�����^WP[�G3w�wȿ�h�p?�e��I��k��0������BG�!a��ܱ�}h���F��v��P�4s��QL}'��8�h�hަ車���8.8����1��P�9p��Ԓ����.0r�^OZ��?���M����̡����;������Q���bR~!�gc���!<ևk��"���q��.	rndQnn�
�q��]G�b8N����m��!�#'hJ�����m�i�s's�'z�W���Jt�]��VQ����Jb�}��SX�&1�V^��e%1Ĝ�(n�Ɇd������� g�1�͡cBŗ�|�S��[Ѐ����gQ��MK/h��]>��:���j��3�7G�छ�<Զc�����l9��{�w;�X*1�7�}sl��r��,)�9$�`���$LoNl(=�#ޟ$��A_�h?���c�+:lǡT����P'���A6���DN㸴G�ꁻ�%ᄎ	cs�p��RJ��7n)��,�3w7Mj�M�on��U��Rp�8-	f��m���A鋓�]������ ���zy��~�����ᡟ}�qr7�t���R���j���\p����~�'�;Ýï7HW��u�e��{�䉳�5�쇙<sw�\���X+��;���C�*�0�gN�_�׃1�'�r� s����������7l@�C�+�V>�?��������ҁ��      �   V	  x��[o�F���_��E�"3�3��R�(�C��,��Vc5��r�����g8�Iʔ��ݵCQ������fƓ�����%#��{I���x�������`��}5�������w��,�~�e�e.C�_FA1S��}G�P��LI�ѐB"f"��� s$�~o��%'g�c'KL����TLYD�,dq����l�ivh�P1��,2&&:RFt0��1��o3?�Y�(A����XH�s�e��=O���Ç'���D컘���cQ�yF�����������-�C�d�a~�?�p.xp4_��g�z���9˂��ˇU����*ݭ��l������
��p�k���Z�>���Y���n?ϳ�b1����g���y?��'��(��]�pJ(���x�X}�қ[T�?�(�����'	HD�zi������X�����J�Y�m��Ro��!%6�)��s[��7��M|���j{m�m�|�����؃�+#T��f���*u����W��q)ύ�%56Y�ʾ�ج $�
�7��6y[ׂ�����
�k���z�,�a�`/_��ho���U��p�`�������'i�~N���?Zj�;���0�n�[�h�\s�Ak�$a��z�V	��\a�m������f���G�峂��-�j�m"j/"e�F�'���5�,i����Yk|���8��x��Xb1�X&?'��m0��,~��������l0	A�`@��Ś��#��An�Z �����"��?o3M=p��v�G��!����L�I@a�a���P65��@3��Γ�d�TI%�����q���n�%�J�հ����N �Q�G	f@��z�LU	Ì4�m�^ BrVܬ�}V�b�]Ͽ����y<��� �_�L��I�&��
�2JPU5���o� ��ŻQr2<N��h�j<J�C{!��	�����"���&]
#�@9����6Q/I0MY�Ph-�|��s]Ͽ����:6]*T<9Gg���ށ��UD<��A܃�u1Op�l��zbs6{�ƚ�m%��5\��h<�Ÿn.����w�����zje�ʠ��]� ��������&>�ŇV��Y�����'�B����Z�yt�T����Q���O0A��O�H���)�,4vL����z�Q�.��Qz3��W����u�v!IP�H��8�W �Ti�&�'	h��Ys۹��TF�1�W$u�����iy�8J�͂�}@GGlW��9�	�Q�,7���V����߸n�#�ɏa����M��
�v�P�Uo!b��l2�����r�]�GZ�n��>�DǓѸ[H�	R�c�FO��-��m<�|�|csI�G�#�����f~�;c�iz=_^ei���w���]�)� k;�bN����̕ h!�-�&����(vu��ͪ1���q%�.X5�nx��*8Z~^tˆ[��a�󡉠��߮Q�4y�*`�ڌx�H��u��^e��g]�1F�!9���r�,]	 @���^�3��H�zP<�	霛1[��z~?��.ś�/?��һ���j��ͯ>�&���k�v�qm�Y�x�DJ��I��C���ˉ�=�Ė&�lrܧ����k3�z�mFW}�m�o�0��ک�و��)bw�Mu�k+�ʝ�1�!�Wyj�8>�H�y�\w��(#.�r�5��zP��R  ���W���H��7(Ed5ܸ��
E�������7J�F`m���Vk�~�Lg�O��*~50*��(9J�Ȳ^�)w��Xi�^[���h=}������J���zL=(���2ۃ<6�E���~gۋjP��f�EiED�g���S����f4�o��]�F�F��Ѩ�*S#6��W� |"<2�O�=|���K�n�y��6�uz{�~Z����\5�<ׂ�D=pѳ�i�9���z!
,_�Y�jP�di�[C J�����wW5���@0O�::�fYþ�[DIn�,�8;ٮS�<���d��������5֩�A�.ō��V)%f�zP`-��nՈ6Q?VŅ_
�����n�9�j�{��wo|s�d��
�@k�&���ʿ�ӎ�b2����?�������Mr<Eg�����L�&Þ��Y�&Ѡ9Y��-Ҳ�ug!���RD̴��^��m�_ܪQR��A+�� T����{A U\�u�n�Lc��u��U;�eM��R�5@�yܦ��;������uv�����3cu/D��]�G�}41��u@m�l����#pl>"h.촫�	dO�p�>���Y ���LO�6�z��V���
�6Q?P�][R�e\V�%\+�ڒr��@�7q� ����N׮�c\����?�����k�� �| �5���K��ٳ��Fd      �      x��}[s붒�3���ӮI��< ���J�E�Ɛ�W��U�hK��l�.INfͯ?� EJdk��&� 6��>��+��<t:ӂ�NQ�˝��x-7nQ.?�nz�N��-��.�$n'M���{Y2��l���Y-vo��r��0���l�D�RFB8[�����ӯO����{|{ua�_$�c.%WB^qߣ��"�|��0��K�N:���I��B�� +�N'��4���)����p?d��6��[����b�=��^xD�cD�F9���8n��U���;�l�2���)��Fg��FaF�ܩ!!�����������`�ɵ�M�I�v&���i:�L��__�S����{����/?w��Y�w��Žy�s���bW��g�q���a���˧_׫Go��1S�R�\Q�ѐa��V:C5R�ݪ.�x�o�@���<��")`CN�y���Eua��D:s$�Q@��}���)���5��EE����|߃�z�D#�ߺ��N�Vݨ�HMz�u�O�@˝8��r���mhtFx�A
{���ۼ}�(9+�-H�_�Ӱ���v�����怇��I��K�ƻ�{���V/��^l��?�����e?ß�=����mC���fJ}R�ܖ����
��6#48����:"G��������r7C�ǿu�$��H����k�1-\|pB��wO��n���y���X��r���ɧ�4WC`��mwzA��u.I�'+7����x6�!~"�|*7�/���e�)_ϯ>⁐<� ��)z��}�8�%�����~��7���,�I�0K��,���GC�PF�JI����[���b�ؔ4��+������c�Z���t��j4Q� G]���}U�6�Ib���h }D���{�������(mq���(���f�j�5�a�{7Y�Z�^C���^��Q�g���F��<3
�q��{�`Ns��� 4��4�(�ާ��}����:����#�[���љ~��J���o�}����[-W��Y���<8�� �]X������+��	�ȃ���gc=㑣���~`.5��|���ɨ3_���ޟ>�w���(�oo6� ��Ӗ8��~>-z��im�21Sy�\� �����oY�$�ڶbM���j	�vt�7��|\܀4����WU^10�X��`T���ު{��Ѓ�1XZ��,��r+ʚ� ;q�{� ���{ ;ѧ �#�X-S�90f�*4G���H�5NݎB|���>��	>�W��,u"b1d$�]�_�K�<&~����Ӛ�i��ME�Km��caT��ڄ)@�tS�m�3�a��a� Vw��2�>�&Fӥ&��;K ��^���݁���)����c��l�/�V��4�%��z��h؝�7�c�B��ڲt5��F>SP&�����
�.��x�+��V-�nr���4Gc�v{j8B]��O���͊���8��m�,_��k��-:������`�RmD_~�G���1�sƷA/ACz��_`Z���� `sp����aO�a���Ο _Η��@�>�6��ꉀzj��VO0Z`�t :i���VJ���n������o�x翋������5���Ig:I�0�n�Q[�p��G6K�ᗟ��B&X,�'���-h����+�<�+5��������\���mO�b��X�`��`}�J`,����-W� ��oV �ܻ�ӏr�����ٞ�8E2Jq�tR`Y@����]x�ޠ�O��q�����s�ｷ��Oo��/��y��}��q��{ߖ��H�?6�9����h�" ��?��B=0z�-[Ø�0�|:�T�S�u�K��v3�X��%��д]	����	��?%(��f�ҁ�2J52
�����䛈��t�Xu�0����9òt���e���ܬ�ɦ�k�:f����8TC�3�D$"`x�=䬷���p�1����a�ǃc+����Ba��,\-�d�kW���$IZX��%؊� JC����]��c�Xx�/g!24w�P� �gc�r0��*��ۣp��fI�$�"���D{@m.DM�3� �K�lC܃0�� oV�Y��W�/��WZ���u�g]���K
5�M�x�#�ԧ�y�����y"1K=ъ���0�Q����uK��������s7�Up�C	B�w>� %�o��������1|v�E��0^�-W)H��xp�79��	��ؚ���<����C��X�q-'`<R��aK��u�w�Oi��g!0|"�!P��}�(w�qFh�FQ+@�m�ͧ��O��`�y��p���I��?_^���m)_�\0�A��C�R.?\��ys�A�?��K$���q�u��;���'"�_Cd ������)�߿����D�&�|�'��h"bMX�F�+P��kwv���ŋnht6��D�����U�٧����!�?(4��!(5w��EX��r���:��-�8B�t�v~f�:�2����!G�+��]��QE
�v�<<���Mb��3�_�-����@������A[�<�bz3E��?�7>eS�		|!pk�ߗ��¯�04N}���R��u�t�1��͟}�F�A1��`���1�%��A΀9wr�:�^2,�w�d�Kۿv�,+B��fC��H[���N:�-���)�mSQq���Akq����
^���E���O��8n�� ��U<'��R2��ŢZ���ߕ�G���V�!��o��+�ə �*@����?�e���[rZ��q�%ܳ]<���}�������s��%c{TjY�}�Ÿ��Z@[�E�_0f9��i�����T��zDK\���L0Nl����ٝ1�)ѧ��~��=P�`����Zq��a�ö<����90��[�e���-l[��l!� ���������=*�c�c�m����e�0k�)7Vy���[5�]ܻ�b�?��?5�����D��u�`��×
����Ӗ4����>�R�?.��5�kqr���59��jt�	 89Ăūit��a���x~-�+BPv�C���Zˮ@kj59v��B�]�o3�('� nC�\�ƥdxRT�1�|ڔ�/�80�C]P�� �����X�[�V@O��לkĝ;x�!m�暆�@�!F���ǏW`���,JF�(&y�~���A�O�3!�1ɨs�ĉ�2	��%����������K<�xx����U��_��ΰ���K8.���d����B�� �BQ��@룠�ރ�CH�j�������6�;A]Y���K�y\��ѵ��s8�tp���W���.�^�<�6�O0G���B;�9�� S��� U_a�o��v���*�af(�)},Q�}`���~�7��.���V���#�D-����_���/��{.\ٷ��'P9ʅ��ZQ���'�%����>��1i;Jmz��j%����L�^�~�4�����?��W`%Z��[#�VX0^����7x)�����F������]!�A#�~��*=ْ�Ve0^�b��o�[@?˰��F��O���O����r��Q+�jM�� �s2]�v�� ^�Z{V��0�p�*����-���y���䯅�28�r�0����>Am��c+6Ԋ+��}�x���X�7�-��o�vZ�V]at�Z����\*���\�z�%e��a0��(�2*|��4�tՁ�����v�r���+[���+[�������I|ޢ.����|	�m����1�C�w,u��f0��=h���1�X&�{�F	8h�<�q��#�RR���&e����ܮ��-x�c@���X���c@���:���qS@�8Hz4�l��=�����ʆ��̐�%#�`N����Gmy�B̆�d�$�Zm���ڧ<�Խ�;:!a�ʺ͓l�̷���4��%|�8�s�Z��<�MJ�Jm���Q0�j�O�z��H���"�V�އ���
���"khx�+e$`�p7����b]����z�`�JT�\����P0����þ�֑<˕���'2d�����!�    0�a(a^anp+�6�8qE��vB��:	F�뇩������8�f���Bf5���P��3vI]��EdKB�z��i� ��W�s��:w�(�x��:��Ѳ�Fg���q�x����wۑr.���X�H�m`�ǃ��O���ᏽ���/8���SC�����4
	p�Ek��9�c�1#DZ����D�h���������:��daφFgߜ�3���W+�)�`��Ǐ/�z�.��bM�U����#�q��FBpj�ȚFg=�~�$��z|-�����\]2O�*"�`�&I��nc�(2,fq��}i;8jh:��!w��{�,#�fs���	�@�[q�H+��︹.%r{o��vI��Y����nhQ�<N��3_���[C�Y��+�C�H���]�0'Z/Y�*���0�,����Y`VK��b�Zn���O<8'R&iꑖf2�\0��̇\UZP45{q�v�����S������D�v��hz�[��`�-��
������5��Ar��t��Ek��>���QU�T��]�5i�tց-�s*l����ٍ9�	}��S���R>/1�_�;�7(��ǂ���
 F,�ݪA�Nz�D=�6l��31��z�M ��k�u�b:e��j���e�[�B�e�WhC܉���Ȕ�D���ƨ��e[�<*ɀK	���4:��ވ8#�S>���W���e�14���"����8��X!{�������8�EU54:��YB`��#���݂E,
8J�w��/��MsA�m�jV\H��cT��@b�^��*!��&x�jT�n�\�$���:����D��
����,�$���}w�8��
����)�\�qP}6���H�щ����RS�V�;���itS�
��ݬ����|/_�G[^������N�┘C����m�zZ�Y�&���K%9)�c��鍇20����rk��B�z�dP�+N��]�DL�-LƧٯ��ojt�)�b˷�i��}�D�l��sDD�aI���Ђe
�`��͚����o`��,�=ǚ�?(�`q�g�s���B/��Q��.�i0K	ˍb0��~��Y��v���t
�]�/�Ҁ�Ѕ�'�L��ӷ�� �.=���Y�,�=MW�P!'!���M��y�c�;w�b�>���m?OSG�(s`���E`���]_;bA�֔���TP�J"�A_�6���f��x]�ز68m�xAplЪ��4�4������$?��+YQY̔���?
B�T���b�GS�}$<f��-# 6�I��t-An�������q������/�N��?��-�NC��{�ä`��=�)�=,��2��	~H�Q0�!5R �һ�N����?�� ��3k�yM��{�	x�N�~��|F���:VR{Q�B�R�(`��Z@�6��N���"A,��д��s�����a�J�U�9L��F��
=,�F+9m�iS���eY��e#64]q	�5�sE��?u5����A�Cem#��R��r��P馿��%���ua/Y�����/�SD��y ��l����ϖ���z��(��iT4U����M���M��8�	�m1���C�b���G�1�����]b#Fy%��ZR�*R���0�L�SO��~6�>���44��p8�rs�KvϺp�̓�W:��k�Ъ.�b��r�Mh�"S*��P�t�N�]��	[�������C�S��cS�z'Zm�)A<�J��UM2L ��,�������L1Al}C�}7�#0s��l]���,��P���n!5��8���O���R�t�a����V�A�!ϝ�f�����ۥ��
(�Œ�m�Je���Ô7�(����rI��z�5�ɉ:��췽���S������ݧ��ؤ�ʬjm�x�tj�V˘�h�S]&T�����\g��%�E�k��C�=�Bo&�5"k����
�ԛ)V�	du������#� ���t&� ִ���	�QN�����ܼ�|lW���d�B��8��gl�	N&�x�T�T�FݫËno�U�Xb�@׃�� `���#|�Ҭ��d:�B�ʬ�)<Ʃ�����;H@��w���^'�lQ���P������-��e��X?�������PS[���\�� �����J�7\�xS>���Ae�O����1*�]P�S������ ����u�C��h��fL�x��5�K� *V7o��nW>��+�k��	��â�${\��4�ӥ�]�]�~	���&3����U���pڢ"N�e�B��5�ͨ���2 ?�Q����x���c%7���ot�C�3�\8݌3�����_�	�q�6�����r��E(��y	��Z����?��f���X��vP�7
	&<L�}���-���*벐2�qkM�'׃��s��6/_��}r��d�j3E�8U��TmD�\P�s= ���'h�K�t��y/���fc��Q���ꗷt��L��4����1��<�v�O~���,�`z�젚�9�2#��(�^�;�ߙ��*˞���&�]/Z���$��-���Z�w��� 7f8�2F��t�i���I�S���ߑ`P�/�=fԍ�5%�z:��UK�����#�*��βLJ,=o��1�>|x4�o��f��	�y���/�m���<�X��䦢�if
��"t5PX]���$է	���>偰XF��2�=�GTPۓ���r΅�Lʠ�X?����'`����I� �Ԟ:,Ew�m�����`�il����9��f�؁{�
�l���`�f��D;���E�����u���svmO;}�h������~����@�i:>%���C�<�� ��g��р����;Ϩt��Yݼl�{66d����PH[�GMc�b~(���}|-:��E�"������^�͎����9��ػ>	l>mMӋȰ	D7pQY�����YH[���}����Y��u�L��� *,xV����oh��i(P��w���2������
d������s�I��#ު����4� -
�n�A/si��д�ۗ	�l��
)g�a��H+1��#wT~[�1�[�`/ǽ"��h�X��m �Sn��MϷ��"5����fTL�$>�F�쓶=��ut�����1̛�^'��#C?���3���b�i{<ܨ nm��v����.���3+|:GW�u7����jWk���!��b7��o�;0}�-'9ms�Q6د�m�W�:��>��߂�P���[�_1N'��&Ce�R]�����C�Ehu��H����76�4
�/+���.��'�����^ �!6�"�<+��W��f:�gÀQi;��i:ډ�RF43��JW��Yq	�4+(��@4� p��A՞A�Ѓ��~�^/҈P��oh����0	��//�-C(�1�`���}&`��qB�������Kj2�n���״*X,��e �s�]~�����"����o�\S<�S���P�GUڟv�ث~r�(Mr<�����;<J0�-��謯��/����j�W����
����$4[c��@�#A�yW�`�Q]�N:�+�ø{��2�j=�i�sBH~\Ȍ�V��������Y��f5��8�R�쩵��3*m�`;���UmC�[O8lK����^��>u�+t}zB���)z���}���G]��,�S��>�b�54U*v|���p�V�:���yx!���\S��S�&���]9��3H��8�͊�X[�7��6d`��S~�C7:����J�[�n�m
�qv��ҽ��g`���oỶ�l)5M'��-0q�e�\�5ۼPBN����3q淞�)��	���>oRV�J-��<S�$�4�=>����z��]����@Fx��6H�^`*�1lL���&S�}���=G;Y?���Y�f2&tI	�OcĊs�ɶ�iJ�q����j��fĈ�������H���hhU#�P
p<Ŋ���a��ě�x���~̍���&0��ô��� ��2��v䐁0��;�t|�,�6c=/-��e�-�N�)�ǩ:��s��o�d��t�	<-� e  }�J���9�VNF{s��|Lvlo=�N`���W�5��;�E��4Ti���4����ݲ�	�g�`v�	��ˌ��)Wqz��a�O�`���B�7�T�8퀠�|k�CM�W��`�����z���3 ���O�uQS�����-��,1#��a�%���S����D�Ol_��q	?���׆V��ށ"N�SS���]�J����.&,)P!���b�HEͲ\H���GM��*���
�cg�Xz�ni7
F�7#l;��*���7\ ��
�Eg�C��G�k¾�#	���Վai���I�C�,��Ph�3���D�d:PE�W����܍�t��53�C�A����x)��jO�T�|�"^�z�5Eg8ec�Q0��Y�OA���`��)��u�iڰ��#�;Oo�+�:�S����f$Q��,5%f8��W�׌�Ǔ0Dr�*Q����pf3j�NgЦ��$���Ӳ�$7�ƈ����V$5�f8��7��s?����<�MQ��.�i�ߺ��2�.aM��D��C��#����,Aq�-?Nڛ79��i�*���'�V��.��q����p
��@�J�û����(�b	0l�{5M'�g�C�}O�6�Fb����F�醁�>�L�C<c8z��8K�����ܩ�����.��XH�{]�?)!������B��x{�o�C�4�o��' ���z�Z�qr�\�n��h�?yI���!�Vt����K�Ntz����,�M�)�Q��5�/pj�|"N���~5݂	��i��4(��꒪:��G��IL�0���8���D(�E�M��i
�#?d�Xx�
[%�����p�
��d`��Cu�KO/ĳoِ҈�X��w�2Ě��wǖ�[��|Ǵ���+{���˅����ɠ�#�*�o�d�S���M�����R�ػ�݆�^�F�jW�i7�s�`����U�>�N��ƄvD�5O�����9�I���4�ڱS�8'�����UHI�'iAX�TdC_0k�dM�w�c�[�,_��;����|�;��?M��2�,�D��r�w< �y�N=:ӄKF��=����h�t��[cB��nՠɖ�橲�[ą��������Sx��� �չ�h;\l�9�T퓑�ǰ5&�͕���ʆ\F�d�n� �?���[ �rRb�`Ċ��W�'��z��>��Q8'���ł�vhhXR��!x.������~u�E�n�K8Jv�N45�8�i�h�qgNn� ���$�FLJk�^M�7�QDA	���7 s�Z�"8o(	����1Vo�nqz�h�؝�\;�{���@��hb8t]n��ϟ(?I�o`F�(h��5J&T�Tu���k:�=+D���U�ZN� :�_�iŌ�~�{�T@�����c��4�ݰ������U4*t�`�_������qƩ�݃�0L�鍧���{�6I�jD4�K��lp����`�aD1'������L��U%���8�h��~��L�a���h�d�Z;��VT��	�#RX0�4Ш�3�8���>hZsDu��,:-)4���D���C�jAS����jY�j�qs�6ʔ���k�P���5XVq���$�~�	��"Q�L�/N�均:� �&�N����+�jZu>,E��9��0���Ir{�	���;0���j_�I��}�p8J���!�$���2�Alh:\l�逍Sߟ1���<Ub�k#5�;<�;�z�p!�֫�:�z�aZ�-����E x�_Tu���@ �Z�iT��,�����
-�O�c0$0ոv�a�1ǆZ�^C�/����x�sɻDX����*�f�z}ў`U�S��}��G9��/�lG/9�Ůk�^B�V1�ɘK���]~<��X�zv}+VI�~Ϛy�L����|-�:���B�֓�[���h���,���c �:�؇K��]X�Q�:G�o�옩L�i��<{o�O}0�3<T4��rw�V� <5��4wOӯyD�C.ƶ�wx��~��m���/��=�:�b�Z�T�:�iu�0������A��^\Ӵ��V��_<P٘�XM�
��+�i���W��� ��)�h*��n:ʦ0��� �}eKo�iz���o�E��LG���{���?�?�R�      �      x��\[s��r~���an��m(�$D`��n����Y��J[��J�}�{@{�>�$U[^I+�7���Tjr��T2����/�O������쟿�M�8���d$�4ʦ"����&JC�e��M�|���ԯ�O2�����~��ܾ~����_WA������=x�G����o_��W���������右���m ��}�?{�߿���$FDBM6��k�<�+;�
f+;���!e ���fBpt{�����o~|����!��!�UP�	&�ڦ�[[���u��hGN:�O������vU}^�qj{J������(���!�����U���.������mۚ�<@�?a�R=Ft� }���=(_}\���-�>���>ۏo�{�;�XP������#�Cd�=��1��HN��z��������|��@dO��������Ғ�N	[��a'7&�,�3�V?�����GQ���C�q'L#B�?Fy|x���r����$��&e~ 5���5ALb� �/&>'������'���p����4�*l��ϵQ���Zq �0&�@c�ݴ�ܒ�-J`1P��X,'PT���	�@�{@b���6�;`����*9&@�@סNY("��Bm���3��`X"
���;%j�#?��'�E��x��}���31��I�7b1�V��\��n�-$/���	���v�O�Im��e��UF7�f��X$���l��	�
�(��U�^5�-��T�E��j�G�0X绝��<����U ���i���5�^�O�c�ޤ�:�9������� �8��e����}=UH�B"
��Ȉnb�_^�Ipg��/Nn������^b�_ZG�2/�>�˅3\X��KF��#�I��7-��`e�*-$0"w��I��WFoy�rY`�,��2b�8�0<\u��F�H4���B��n�#}`U��&*H���f�f�7E��YȈ1�.X6`0t�.VٍRa�+�F'�o��c�eތ�/Q?��I�8�$�Ɖ��.Q;\�#�R��t̮LZ��h��&��!�pk�Zr�VD�uɈ�yuC�7*��TN�M����xS�o��M�n�"q����wQ����RWAܙ�bgw��o����"��J�rݍ�S�PjR���-�|v޸�^Q�p���e���L>_W�܌���N1ǘ���&�����CD�.����&^@a&5u6-lBf�]\����D�������w`��I��DC������V����7������8����m�}>��.4�`��#eC2�yw�5P�CC�|��pqu��0N94�d"�Dm,��T��Z*<��I��`���G���E������Uk�G��h�ތ�1��cjv�����+8��	Eʑ�!.~�ߗ��]Bazԉ���W���iq-F�,����/
\�@�Ec�$�W x=�+$h�26�7������w�K w���7�Fm7[�$���;v��p�j[t/�� �6p��*����W�3�Md�D-R��A���(�T����ri�k�^f87!&2�~�u�d2k��+�F}�i"T�8a��hE��%��|e7���[W�G�#���D�o�+|\P�%"�~"�*oT���k�x��x���r!l"!!��~����qU�'@I���{W%΋S�<K��W:�k�yz�?�
cx.��$]�:��4��l1���f[,�� ���EUը����m���z�_lb^��F�E��T��{��U�[Q44X�
`�j��̍m�S�߂�m������
	��;�wɒu{����8	�-�XzXeFPȢ�egN��6�k��1`�RN1��Gd���DI��)\E4�ґ��Ifm]/�f��iN.���Ʈ��`e�� +x�Q<�1]��b�2PlY���H�����]��m^��M���H�!�s�Gr	�p�a6�q��($�8��.K&d��E�y�0�IB�����|�H>f���pї+c�)�	�2�_:�O�G��0�D�d�ұ���ʠ�q(�B���x��}������y�Ci���L���M�7,e�!�_�/U��፯�i������|���_Hx;�|Ymm1�L ��cpw�׏o��7k�������,���8LY��f� ')�H��ܮ`���r��%�����~��SL����BS��LY~��0�c����bs����5���T3:�CwSS^��1�z8B����0@�pRR��|��ڔ0K�	�
�"���''�Z9��]�WW�k��2��	A|�fc����KWG�=��A,���� 
�zQ�ؼ�DY�2Ǆ�I�!��:z�S��k���jQ�Ţ�á�U�(o!~(���:\i�F�R���_��`
�^����@dit���sK�.��f�~�n�$·;�Y�0�i�x*�c����@y�/��uğ��*Sc�]PA}�k��K��(7�c�y%�T�Ǆ�D[��r��A(4����BSe��F&:�)x�u,�O��\��[�+ ��W�������`#��)0l�c��q��g`čR;z��ۺ����M8U��&$qW6�]=���y�;�Q��U��t!�òQ�$,��19���H\��\fo����@3|b/V�=A��]~o��b��|D�c��8d#��0K3j[�Ք��(�/��G�\�.����4�N͉��1����L��;TH ~�#߂��z�ҥ���9)����R�X�����GD���
�Ք-È=��!q��s�� ���gl�p�#�Ɉ�/����ˀ%�*���؏�.�r`#t������U���17l-U���s/P2ن������u��'�#Ǥ�%0FFz����E�����"���
>�qQ����_%�b���W����y�ន�3��1B?X q��l�6X��~�@�\�69�����~\�r;�+W"�g�6vS���U%���{,�f1��|�(�vS��$��(� �ȭ�ʝB������)Ò�v�"FH���e�#��j;��ɖᖇ��P�T'��͈�AG�j��3�i7�����;�|�\;��4s�(�,i���S�9�jG/b�^̤[7h��塕�v���pVbV�]�Z��0�G+�L#�;,6O�^�ʲ�#CUЦ+�̪�ƪ����E��^������]G��aS�B;�#�c�ހE�)��4R$��,�#�A�����}�f�5:��Ok��� ݶMco�g(�b��*��ʠ�Ӄ��n�x���l�����6����s�Cd�ϒ�����-�
��fP���J4�]f"���1jO1b�p/K��|�Y�Ʈ��c�bdn�.���]Ơ0tڊ������48g�1)���$����P��H�%Ц#���.1(�{�����a:����ZБ�.��0���k{�PTӦ-�.��CWX�?�c�AAʾ|�x����TW%!�WX�-�m/y�vS
h2��c0/q���-AiQ���]ar�²% <��	u������o@�!�+�&��7\���nN ١�ք��u]�Z�$���v��R�0s��k�ز��WvCL᠃!6����z���@a]���5�J�\-n	@{ �"�"�9��e�6u���Z*��?��fڐ�(�����|1������X�f��Q�n�{%P#�rj�A1(����mw
�
��*���֋��K����s+V�@yg�H0Ӡ�P�M��uX��Ro���6�6��¿�⬮����s�W�Wm=��E��a���
�W!��.�C�l�O��p�07���fݸ�S�۹���m�eoW_���}�]8����[U9�doS��.\+��!��NDFr�v�r�6�"E%8ƕkB�;6a7�9j�Mu�bP��s�6�1XI?��Gq�k
�9�<�a�~��D>���]�o�u��6^�R�"���4%7�I0kw(���\r� ��ބ�r��PY��e��Y��L =�%�`dZ]s�AkT\| �  
���zώ	ΐW]��Z����H��H�5�T��ة�n����0ڹ)��2r�؞m�WĠ��ۘ���%�F�T#iXZ�� Vv�]�����K���B/\�F;�}��*.p��.;�سc�'v������Ǉ�'2��5���p�jl	Y��1ɀ	#vtB$][n<r����U�w�8���-�Mð=�8R�2�h�.�(e��������G{�ɋ�p^'L������/3����Gڠ��QU�o�J&�7hyL���;o���PA&�<b�iVA�uڟ��	C�����Oo�=�;�m�kKv��)�QI�vV�ғ�4[��8o�SL�!a�5�G�<8n����$[lH>D� �5A�Y�q��b0��;��4y�i9�����<����������Y��S�]��j�l��všt���3�*ܬ�����ԅ
Α�����Əj(I�yo���� `���=��.�n�Ϋ氄�������I����p����`�}%۸.ܨ�����
4�Sh(�Lh¶q
7o(.�@��hq�M7�Ȭ�ss:�<��b��x��xU2������0��I�*��'�!���b��}O�֞+S�ܜ���kv?'�S��n���C�`���&C�&4��vc�b0�wBR4�9�K����.�D�����h�^�"�d���i���0sS4I���a��G�w{�������W6v�b8�w����f��os[��`���H��B�Tp��:�i��Q��'��x���"(ca� [��"���KU�_��W7�ǇY�z8n�P$��8�	ן/[���ƽ�y��VR����*7o(���05/�OM��v[��S�������_}�a�4����d$QLw ozw� ���'��;�740j>7�&E2Rx2� �a��
���)I��`���v�c��Z��� �ؿ����Si�&�/0%�<�˨��i�Ɗ�f�Z��ϋ\����&_v����È��S|�p���_�G��c/�;Z[V�soY!��@`0d�#���W��E��I1�����\@ W�W�&��k4Î�����Ϗ�������(�A�����y9�Id��h�>&}d�`��)%��!O�����w�XP/Π�:�AW�O+�>h1�W.���w��g����������_��/�E�A��i�3ؾ�6SH�-M����O��D�:5��[l*E�D�Ŝ��Ω���^��)�et���H�:�Š�y��]w��-�i�"y-�c/b�SR�6�̷��t�&7�U�p���-o]����}�;y�T��l����}�fj")zI)�pl�(�S�[�]>�ݎ����@I��-�a޽��hrB9o��U�1���y�a���� +�����X�ھE:L��#�3���~b�]�q�6��_ل�MH6@���|�G7qL^+'��$���~8 �H��i����)���7��S���u��A�����'��j`Х��Ivnp�nڃ�=_-J�-��GX�l�1���:��`�j�U���rE��7w�;r���4�h�~'���E��
v����s��	fO/��8��r���ę!�^�5`��\d��!�����3��g������t �	�X.�����X/�Y�MP~���K$Mv$�u����(�>���Sk.Apt�Gq��]~E�3t���8}D���V	pX�@��k�?@�W3Hq����>M������P�2E6�D�#�+�"T��)`F�5����6�x����2f�YRv���٬�5��8�����j?R�u �V����pZ�dh���A�"`�P�=�S�l8�u�^X��*Z^��[%<�o��zB��Ԅ}
>��r���,��]��ZFC�=�G�~�W0�:�ئ�>:�l����������w蟶@m%���I׆-��b�R��n�a�(�ĕ?;�h���`�<nu�w���؋��F"�؞(�:�e4Z�RÐ� �	�P{лQ�إ�8y�5�駟��:��      y   U	  x��X�r�J}��B`��*u�t�!cd��d*/m�,\&���Y�
�S$��Ҳ��{i����̈́ϣIԋ�����r���7����v�z�|��%�"7W^�7�fa�� �D:ZpEUR:�0zM�5S	;Rt�C8Qo<���[V��k��n�y�7���͙��.�&[y��0[��s��+��F�RI΄�ҙu�1�*�ˈ3��GQ|;�m��>E;����ȻYn~����Y�L���)0"*R�B0h��������[��"�F���N��f`��(�J��(g�%���n���"9]R��l^L�D���=��YZ�����@�	�y`�C�/�¢�|Q��ᜇ�ˀ�ס
%�K�Ӎ��ôoĺ?�M�u��81�w�����?���
��v�'�`IT�C�4���)|�9x��^���?��ٿ�Ѵ��	�R*CI$�P!B�2
r}�O��(�+�����|���^-�<-KC�x��I��Ԅ��)���@�-Zկ�T7��R��h���B�jg�0�&�G�e���}썓E�l���f�N^���&7��]Q(��Dw��Cu�˪����QGƹJ	��:<�.c G�L��N�6O&[�m���2�b�'��h��y�Jj�M*��_���Y�P?��d�g��r`��8S���L�ZUN\h�塕��\N�E�&��s�}I���zZ�YUCV���$r�$�Ok����6�֋0���&8��U~����K�3̧eO9Yiy���>�����'�%۟8$��j[8V�q��~�r�}~aG�E�ߢ8��ٞ�Zq���)��.���!�W|�͑�8���_L͛Y�Ƙ5f�,)��,�P����Ҿnqk[�,�* .��4�*l>;z ��p I�i4*(t�������.A�/�fe��AO_YƇ/"g!�<9������;/-�_K��y`����x�r���q/�֍�ӧNBm{ӍAmt�e�-��f��_Z="��g�$/[&*����T��*�ֶ��k�6{/�YoЇ8������,�j�ҥԹE�����*�V�uj_�����剱 �yc��[�
����Q�H�P���.}�8/ž����|�8F��g����A4.Iyƙk2��\8�u��~�b�����I����˓��`�QPז<$=������ �2�5N���Y��>̚&�s�v��n,�/������7I�ˑ���r�Y_D�!L�s����-�13k�0fI�6��v�Ǝ՛.3dM\�sB���� }�[T�ٵ�Ķ@���&ͪ�Z�n��ҕ7��������͛m��,$�H�khf-�Q!��Ծ�C'-�^�GQA��VQsP�X�tֈ�¥ܹ��*�>Y��7yQ3w��i)ׯ z��Z�t��P�&��b�EqW��XC�K�[�Q�0N�a�+�q�(�|1e������[����z}w�(�	�v�8�&j�!��O��.��ǹ��ꋗ� BH�)�5Ff�[:#x ��^Q��<�c�Y�җ���Y��Z������w~9Х�j;T�F�x�,L�T��>�Ϫ������kC�c;lZF ����]PaZ���2g������ɴڰ=��n�Mj�y^5�д(�b���Ў[!?�F��]X��#��^����%8���jv�]8����ctS؆3�V?�o�H��X=Fo�Ќg�%�K�t�z�S& �A�\���'���*��Fi��xk# =��C|7(��kxҊ���I�O�$��> -�d���"/�z�瀈��U��"HM,rB1��B�k���yї��
)����,��s$e�����e*:{ٯ������2+Pk
�`쾋 ����l��J@���d�Ͳֲ6	����]���������@��vy������kV����Z�
�;��C�W�Y+�-8n�8�<hy�r�J�����F��xn�3�B����I�B�mZg��y)�>Y�x+$������T][݁O۽US{���Ph��I����G@��l����(z�� F� �q�⛏�1<}qeW��'O�-⻱7��:�&�!ZL|���1 eS�D�����>�V8��ýJސ�;��7�Y�X��E�b7?��!�D���G��~����o��M��� ����~Ťˤ3AUv��
~n��|��~�<��M�z��nX�;c�ʪ�J|y��?��:0[%!�`y���kmH4�F��D~��դ�.��$0v�{X�����IP�}n뽿qI�9s�ןٛ-�њD��5����������Ƽ�� �Ѓ�>��2��_Z�C�ۦ�˲��;hƨ[���K<�F�K%[V���7���1r)9��<�\q���������      x     x�5QKn� \�Syߥ"'���R��:i�1�3�`,XB/j��Ⱦr�ד0r\#�8����K#���u1�H扩O�1�y����uE[,Uy��>ΒY���A��;��@�i%�8��	q�U�F�馽��!E����)x�wd1��S�<��sed���F69Y�~!�^��uS�F޴� g�r��Ȫ�¯^�0�:���k(7(���e�ҵ�����ݱ�^F�S�%,�!�D�HZH�ƫ��kE�o�M��N�A���?����~ ��a�      �   A   x�s	3�t�K-J�,N,����r	3�tL/�W�ML���T��!B�y�%@�	�[jj
W� �
�      �      x��Yw�F�ǟ�O��{uU�|�V[�}E�d&g^�ȉ�DV���~�[� A � �e��fB�����ҍ��������@����s��zG�v��� ���B�bG��B/�X�?�Iu���ٙV�:[8����_�J�j��ઃ������Wo��ꦺ{u{����J
�t-�_U]�ҟ�w��������������j����ZzW���Z�>������U��ӑ;B=� �кV(�Sj?�_��?�V��~ߴ�;����ڻO4���}���=���O�kf�2c^��-��~��^Sӏ��� �[߫=Bl�[������Q;�33�Ytԏǆ��"��77hi�ٴ�J�)Z�N�V��i-Wˏ=��+�;SX��Xbȿ�G]K���|X���sh�cQ[)���˂T��x��ZI=ͫL�������2{?�΃Y�p�)㼟��L���������5\?�H!f��oB��#���ilzc��b|*�B��6�1�K�l[����fN�1��$ +��)�a�kڿӵ����1H�.�O16
:�H�x�Nk���L��?�o�(P��-��j�Z�𿈚6<̂����#(Q�F����m����U��3�.Qk� j8���E�EnG��yش����x�5��� _jkcj}���F�gjS������������IƦ��7ﮣ��Х=x�~����H�e�llNh�c�&FؐNG�(|
ۯ�����Z_���c���"f�e���@�����[*�/�4j?�ES���N����i��r��~�����X��q��M���o�-�դ�B���*���B£��It�ZA��>5���z+`���=:`��Q�%f�/~x�w̈́�����n�4��0^��6D"�u�R��!���{fA9i�k=XG�Lf+Y R�6�d1^�Ȯ��9g�8]�H59n���Y�������De�V&��]�B\����'�+�Qjr�jL����7�)��Fc6:"P�� L���hu@�V4!�$դ�� �
*�]��#�H�eF1���}��+]{�wW��2̟X�'7̠�^ȱu��yc�kY��F[��)��eM�c���y��_gg3Y5E_;f5��	�8M"�4�
�h�3`Q;Q�&��4�Ff� ��!�N>O�[�F��9J����ñ��!})#��2��oN_{�'`&��&�G:����U5
�f�8�|�V�-ys��B"�����۰p����� �)��ҸV�ͷ�aG��P��Pzy��l�� �MKx���n�:ڤ(���BkOQО�_�`ʬZPj��o����ۀ"Gap6'���z�ǉf<��.XY�l�Z%N�XbD�(� ?��<�e5_��p�f�����^�wp���d"���1�E��Y�R��p&�! �L�m�O��7���Ɩd��)Z��v�7�KoL�tuv����ͮ�����	PH`s	l��-7$��e��Y�7^�YI�M�2$}V8TO��Ϣ�Y������l��|O_
!Mu�w�<X��cy~�'�r����D׍�"�#n����*!����-7�:�E#
�"Pd�:k7�-�
�,����)ėg�x��V!#>^.���vy" ��C,4�Rc�B]��PD�R���-���F̈����1ŝ����0uڊ���T�Y�R�T	qO�`�vF�_^NH��i��2�|Zz�vRh=S��r4E[�����9�_�����������X(�_��G���?^O���p�T-M^��v'jD��g��/�!�a���6^;��&����9�ªE>�F��c|�F���k4��P>ifrF"��5����R�g~=�sF�>�\~�E'��g�]���zJP>?�XM�$[���Hc-�6��B�d�{_D�Z��/�6�9n�V6���T4�:%]zq@)eN����Y*iN���>�M��+�i�	@4jh �#'�ίo_�s�#�		�U�P#�l�� �z*�ƫyp\Ȇ�rk8Ek��Z�T��ِ��gﰓ$4�)��*�U'���6��H�}��G��I�Hi'6v��R��q��ȗ�c��4��tf��j:�S�{���R��>S	B�=u BIr�G�:�韫K�Nŭ����tu�镈���&M�$��)�%1X�Z�%�XhXhY{��%��#IL^fb��G���}2����mḯt(Ф�������}��!��g�WGK�/&
�vA���o�V�Gt��/Bqr�^S�A�Q}g�+NhCK�I!LY�h�t�+��始&X�hW�|���?��}����۷og�j�T{w�?D�yPm���SGmA�D��Ym�I�����8��G����*4MΓ�"�;o�����W|��멠�Մ��ˢ��	zk��㲚�B�I��؂WԒ,T�������|?K�͏1=O��$�1Jk�2d��{ǋ�Q_�-��qn>ޢGE�*�ޛ�	�W�����)U�`���yc~��)x�a_�]�{=zD"w�΅#�j��Ͳ��
�x�Ă&c�	I�x��O��Cu$�ȃ�S����V�V�tv��D�[8�kF$P�,�b(jA�H7���D�Ƒ�̒�����������	��Y����Gx��];��V&Wn��CgR�)N�='�'�e�0��lU\�W������s�As8'���-�<B�0F-��%	=
<b�3S>�c{~�48�nI�hñ��� ���%�,/��
M��W�X%�P��a��1o-RH�+����)$�y��1��ؤ&�66���y�r�߮���c;-�O���E���Y=cht��J��!��[ɘ���4i>���Ͽ�.�q&�U{�j�	�PL�w�C���m��NN�L~zM�[ �eS��!�-&7yՂ��(lu�����,�+,7P�x\,�=7������Ą�zfe�;�h�)��lp��c1�+pT"�����?�@`�BcW�������KRo��Tk�>�r�����0x��q_Sk�A�Fn� ���4�Vl"Rlbf�N$��6���#�E�|��"br���7'b�/RU�\́Q�Q����Pde*jc���>��b��޷p�W:���NM����`u޶	�؄���T�Pj���Q�[;<�W�S(����;�V+Cv\�ߣ����͖%ny4�O}�87<k�4ɍ����P;�;^�ʰ���Fc�(D��^#Fz���j����,�T^zL�3���\�K80�XI[�_�/����MDH�K`�*:��I�f�H�v����"���Z��w���q��I�NAӷ�9]zO�l$�Lu�����,h��[8n+E�e�7��OS�O-4�r�;���4t}��t}�_�r���D3UR$qy�I�>b)�������Op�Zrev_�Y��K�E�#ч�؀ѳ6.��Ȋ��ӑK ޶p�W�|Ƃ�����#�@���-����P�^\���`w�b�9L����ET)FR�d����0�x�Ƅ�?�7$�?��nǉ�~��59��c��*�*h�*���$7�����V�a�ꐉ������e`�Ź�h�e�y��;3�к1�|~ӉJ��E�~-w����Лǡ]]ƫ��t��&�R��T3��iRBi/Ӱ���-��B2)��^f)W�́2��}������-TS��[�,O�.��帟bэ��넖4ls�̗Ԅs����L-�c���W�Z43@��(�4�O�_����Oa�&r�5��$;��5[N��4Ѩڂ�.e�R��j��� �\��ί��U���?�9��ʚF]s��E��<�/�t�K����{�`�E���t��y�1lG��V�
��% �+�EkǗ`���\_�%]�=�e��k �0s�`̕��k��^��0p��P&"�;����5@�k FD���d�l�k{��;�k���l��V���fǝTo�M����Y:.h$1s�)o�\��L�wChj�TƬx�(�Z(�v��\W6�F�me����rZ ��^)�;F��oN���v��|�dc�H��ӎ����Qޝh�&+�^�w��y��l466��1�3�	o8�zv��� .  �!ǵ�x��[�r��<�1���Q�ΈAG[ځ����/>��Am����v0�]M�4S�!�FВ�����ҡ�Q��en/c^n
CѺ������}��OG�C���i�4���Fގ�NU�T)i�|���wż�X�ݷz^��tH��/��Ҁ��7�!�:==x��*�	�&� ��&�ȁ��(H��;~:�����	�9��tEй.�߭[� c�9���O��K�Q	��}�d�4$�jϼM�|��� tT6�j"�=F�C��zI�Jr�K�+�t�X\� �%�m�(����MO� �&�M�H�%7����D�����ǜ��S*�pNR�9RFk����9R�SY�,h��)VU#�!Kz��PK�hr�:@i�NT6����>A�y�U\m�e�/ζ4��G�ʁX��3��i�7�ºK�:�H�����lD��D0�@7�*b&h0��	�87��s+#?�cdH�9[���W�|,a��
J�=�1�L�H��uP�0!��_�S}J�W�֖�����	�	8(�1�>�u���"�@�P���k�<_�6��r=�Q���c�V�a3(L�C;T�r٪�x	����ۛR)���Z5zH�@pKHK��h$C�ɼJ%+QR:��jS�́���M�6%�����h�%�$)���m�[�B�!IF�yvO�E<�"���q;� �������M)�,��vmz�r��h���0\ˡH�i��3
p���	���{m�ٸH�jD�5;Kr��e~�c��������ｾyWN�k��&-���x��~�o�$�O��A$CYp�ei�KfIjٔ�b�q�פ�����8O�T�o��O<D%+k��n�s�P�|9s���-�H�\��l)]�1�o��J;d~(������u���o��&�"�N���[��XL���l5�����)�[��1W,�k�лc��@�k?`�:8֢17r�|�<4��H�Y[]��y3����R�\� v���'�=X6̹��������{o�U1s?��3s�?=�zk�:]�c��)�8�>�kP�C���L�Y�����
���@ZHI���T�is <�M�N�`�w�+��s��	V����M$ٜ�^߾+t��#�/k�g8�V��th�y7o
٤�@���xN�����}^~�� ��!�ID����IY*�����A�SP��$wE���r]�[�f~�!��ʬ�L��t�e�2�e��V���J3v�U5��N�����mR�p�x�`��rN���k7�G�!��K���6�r�E�гH3n����П[[n�j�^!�]�Q�����_(���-C@b �&�-�0�E�\n�d��a>.��B6~�4| pEb�t�-��6l��0�붜�Ի�*È'�e��W�";����]L��M�͇�ez��@_)���r2�Pj�p�;C��d�́2��H���f%��Ӟ���pi�/���QH���W��GGs���9��q5�*[?�ZW]��L�	;�sME:#�sT
��<�������L�}s|3��5�d�_w��f@pf���L��;v	�7Ǿ�jiH�;lϴ��!��~�g�]O���Ex_�޾�ڀ}[!�.�G�2��SL2��A��Y5�̷�v�=�j%$v]��펒ʌ�X������i-wO�'���mUo�(�k�osO?}u���쉓����b4��΃��		:U{��>ujn�@G#y�.Ύ��o0�]
 NXm��W�Fleu���,;������x\�&e�`�;hQ[�՚݁a��S��x�;�.Gq��Q3��g9��,���Rh*�����>aǩen�lq��k7z[�&��@�����0�/N�{2���8��A�����8�HJ8�E'�L�����˚��m雛��I�NY��݁��2צt��Z-y)S^-����.��qK�S��v���x�I�ZX�}wݓ�绉&0Y���T�'&����2#&x#�\+x%�)��LY��[�τ
�$w�N���}<=_��v�v{��}��"�YAl}���恬&�כ'=O�<q��:݁�ŞX)�� &<�AP-�9U�í�C^67���;/9���K�x:bw�pcl$�CF�w{�{y-@re�=����A5м�o�_�o�t
�����]ip�UT8S���q�^��^R��$�gOv�מ8�uc�$��'^?Is���$����j��"�猒d@z+�>����i���-4ލ�8�l)~�pq}���bk���BW�����}�q��Ϙ��7��G���.B��"��������HS�ߺ�3�Κz�B���P�]�̡��_��oBgc(hw�'�P�(�����&��%��"��<+�����[Ą�j��l��ׇ�>Oַ�{��ó}��0���O!����ty+2F���3n����:�:�}қ�|�]J��o4ב�$�kqnxInq&�0Vr�R�Z9�)$t��3r��u��'�d�i(�sk��8a�4��M_��ȓ�=<a�6�?E�����SS�k,�_�Eˉc��)0"|�v��#�rk�6�y�����޻'�|�UR���|1,���f��@�+gI-lR?�����h:������ں��7��7�håk�3�xV�JC&� �RV���H�ں	Ȏ;7IK~_�m���5gH3:ߞt0{���<�̼�v��Wϗg%�����֜X�&����9�����(Rn���Y���Ms���m(,k����0wD�2QT���LD3C���S94���u(�q0'tKqp{�i3�w�_'�29�3��{�o;B_�o��Y^�Bc�b���r�61�o�4u߄A���,C�4�d*E�s��H��VOǫ�@g���|�kOo���=zH%��� ���������D��F���E"��6O6���w��/_���M�w�������C��_eYz�m^��0-�K���+��_��}h�-�sz5Y���D�^������i�*����>�w�~��T�x�'�c1��*^?Pb����B:���1Ly|C��cYƵ���Dg�s,��ca���9���؂��~��(��]۴�g~ �zk�7|��J�^E�$��S�R����J���s����E���s�����n':��>_l���0�P�k�9��Z�z&�=��/6Y;��?���+�2W��������뿮���f��}��W���a3ME��?�0�U�x ��@�wE�Q㽨um"�zmm����<U�p/��������m����u�����蟂Q�C�lo�6�(N��z���\X��J�����4��h��3�B�\�^�#�f�]M�S�:$�����ۿ�'O��?e�%      }      x��}�v����5�S�Mβ�Dpͨҝ&G�-Y-�vr�K���T�Tl�ߡ߰���� @ D���,UV�jo|�yO������q������I�����{��g-O��)��4<mb�0�xBi�	E15�x2��h����9�_��l>��{��v�1�{7M���tֻ������hx�}z�ш\e���#�5|9"sefh��ȭ�S����c�0����䉠��?��y;�·��߃i�l|;���m6��K%�h2yL��������|pK^��}{��u���=o��x6�?�ȫ��w��?�G��a|��}f�����}_C0�(��w�x�a��]g�����D�^�aHR��Ӥ�!&����ĴJ�,�@��,����"�ǟ�?�Ƴ��|x3��z/�Gz�������c��O�_��f�p��D�??_��!%L�s�/m"x����`�K}�f�P0S��e辊��p����\f���-y?�MH�(�γr��v:��M��DQ��w�D�}	�2��!y�b�%8�>������#9�:���p0�$.��#�#|������dF8�pr��|P�/t"lE��� �H|��iv3�L{'gG�'W������(��kO�T�\�UOH�dbL���İ<�Bi˞����'�<������gR�,��5̯E�u�X���|8��c,� T%)^3���Z�D#5�;��`Y"u����l���8��B��v��}�f[�t垴�j�h���JM�8�`���C�g\o���:�h�Pf�-&J%J����ч��~��������9:=8�<�pA��Ԕ���1�v��D�"�eI*�T1ō�Jy�u�X��V+�$�W _A���39������qOP��b"�����=E��WP&U�Y�����<�<�N����8��B��v)�� �Q�����������ɇ��]6���E6�N������V�(����:a��g�,a6O%Z���h��#+��j�ه/���K(��uO�̈]X�6T��$�`YBe�Z*a��N�ۮ��
e���b�0iu"E'�eXI93�[@����SI�[Zۋ��8��B��V���X@�+C����<sۿQ��Φ?�;O�60�m�����Q��:ӣN8+2X�-O�fvK\�vG4V(���t��}n�V��F��'RQC��{��Q0M�A�q{�<�e	M�4��G��]p+ڮ�(�Pf�-n�$Ʈ�����d���9wN^�����o�`��3ቆ��l
��"�e	|�<�M��4^�]���l��v�p(��X��}r���	�4W~�e*U�<�e8�橕T��n*u�+-�m���k�֜�k��+��Y%�g��z�c��:8.'��9��H9|ΰ�r�¾��"�enF
�RVK������ ���L�(��!"E�u|�X���*aߕr��m�q�R���#�n:b�m�T1Τ[tdj��� �bg�3J(�:)Z���
efV	���<V!���ׯ~�܍��`0��Y�C^]�&�G��5��a2���[2����X��28��i
>�0u�:*,8�bW�30��l���*�X�G^���*aW��^�X���	���Q�\�B>��h��-`��ǟ��2�j�S�9�?4)8H:fy
_*�A�g�)o8�J-��Ac�23��}�ɩ<V6�F
�^���q�(�{Q<LR��,���ͅ�``q�������.yF3�U�^Rj��+��Y%�;SN��
\�a�����n�>~�yux7��a�y��S6f��k��X��lS��<�e8�fN�wn�7֚0%�vEfC����:>�\���*�8���PmNq|pI�6�v0x�|Ʌ�8�mJ�^���,yP�����������XBz�8��*h"&4�%i���Yd��[�!�Sf��*2�r�9�.�{�q:�}���Y;��A��ٮ �Y�J�48�,,c�Ձ���1	Ce^��`t�4&�X��IK��92�����k6���8+�rF��-��gro�޿=v�u�L�}���#P���X���U��F��#�<�w�����y�@-Y�P�-�灷ʻ~�݈�!�Zs,�� �>'$cEO��s��}'�Jk<a	��X]dh��h�����[p������b�p�XF�|�X8V�r��9����z������H���Ȋ���5L��9|Acˊ�%L婆]����u�vG4V(���
?܉��>l5㱣'�y�Q6��7��.�����|�L��
���i:���5�զ��bQ^��ǎ�@0vp򣉄��_k$���Ƀ���{�~��:�r��vC^��N�=��/��S
��ò�<��Н�����Sg����/%����\E�m cl1�e��)�ҝX�vGk�ju���fq$��;��4�q�����C���!N���&�\�zL�!�l���X�G�<�)cn9d�RX!��Y%��]LY
b-��?��*y�����2Q_)�\p�8�P�x�����f���N�0C�FKw�b�Wl1�`��М��k���4&P��l}M����h��+��Y%�5�z�c��z4�ԍ&Μ� �Te^�2X�֧�ɭ�|H8�$�%#��yF3����ռ�>h�Pff�p8�F��k��Fp���M��X����jֻ��BE�S&����*-2X���b���ᤣ��/gEN� d��i��*�X�G^���*�p��<.#u5�ge�s�0���wv�����?�Y�G2�D(���3�؝Z?BX��c
��B����4m�K	�ZH�٦��U��%���~��l-cu�����|rr|r�p�kV�y0��A��wٟ�!���Ӫ�J<šE���S����Cb�fnp�i����폩I��EcU�i(-q�L�Uɉ�l-���f?`�fs=?��a}e�Bԯ\CI,����p��3����� QE�~�{T�c�	ө�������N�_E����YK�O�%��d�~9�eN�9M���γ�㜜��6���`6N�d��d4���i6�I���t~q�����#���ﬅc�'΀*>m��^B�닉���j�N��Z���Kd�xt��I:o'�y���a0�-�#�4$�"r~�̛�����a~9�	�/��T~�	0�[���AH$l���YK1dɄ��iEN�6p�x��?���F��ɗR9�txL�}C�/O��H4l�,j���	���S1ƍq��d&c�¼�`��v�R��&'�H&�� j�
������{�9�|sz������d��	,5p��%����,����gsr8�Ix���ܺ?�SG�`�&�({�n����z�D���	f.�6fn��~o*�SG	�)��k���YK�O�%��d��hEN���?
�B�y7�Ͳ1�K5 ^���~M�l�Ar
}Y����)ׄz�ȟ�ˑ����*���������
����WNv�L�j�V����6�ߑ���r���L��ixF^�3<q�y�q: �����59�~����G����l4��j��U�2��sᩥ�kP�Iǭ���O��o����[YC-�
�e�0Љ<�0�����B8t:�/���dn�'�:�y�(L�
�'�)�y+��<L%�e�0Љ<4��jr�'����G=�?��w�=�N>A��jH�$�����w�BĚ��t�H���� ��YK�_t��.��ŁV�Ѫ��ο���Fݺp�������pW��J$���7j|�3��c;k)Ʒ��.�	oM8Y~�u����tr������cgTur�����װp��%�\}8�pU�埲�O�S���2]�#U
��ke0(�ENQp�OHb��F�$�s�Nc�A�,��'	�uY�g�Edl��ԕJ���|.x�'�$	�a����3I``kU��a�5Ko��;�.^��z�S &�ټ5.b��}�Γ���O�U�_+��Z�U�E�*�; T1n�3Ny@�<E���H�NQ�-Ll�E���X�y��b4V(3�J8�#����w+�7f�	�ㄵ$�    �KI㬇P��b��`Joc
+
v������2���:�h�Pf���|	&8���b~I�u<��e2;�� ����|�l݇�?�Mv%���˸�>,yܚ���*��)��G��_���9�ǐ*��F`���!���������x''[�l<�/p܄E����I{�w��Q�K�Xk�|����ۃ�+�ғ�P�/�1��
B˜�_Ha�1|[V?y�u�X��V�q���IԮ7fez
&up^$�9�g�GR&�<�c�U����uF�h��#+��j����J[C!�7521xCQ_�,K��S�yj�eޓ�]���l���Q��
&A�k�o���%�S�dEƩ�KZ��iQ���М[%��dT�c��
e~MFr_z�NE���{Qխr�g\O)������`2X��C��Z�8�� o����B��v�U��TU�.'r��'�>��	�+cp��ã�6vV,��5OS+4^�csvmph��-��c6�P�a����}��FB��o���Z2~�VD�����ɆC��.=��)��-��5ZP
ͺ��l�4V(s�UY\Vߣ�o�{�Дס��9 %`���G�pw%hU��2\p�:���Ɩ���:�h�Pf�ՠ���ĮZ���<fo����'���(��p�!�uҞ<�e�M�TKfͶ>�m�qDc�2[-2�h�(8M.#���o�4�A��'���
�j�N��J�.�(2X��n8O�e�P~�{\�u�r�&*e�aZ�G�u��X��ns Q���r<���v%{D�����P�cR��ď3X�cLS�Y5س-�`K]��~�%p9�:fi�P��̦��ҳ�4�0�{]� y��b�8��R�O�����=�y���`�D�����<�ղ�71�z��p�6������H}QAv���3Њ��[ov�o-�c��N|ɌS�	��e|���yA�t��M�J b;k)�S��"_hEN�޺���u��ܻ��ON�3���BK'�����%�">í�Ĥi�ꯡN�g�I�e�N�_��x rP�������|:�s@N�_a� {\!d?/b&zZ�U�Ny�'Z�ퟩ�n��>#�*L��PHR��k�Y��Z��dɸ�H+r�TG�Tw�����UT�F�Z����H���?m�Z� �]K'2��B!B���YK����E2q>�eNj:Ӈ��M��K� v�A��#W�����������1��?yE�+�s�9E6݃��r�	��t�����FS���d)mh;�������K$�$|a�y��hq��R�)�x0�gA�p�����o5�j�}��y6�+��.�;�Ƚ��q|[���� "�-�H�ni)��Ť��酥!�e^_�%hc���>�d��:K���Ŏ��V3�C�r�9�{2�|�}'t��f��p4>�ÿ���(��_N�a6ܶW8+7����N�Μ��_+��p�iM������S���GLa:��ݏa��9����G��I�mk_����t�aY��"f9}a��@G�����O4ۉ�K��pcj���F�Kr �ZY��:�$w��(:L=�ulz�g
���1����1���!ho
�>�]�jd	�ԝ�
���9��{�$G�#��@^N�����[��>���cr8�=�"�޼���BЋ��<4Ud`��TԌ��=$|!ؤh���C���� o�0���#"�Trv?��nF�������s��ZO��<��+N��� B��� j�9T8��]vX�2}FE�W��p$����������l4���mq'�������%�HqW����Ȏ:@�� LGX�0�0���x�_u�^����U�����㯯������F��;/�2���R�/�2y�Z����܅��e��h)���W��k���B��U®ZA��L��ו����]y��NP$G��8�����`�,C=�*�upT�������c��45#)�X���̬�0����Yq?�ؕ~���Bc^W�j��"�e��S�$��+,���J�-�CF�V٦ �-��Ac�23��=H9���*�����)ɼ�6��%��|2X�\��TQ���MK1�5EU�i�Q�S�p,�Z���
efV	��ϩ<V��:�K��D�z_�ܤ�ig�,sVO!U"�/���艷�Z�m�q�W(��Kj"�m��S��9A/.Q��n��)�`:5�S��&�b�?��t-tg�_N��Y+�9n�"n�#�kD���|E������ٻrvq}ruqp}�����������hpN�0af��	%�{K�{S��<�`^i�i*�h�9�p/�UwN��Y+�9n7�,��;ݗx)��tE`]v)�l(�J/	���,CM�<�Fl�iq�vGy�2[-�s�"y�ժ���H�'�����D1!�OP��5E�P���)nݶV�vG4V(��,/��*���QK���%�-�'Lf��p�Fe�]�����ig=wM�w<�]�3D`�=���Z���_ğs�ʧjw����IdH,�<|�T$��I�Q��RMb� �u#vs9O���
�Û�dd==������PxFz�;��8#��i���"�]����p�I�R�$Ti�U�zj&�0 �5������U��n�0q���+�/"�P�G./�_���8!�N�?@��x0�B��]ȯ�i�t�f3�yَ��Wp�DGG���*EM���񀼺���u3~��e0o�T!H��D�w�Ŝ�T�+��AĜ��b����$�0�X����N�K��w6�Dd��R�zo#ԫ�p�u4 7�.��+8b�ˀ�abu�1�,�:->Up.K�f�ۮ��
e��ntt!�8�|EEv͑X�Xj��;N�S��eE���w�-�m�qDc�2[-v�=�"�r&^PEW�P�_����xWM��3UE˼s��Z.�?�*����&��1��aXC��k���B��U®ZA��Lq������v��_��]�?��O�H�����9��3���}�|
3
z�(�*�Gc,6O�f�"���dJo�d�%Y���[C�J��*y�����2Q_)�\p���4����SX�n�
���ե�n�8�,�|��5}j�)R�wc�Y.�O���J��:�~�/�]$���I+0g+`���]\c��W�ýk@��p�*ܹ�^��?����4*|��0H�Γ��?��1���^((] ���ǆ�^��B)�"w�}�ub��E�4"��7�t#��1�����ҋ`D���@)�Q֓Z��5��L��t�
>���)b�3�'L�ׇJ�n�0`�{H�{�f�M�%LCY��"-_!�z�.�+l&�x��&[o�f�����g�̔�E��	�?Y�6�Ȕ��J-$�$�Ԑ�2�8��0��5���d�"\��!\���E��4��3��8�qZ&�v�ރ�H�6���tN��R��B��B�A+/a�Խ<�-�OF?������[Ka"D��U�gS/+S�B��"9�g�%�ԫ�@7�9[Vk���C���I���9MR����uRW���G���z}T��ׅ>j�{���<�:��9�8�hN%�����]D6�`�M�L�x�fc"~"G�=�;/hHZ���}O�42�����SD��,Iv'q9T$���RF�uV5��K,B;P5T8�x�Гڠ2*���C�.bM8u:h��'9�����eh�
S�Be�:��<�,aQ')�F�e���]��m�q�W(���&�������������I��-�9�a7/����`�s+Rͩ;�6��Q����6��vv��c��
e����|���z�N�Ľ�2��� ��oN�Q���9�6Yd���]�TR���h��#+��j����C�U���t�Ip�8�>������f|��6�Rƛ��T�$�VW1�e	�y�`ON[��p<�κ���l�4V(sܰӪ��Z��:�*<>��B��xyr@��h	�t8k�G�
�m�K�Ti*y�Y����-�I��\L��10����O��Jh,.3�L�W�)ܭ�%�2nJ�'����:��Z
�J{������v!�Ԩtc>�    F��N��=)Ҩ��
e��-*Në&�Z���ݯ�M��5�\��7�����#��p:��녘�2�'ScQ��j;�)�U@t��:fi�P���E��G�q�;'];���	�u	}&h�1ؔ�^�u��b��S��M� <�0�x�RU��U�@cq��e��RN��n�ۢ%p#V��^�o��$��{):�s7��k������2t�VI��usU03�����l�4V(sܰ[���S*�-Qhe�cw�hURJ�V����o��c���Ԧ*��Kt�m\T
�Q��g��y���>h�Pff�pؒG��e�m�Pdz����� ���_!�[���4O��E>15�yw�x���>��vC2�X��C�U�͢�J.h,^`e�����.8\�j[w�^�WrTqu��dz�Pw�̽H�'�Ƨ���J1�|I��˦Ӽ��CQAv��/�"'�P���Ub����Q��ջ����)���ex=�g?�G0����6���
O8vZ�:���Շ�t��Ҧ.O�V�P�EA�L"���y�Bo�C����{r���dɳ��c6�NdT)l�#�Ի!��Tޔ�yK��;-���n������y;k)�sFAv�L�n�eN�qz���1�}��D�;���R���V�	�`i�����(U�5�>>c��XS�8w!��8�ykq�����à���w��f{8],yQj�_����X�̪�W�)%a�w�G!���C�O�d�b+�U)��b���ܪ�
�r��5H�Ǖx��g
�|�m.��S*�^/����y�pjm�b���e$'���aӾ���W���n�a�y���VH��h���>n/�K]�rz�^.ش\�w4�vM�4�Cm���߄3��e�Gg��^P.���*��!N|�,��`ce�}x� ��/���N��=����&]����]\<�tF�ziQ����C�n:���U6�~��g��>��[b�̛���9��o���4�/����]lE�$�N��Ѯ����|^8��'7Sؕ�UTh�=bDZ��pv��{;�xc������dWJ�j����r94D$�4l���^�\�F����~� o��y6~��!�N�
���l�b!�x���w�@)��#�R��X�/�3�s���'��d��;�!^c��P�}U$�\/t�Z���pK��V�ŶY2\�=+x�:B�����&�S�C	IM9/	�fǼ�-FQ��ho�`��Y��p��xc��`$�~�ըD'Q�{&���<�m���ۛo%����9�qP��Ƶ6o9{�b<K$��Ƭ8�Ԯ[r�_����%����/�qb��J��h�����E�u�X���|,*�I�;}�VLk��ˑT����&7�>�e�Bާ���6pT���vG4V(����鲪uAQ�F�4W�9j��*5������PA��ƅ
��D86O5g|�RlS�m�qDc�2[� S�d	�+څ���x���0K�ݥ`(T��`[�aB�Ъ�zm?����,2c�4ƕZ���
efV	�j���2� �x����F�����?��W�2�|#����� 3Bx�n{��l��2g�RN��^�Ĳ�1�R/f8�����b4V(3�Jx�z��2��Ŀ\�7�ӹ�8|C���p$!�}��VbT^��^�}���b4zKta��qQ�B��n((��YK1LN�E2��Z��&��]P68�f��|�@M��4�N2�4	��`�	�V�$���ؘ(�X�!r��Jz��*�iL�i���������%��d|q�9Ye� ��ZQpn��a݇����Lw^��#���Q,:#ڢ�T�t?��G����/O{E��hS��
�*D�Wwÿ'_�N�*:�,:�Ҋ���BE�����Cp�#)دD��.�݇C8��l��h����mSt0��X�Q4 �ğa߷Q�:���ϲ�>�W	�a_����!�!��4PJ�JU�����9j�x6p'~<t7�x(hW	;��I��b�I�#���^b�CI�f�`H�s�v����`�M(�4ٹ�k=B�h]���;S/����U�/^wv�*!Y��%d$޽K,��S�7;EAs8����L���[�D�Y�5����}7��K���k�8o;�O�Q��]L��F.��c�r�fa�L�g7��@�q��)��w0o�#�o`E����q6r{PG�;'��."�L���[w�)w����#u2ņa����6�^���S�B�^�UmA�,o�ğ���/J2wnq�I:�W�0)X"��맠*y$��̰���qП��B3�/�-h��,	X��7�Kb��|������JY#�!v8��La[�%�͆�8#p�]�%yE�w j��ۏ-�PRO7�j�h�n�id��e:)J��M�8��t�μY/�����P~/葁'�X�<�n�eu�G�R�٨���@[���ý��u=�)�u�� �>�y�.��_0yH�M�c����u"�t3���T�g�|����ۃ�+���IO	�rCS��\�E˜��Z��mi�m�qDc�2[O𱨗!j*��:��3𧳫��k�>(��L�Ĉs���x�����y*�m��PԨ�i���~d
�u��X��qqCY\��A%�jئ˫��k�J�=r�S�	o�,�N+ d�M����ݵ����]���l��{��SҤ�s5��7>�Ul|���yw�<w����ڛ��$,�1��$�1aTJ�M���^����)cJ5v\��W� �%.�)�E�keRO���n�9��foP=|�����CZ
��G�^ ��(O��T�� ���(�>�L�f�����氂�"���<��I^#r�x�39�Z��QBm��AK��)�[VJ�A{f�T�ʫ�A"���r����H��.�Y����eY0�?�`P�
���F��>��I��i���"&��D���`dI����F�p�~H��Gb��Z���E2�@+r���������l:�3k�yB�~�5�^�o���6 &� �v�I�#@����Qxv�Ĕ�[��pCڬs}��(;7U�n�7�-p��.
S��J�B�����d:����W��_�*k^)P�B�:�~���"��
h��ˊ2kՄ6���L����(��H{=&w?i�޵@��Y�����,X"�N�>d$�?׫
 ��p��ĉ�/m�<x$��â�����-�bח�`�S5A�O���p�x�Ἒ���Ǔ���@紣� .���؍5�T��MxP؆�G�]t�\!���mD��✦v�R�G:ޔo̡ *����n�="���}�$�VblGz)Nខ.z��XR��/lo�ލ�@|
/f҄͘.�{!��H���ԆT`=���;Zo-�)�����P�o������-���R�~�fqGK�E? ��U�~	���y������;0��� �$2�@Z�d���͟d_H�!u)�-�g��߁<��xN�{�J\�����?����������k�p�S�qA���݁L6�"�v�p�f���q�[�a��c����x�}�|G~)�ھc���z�z������F���JI���7S&�����mS
'b��9�oL5:VE�.L����(�MZe���x�����45�9kA*S��A����tR��Od�A�H�]�;�?�pu��]~�|rE����9A' C	S��0!�|$d��y������3J���=*BA��Y+�9n¢��,.K�EP�CT���aE9u]�j���3.����䩂�l����?xK���8��B��'�XrX�1h��+aM���1J��;�2�Yv]�)sa�c��B�Z�����]�9G(���$���c��
e�uI�ܥ8���*Es� {����/)D�rR�s[VU�`:5����&�*o��#+��j�7��3��!uAd�?��k�=~�k6���òજ)m��}�`Y�Y�ZAu=hk�J4�P��k�,��1�W(sܰc���z�_F˼g6R�|�ԏ� L  �����{���`���E�,K��7��Gw��W��o^/� �[�����Q����I.�wɅ�û	�.�c�S�� ����ῇ�� ��BN������q��J���A�F��<O�yk���M�.�F�	�7���-��a�m��+}�0��fns��+}���/6�ԣ;f�e�,۾����H��e'��vp�_�[8�7�m��y$��7��J6�=���^�}��7�vG���~Q�� ������� D�+ ��^+��1J�`|��=D��O���"�L�|!Z��i����v1T�]�FS��- ����$h"�:l�g�2Y��҅X����ۼy�778Q8����T5����EH��""�.��;0(�D�����5`)����Sp뗨vڍ��6����|ϰk��&�4�O�c7
G��f�8|�n&�����E�鰥»k��K�����x�N���i{=� ��-�RD������g��0�<]�}'KR�����x>�y6ʾ��h�K�ѐ��P�M��Łsl�=�n�l��[@�&j��<<<2P��Z����'�.��}��d��gR���~vG	������7���ϩ
�-3���b�=CF6�G�Q�p}AS��M�22P�E�����cix8/d�ޠ��G��!*��@ũ7��^�K_@�2Iw�)`�w�	A�X�w�z��HĞ�6���;w�v4�G�޽�˵� �Pضs��Q@"��S6�f�?n�c��-��8�0`��f��H�٫�&��a+����x(X$�N��aFп���i�6���`:������39f{��=�)��o���q:1��,r�����1¢m�#�d_˝3���"��h�M�M&��e�����{V�Jx�Od���-��/�Ab8��v����h4�Fp!��G@���O��d�m�sz��x�L��_��{B}��0V���2z�x|R&"����"�"l�9�!�W!�^_X��w�0����>#d�6���D8�U�}��h�*���C�!F�V�ɪN�X8��*�~[�%��Ep4�j�UaC��YgLP�-�UFH[�$zů��G���EQ�bv�D��<G��%v]_^
x��UYWm��Y$���?������O���G�?���qٹ[d���R�;�O���r^Yy$�~�t�L�mʋ�g�p�U��j��E�U�	U�7�}��Ѱ�S�&�Un�;�x$�}�yֻsTU�U
u[~�H�㔃�/7��Z�f	�;8Qk��w���}�Ze������;�?g7��v�@ �T��2��s:�&@p��
��e"���`�8BG�]_�`P�*O [~�@�9���o�B�$e;9l�H��?Ϧ�7_ݛȫ��׋H������ܗX����Ļ~���}�^�\�)�˝�z�?��?��QM8�U�H����xǏ1�V��������a�a�Ů8��*"ږq�Ļ��B����| #�6�B�'�N�wg��OW�*m���g����0,�;9 �H������������v��#��_��o���S���巏Ļ~��,�fN@��`�}�àn	[6�{!�g�8oi�2&�q�Ļv���m�a�:I�vr���3z��^��e+�;�Vkt[�w�쟆s����XA<ố��H������H;�1L��1��\�=靿%�
���@$T��4�0)0fM���D��JHՔ���	�᳤��a[�Y�l�4V(s܄ET�,����"O�{Y��n���%C(/G�x �������R"�	|t!���g�,Ie�j�)�mqE�&Khw\�u��X��qC\edq�k"�V��+~�b7Քç4L+�=�c-:�3X�(��JX�dk ��8����r�u��X��qS #�k��Q�˚H͗��$�v�>��2u�g&1��`Y"�<���P�sL�~ۮ��
e���c�ma�W��-x����D:��=e���E�r>1�P�``��ZIC��N�m�qDc�2[�Rn�c�Ǎ@|��j�e3��aYK��q��I�,2X��<U�5
���p�C�~��eN��Y+�9n�pD�Op�(�y���J���?@aTU      �      x��}�rG��5�)��v���<g�N[����Zn;�cn 6�M��D]�;�Γ��̪J��P �H� ��2���|x��:�����rqV}?�]\.>��'�f��]T/+�l?�9�u��Z����W7�'�>���r��zvus"���5����K|�JM������Od-ų:<�j*�������6SU�<��ǟN���˫}A�6H����i��A��Z�&~(��n8�xN~^��.��s �̖��/W˛<Ϊ����O�������|]}�O7׋���rqwϧ�^T_�Y�����8} ��/��6�	�O��h�okbtܕ�sb�|gOz*j�����ݓ�l	^�3��(�z��ىKon��ܓn�t��$� %xΧ�����R�_�����j���j�����^U?�ݮ����[y9[��\W/f7�Dx��>�x|��˼���<�_қ��05v"�|ʝȴ��5#y�Ǹ��	��{6"�r#&m�N ���MZ��F0��g��<Ƚ�Dcb�<���Ƚ\�NN���n\u�p�dx�].%K>e�~���r"-~U>-�Yd�*2X��B�!BWp��D9�A}��c��d��R��j9q�0J OW���Q�����T��R����ù�Q`Ϋ�+���$����i�����`{{�Z�/�f�׿>�ͨ䦧Z�
�>��i������pB<�9�D�;}}9[ϳ2|S��<_��g/�M��h;PEߎ�g8��{T��d�![H>,�x�g�"Z��L���J[	1��T�C�nʮ0�e��tr֧�-�d�j�V����,l25�W��TZ�1�� D;��k�W		o{��ĹЃ������vq�8��R��`��?��v�����jq�^�W����ޝ��R���$_a�y�7�;�-�x�n�Ak��7�m�����#Tȼy�(.��{����9��!�Y����EB�����ë'���:��vR��=��6w�^,+����^Vt�]���e�d��-�?�DҠ�)Wb�������?��hջ3 �38e ڇ�D��:ǎ��B��&�U�e	��	: B֒ �a���������u�v�E��lT����P�'JH�lG;���vC5�(x�g~*Q.����*q�������7՛�����z��}�	���r>�__�n畂��N����ҋw��n&��e�R�#�������*�D�rvt�-��^UW'������#�1��XO8 �������:����g�Ȁ&U���`[�ɩ�����%>&�^=U�(S��lm�e�{I�PC^�cr�
 ������j�HҮD`Dd����D$��̲�y���J�(���q�\��TA({�	����W۰�u��S���j`%�j�i�'�����j�r�~���n=[V����6�w*Ol`i
���0�� ,�.�P&X�� WO���ڲSj"O������ĕI@NB2
�c��(̦�:
���u����zuvq�l^���u؃2x�8R����}8��`�˸��K���#C�R5�?+N@�� �Z"NT�@�-P~R�[F���}@ƍ~�'�k�A%
�i��5`0 �f�9�l,s)Ѽ�_(��D�{r�i���66$�'���N��TBp�-�f�=<$n>C;��'��|#Z�!��p@��R��0�ŋA�������^�\��#e���p����ۓ���MQ����� �@�
Gf�]u�KOWQ�*�)*��$�,W�����%�4;8X9} �)Ԕ�1J'��Mk�Q:�:�t ���5
�At>��޺g��_7N�r�
�W� ���o��S���Q(YO�df�>�^tC4BrX���6�a`��e`Cg��賫��������W�d��BY��+j�O��F��B2�D�q��#���he2+,j:`W��h�A������bu�������՜���W*��=n*�)p�G���Qj@)�Vyj�KԀtH�@]"h��~))�V�QZ���x�d��$�1�E5z��_�nJ�VQ��lHQ
=^��L� A!Pb�L���<(����U�&΢hc3���H��4�f`kA��Ŕl�A7���3v� �A�:m8��K,��DDKT�T�L;p�
-9���a��8Fz��kG�É�A�z2�>1��Q��APj$/�2�8�%A��zj�.Ա�6�����كq��&sC����8�ǂ�8?PWA��T�,B��=�'gx��>m큸���xڐ��3O�G j\�; tWb����ul.4Z�����)UC��4���Qh2�b��������]C��2[�Q��P:6���f�]+`���ho;��j�q������{��,bAƛ�>�!�:�����\ؚE(`ϛ���/�G�t�`��A��6_���?���Pܑh�˺���,�!ƍ�ۺ��zQ�=q���d�l=��[^T04j�_#F�b.�)K����H�Ո����o8 M+�4��k�NF�N��}l� AYI���1i��?&vi�����لT��?Й�zg�$�ɂ`�z
z��U�y�ht�s�8�_-��"��6s�F�Oc@����qM��:�PZ�R��l�a;%�sl�.ϻ&Ě�E���&m%�J�[8Ѧ���?���n0c�&��_-���9G�d}FѠ��<(�h͈��R��<{�t� ��Ō
1���KV�&��n<�Z�4�aFlǍ�3���w�ſ����T/1a�t���t�����
���^̗��L�`�A�p�E
���2	`���#cK��"�~�5�?�"��O�HSR�=�
W�g:����JzU���=�<[�^��X��ămÉ�plH�t5Ƥ�U�:�#"�[β��4iڍ��Cђ�nEy��1�g��
*��S�?�~0v���CNX24�Ԫ�JM�%�An��g��������ۋ�jY�M?Smr"X[�3H ^ěx�3e0
`ݨ�N�!�5&Zӗ<�v��J��s0Ţy�k�Wf��}�m0�Km�1pw�8�d'��h|�t"χ��F�����F�V�@�9����>�)���j��_���a4�c }Št�}@�皈<�@ݬ��CW7_VTD�F�����%�����+b��\R��I	vJ	Aaфd���p��)�P��èb8�.Q6`8Fqf<f溸Fծ�
��*PH]�A��K�NR$�
ˎHr��6>G̜�1�d�Di�(Pb�rv��5eh�џS��ך�B!��Mi����������j����v���k����J��B��w��#4UF%��`T�SJ?�Co�#C��)k��5y�B2���
�`�ht&`���X͘Yz�x�8��]��d?��m�X2�4'rca��kz�JL�h�Z���3`���b<�1`�&�$eϳ��Z���Nv���� 7����\�CІ�D��t���|�t��l�� ��D����+\B<�z�:�/܎@\iU��)�4�\W��� �ސF�U�	l��z����Э�K|l�b�Ϊ�3
@�c��=�i���<������v�!��I����k/���Э`t} ���7������~���p�6�R��V��&6���0�&ɏ`E�S�#oX�h8�PtvZ�"��X�T�N�^ƪ�O(����� E����r���o�����A��9���k֋R ����krw���n��}]�v��]K�U(xƥC�9�r���Iph�{٩"��F���E��ofW��g����_����]�b�g��@ŔrK)��[��9֦Ȋ��<߅��F��ˆQ,+4�PWZ^RP�
�Y�هO���J�ς�s@�u��T"����Ȓ�w��T�/k {��k��t��N�ڶ�$aw����m�I�m�|WV��&4���{�˽�4��k"���� zꠔ�Q�o��F���QH'��J�	BX��+�Qz� `��Lk�Kq�0�����WFD!d���}a"�¨�
!i���Y�V^�5E    �球��r�A��][TE	�8L�5#��^$�PY�O�ϸ��\8�_�-1
�bS�]oƳ��^�zU��љL�t�4P��,�L��F���F~�,����lf�-��	�]-Wg���2Ȕ���.���;:-0H�A&�teI>�r��Y>�n�&�
�1(�dwt��'F�D1�"�2��%e�"/"�G Y*�y	��JNy�5*���D+�)�<ʟV�.�֫eU�V���[���>��f�� 0�:��]A��+�k<�W& ��9z��pm]�$�5�#�֎����,t��W��W�t<�{�ۘ��K5o��f� �U�f��0qM�G:&+j~�C���!X"����DW�#��=gpiJ��M��԰�X���҃?&���	��_�b�Д��9�s@���cQ��",i��i/FBe�G��nA)���ta����r���M8��߁km��[��Rة�-��A��%=hfk��ϑG��imx��5		C���^K���Zo_�Q����PbXS�4)�FH~����IV\ `R��{���n��]r���y��#�)�`Y�l^��ӓ���2�0S�<!�ˮ��b1��ڏ�+�`��H�������?�׆�Y���%SH���]hr�@F婦|�b_L��80l��^�>ΒtsTF����7���R).�.���vd�b2��m7�v�7���+I����.e\�+ɬ^C�g��%�R�SjE�ϱ~Go��&Ϲ�u��]���;�h�=Z��Q���+ޒk��/��*��Y�(��
���M3��m��a���L�aY�)�*��V`��&��iP�t��SVz$�j��ڀ�����p��bW��GB���b�CP��Ǜ��w4�H����_�#�?�A���Sn�6�ö�B��nʉ����0�v����N�9P�������$�U��Xhʠ�&o�z`��a s!@M=4{k�Kt6��|����5e;�|�-7]���-fD��������+�����dh��Dm��9v��4�!�� ��	hS��~5xǁؓ��j�`]>P����LS���m�<<WvZ����*��"���ִ;:�)}��ly��w�M4BŒ/��dvO��Qr��*D5,�.�&5]p۱y����{+���ٙ��4_���W�N�X�ϒ_��G׵���P�C����=a��|1GA�k�tv��n�� 'ˈ�F� (}M��[�w�u@J��*%c����p+" �(�m�z3��q�9��|�~�9|��b9�.1�����Z#�f�yMa�\��9���UO��R]cߛ?n�o�n̝�v:6/n�D���z�:����{W��T�u���1)��x��E��@��k��Q
L$ԺOr�z�?^�>ß����4B�`c�IP}�k�E�ӡ͆;����`��N�v��w�.�v~D}�=�]�o���L���G:������|�N� ��bAo��~ �^5Fֱ@fF�8���|5T�+���)=Ӳ��� ���\ݭ�/+����Z��y5�����3
��W$e&�OP���&5��5�nw ���mT-fԞ�D�f�!e�P0���0���I�N9jo���py|Hd/�Y�]?ಫ��-��3�G"�N����>��������bB1��a���.��u7w��cH~���D9�-�1Z\Q���)2B�:�o��|	�T�&���{�iv�X��cI>Ə���Vu]]__}SU?́	�cqɓ6˴K��Fg�M�Q��d5*�\W�ݐ���:�g(?Ɔ�\J��,�j��%F�1�dŦ�`��/qO�!r.nL7^�5���0�ˠ�#ʨ�{w�Ʋ�+0.��MV�}������e*6��`~��o���r�ۺ�Î�>_/�q{	jͪ-�'�MIM�U�a�Oц�w�1V���]���x�]��66s�et(Ҹ��DA�rm�%-��4,�C��?4��8[٠7�F��C&w\����l��_�x������7�=�������Ŭ�^m���66�¶wv�{����oZ[�3�^�@!����|d��\C4��iS�����P⮛$�_�gw�׋Y�~vs��-gz�d����A�������M�����Sw�l�ɜ��镡�W�%����J=4��i�@5�frCj5�s5[��:ز���V+-x'�1����\�f�������ⅇp�n��[������W�����Eu�^�_�lu��zqv�:���f՟�� �ф�e[�,�|DF˞x�Q`��B�cbm�j�t.��0+;O]�ӻ�F��l��8X[��I�ρ=��پ^�>�^T?��W��������㥯��������Y���FN{xSv��z�C7��`Zӛ�I�DE�k�mh����ޙ5��Fa�����q"X�߁l��<8X-A}1�(Z)9�;8$)/�O�x��Q�뾘ml�Y�!B��i^��մW�5,n*/����c��A��M����D��`2{.��1A	�%�1zJ���z�m �|�Ef.��i��&%'hj���Ht�s�a�w؈A*����4��V>Fפ�HN�Ơ�4�M?-���+2�Uc@+�8��^�t�û!�5\rz��}Z��v�g6�xjm.��f3"�$!�_��O��D�qj(/�	_og� N�?�^߭��Ku�|y����n����#(t�z��h��{���ma�2Gi�����?�A���Z���8`����sl��!%�f�h���2�1}"'��+|;j�ҭ�>�=�<i�X}��-c�윕�e*�0`�bZE��wpΠS{m(6��-3�L\�4
�PѮ�%,��(�ѫWn���3�۝ž��5q)���HW�i���({�v�������̯��p�hΪ�r��<1ݦϙ�E����g��n(O��ƴ�ֱ�D��i���@� ܸ%u
��sv��G�����K��\�#|�,x	%;��q�Z<��R��A[�K:�)|yF�
�	,w�ໍ49e�G���X�j�����9�L���-�yC��F������������]�}��Q=�6��U��-��q@-P���n��+HI���a�ר��G1�Z� �b#��L��s-v7�b>_�Z�����P��&'��.�/��_R!AW[}8�6;:���D\����(��q� ���!�1174�v�9*���s61���V������O��O~b���CM�j���!T�b����*�-8i@�q������_��YE������m��`��k��2p�	ꖐ	X4NfM��N�P�Ma^כ����=���FwB_���m�x5�Ǆ����N���F�^)B�E{�9;6��+�F�����T�sD��!l܄2Fi7H�G~���a����2�)!5���<�)4�Ƹ6�*,��P�6��[�7�}�N[[�����5�,=P.���A_��=X�پ�ƢNo��G_��k�ɭ�����c����~F�W��<2��C�[��p��X,��+3�:M�&86U��$��Xn9�(�ɥ�$��:r�S�M���&��=�����@�����SK^��4��ÄV�'u16#��f튭�~X��/(��V���k��iN�|lBǭ��1ݨc}Gl��]7|�f)�8�Z���������5jz��N߽��~������7EA����*k�, 񁺕���p�*�����v�Wtc�AȘ�GQu�Ṧ�mm�V^9�����f�KR�S�RM=�D;kf/|��ޯ�K���
�����O���t�f��_2+g4-��K��Dy�B; �i�u��r���5��lDc�6e�����x$p�p��d82/�(���X���{(�rߣk�Wu�T�����y�h�mF*>����?y�~?_��>-���WU�-�՞�>��WV�L��e6*�@t�7��e��%�����Ð�2��[*3d�M&��l��Gnד�o��V�ݏbg��&�~~Q�.��H�aZ�DG�̝�hÑ�0�.��8����VO��"�Ғ�.t����=�Y�1lS��p0��lc��'0�$�D���21� �  K��N�:��J���U��U�Z�nR0�K��s�D	.jWR�FI��~��ݐ5�V`0�^�����&�w΂@
�~��Y�n�D��-6�5Ԥ�S�+i�������v	?a�*��Q�`��wl�H��|�@�oɺ�$j問We�E�(&iU��5��L��Pg�0�#�>1b��}r�I�4E`}��풻#�^]_��9T.�Ɏ��F�� r�實�� �~��8���_u��R���ͳ\��-Q�TM*ز�l�j�R�M��� ��a�qv�Z�>�.i�=��5��!�[�&rn��t4s
��
]:ah]	o4��nJ]6���fz
���xlh�lE�)��ܹהU������DaY`z1�^KQpӚ���PB+�"��D������t�:ә��w�u�G1|+����5m�,g�������Rd������%wc'���df4������bb�V\�m΍�y xhW0N�n���s(�,1��.�<ߒ�4]XL3�� b�7��#�l��q��g}���ԑ�����6����(h[]�bn�l䠤5��l�r�`%�Uǁ;��]�>�_V
��y����M�)*^�[(u��i�^�P��K�L�q6*iMjg���e.�M��$��.=�� ��D{�Hx�g�hnW�ӥ5�$1oU#hP�6tУ�}Vm��^�f>��1U�"0@���.L>�X4�*:�+:#�5���@�Xܚ���rA^&^��;�btڔO��VN-�9�4�֔���v0S�����=	�$�Q��7��1�u3r�����Z�5�Az����WXr��:ٞo�ǂ��h��@��M��:��q�����4tA4��iJ=�'�v���Y���K�v�H¬C���b<���ɱ3�5p��fVڣ�.G&��lg܃�;&V�F����W�ֶ{7�b�h����j���|1&�������3�!{y�'��J����)Z�3�t�nƋ��6������U��ILr��1.
�,aK�'cս����J�U��sCN����f5Y��a�����|�����]�м��l���)�[��0^��C)����-�J,&��x�{��E��p��؈�.��R�bF��&	5����-`dZo$#q!�&QRq	׌�r�?�
��>�z��`'����׋���˖㪱L�"[�S�6��;�<l-La� ۀ)�7?i�nA�48����MQ���jz�b+@AT��\�2{|�=ۆN4u��9*R�D4�DS�(���"p����D'�4un@�q���m�wU@�������--W�o8�#, ����b e�9)���'lMH��2�d���C�a]�/%V�:���:�\�Ϯ���J}UQG�6��������)#n�llP�vqD��OǊ�o�-f#���TU�/�p��\@�����LJ#<ڮ���bX�gt6j4:��u9Lg�<��q��C����-�A5�/.)�*��A��}���Y��3�YϮo�`{s���Ax`��T�4���}b1��i�k��Zg�M�2�ʰDE]�8x��lຝ�?�V��/X��nuy�͘��c���}��aG�r9��@�X��`���Ⱦ�A��V}�|�q����W�������s�תz���3��V7pa��"_]}�ֿV�?.n�)��U��A"�+�&,��i���}���ׇ1�u�^��+j�����b���g`VWW�S�d�lZ�l|���dl~ӥ�p�]o������zؙ������C��X��ۨ�4�/�=�ȟ~'�)+{3�J���j��_ͪ�D�s���,t�T���)�;�tؑ�0�\���P�Vi&�QAI�9�{Î	����4��5v[<�W���.��h����w7g�[`*#B�ST�����q�9B�;�n����]b�ѱPy�)Y��P���F�a�\�kk�q�����F�$1�����FF��?	������X\����[ZT�֣��d���̈́vZ?���0��w����[0�G� ��\��
��'wD���V���y����z3(1�
��Fi�u12.�L��`���ޝ-��#�8�w�!�����ai�F�7El�Q�ofW�Yb|��/ǣz]4��.��v,�4�O����^���F=ڟ�כ>��FE�8zt8��zP�.nQEM4��n�[���5:0T�'[��?'��_��D�      �   O   x����0��0L�8q�����(�KAL�
T\���6*x�A�gC�G�c -hZ3�*���r���w8��>$?�`      �   �  x�͚MSG��ï���j�gz>���0 T���%P�ؖ]$9�ߧg����C�W�\Fx�ϴ�~�c�n�a�8AƊ��t8�پ�P�LG�o�R ����?�$Љ��`V\�W�۩�4������A���f�����ݿ�9��(�.ȔU�Hʕ��i��������-��ጺ�t�8�*W��F|X.���@J���]�6�|��0R�W1��u �p^Lg�g��"FO��1�\�\�t�����ZpQ��������p�S?����as�p2�3�o���#�RglK��'P�(�p-����	�O :Sd�8�ޞ N�*�A��~�	����/��F'-���]��,�
;�c���bRt'��%��Lj�У����p�s�c3�v�����V6�H��u�����K\��ֽ��V�K�9l��?��*�8�
�O9k�F�����TT��*ʨ��D�2���*)�1�8�<��q�:�u ���u7;ڜt歋�_����E�e�kŊ����&�ܖ8�۽�)�6G.���;���ܪ�ku��En����C�cp���gF����1��L�H5F�BiP�1r�!݈2e���*�V &z弯1���C����rT���Q��3 uJX�V8��Āh�2r{�3c�(� �=���;M�k˹�>MQ_�(���<�qS6)�T�I#��ru�1"h2"�*�(���pr^���e���Iv[�����ۇʠ*��ɤ�ZL
Ҙ���i΅�2Omi�5��B�����BZ�%��J����sg��NA{|�* �$�C\5��o^�m���yM�w�����k=�+U�]��>�u�d6�t���Վ�So^b=$�e��/�߇�l&�v��RU/�ܔ����➄gv��jO�ʈ�[�'cͬP\�?�wtxΈ�r��.��I���b�f���eֶ/E�Pam�,s�&��@��#�%� �FX�=0��Č��7O�A��a�i���G` UhTA�Zs�2��U��M�'��ɗ�S�S%��m1>��j��rum�"�w��4ee�b��|*Ӛ�8=�:7�^W���!glUn���m��jZ'��/��g�3@[W2��⤘�}[]�GUf�}�Ԩ~@s6��fA���V���墫k0�7Dq��k���>̈Zb?����m�1I��h~uz���ى)le�|?���BJ���l<��!)Y�� I�9I�hME��?��K�z���aF��8�3̶���IVtݸ�#���p+tmI�q��I���:%N���s�0\�d�JH	~�qOo��ⴥ�� ��A�B�@G����d�`ӯ(�M���x��=��/�̦ĤU8\'��_:ٶ�+kL	�l���~�!�8%(HW)�M-����(�u�*鈜{�$ ��ǹ	W9�u%y�ׇݞ3}�w�).T�ɛ8������׮�Cs�.�����C�/nx.�3�m�R���M�K�����d��/,R�?	��*^�K/�Q�H���I�G�rS+�0c��a����';���YfH�Y�qqM� ���d��KC�����Q\�r4�������'�y�:zg���iW�E*���k7�*�CX�=�V�3����=�j]�Rt���}�*-��1���P__�:\�Mo�w�;q���S݉s��(�_W�y1]�: A&ulΕ�S��Z.i3���+z�}䂥Gc)q���!�y���'��ΥᎴ|��*�X�c��#<�����mSr�6���6�O������      �      x������ � �      �      x��][wǖ~��
��J�:u���K���쓜��f�D�e��r2'�~vUu�]MWS���db���ڻv}�N�{�$���o~$��B%��'{W��B��xtz�O6�\��w��MJ�H�{�7�������ޑ^���a�\��7�%�N��;����a�����e�3���|�e:��(��&%�$\hLp
O8R��T�"�T*h1@���K�(�^�JwW�4SvD(�,%,{����ep?��w�����x:��'�ӛĮF{Hu0�b�E<���.E�e��!���uHuI)ͯ��?&�O��,�Sw1N�Tŵ�.>���]~������?��w��5(Mތ�p�����
�au�2$������۱�>ų�w4��=t���ǻ������`��/�Y�����3��8�����\\�;�_<�y3������?�6�|��P�0���'"��&�0�,���7rT,=F<�W*��{���G�Uv0�R�%*.)��XGZ��e�ʱ!Ѫ��ˁX3iG3����/C�>@�1,%�'De�p2��p��s������T'�J������w[�.D�iY�1L�䝃���|�9���%��O����j%�@�Km7"�T���H�x1��lqi�$` ?R����+XK'i�4E,{��$8��=ޕX~D�.�]�S$i�eJ+�_�x�.]"RM�lp1����~��CԎG��Qr��q�ӛ{��T����N��os�� �y`�����ng���t>�X���A�1@%�f�Ԛ��Q�>�4��b�v���ħC�� ;\����U3��+� =���}�)?_�\`�A�KI��a��)���U��y4pa;<��g����l�I��a���WW��s���ތz���^�ttu8��N����=F:�:��߿���&��zA��ώh�h*S�~S)R�� ��Z^���b�&D8�C���������T�B�y%_���`]�RA�NwW@���uAC��޿��a!)����Y�H05�r�;ˑE6,�������89�{;�w�❷�g���Au
�A�3xN�b����Kk�B+	�Ki��
��eL���$�6L������Sd�S����~��'�M0��5��-����݇INy�S����<��`�q���g�J6,3�U��N l����d6}���ӹ���1�gB����9Z��8���/m>�][�K1�z�>�� ­GY4(8�D�lS�G
��!��v]<�U8	m�X�G�"�a��cfW�L������
Q�[��f ?�d�$����d>���N?޽����7�D��a�2R.s4dN�å���I�_�����)bS�$�Wuz��$i�$�|3�m2�{�̉y9��x��)�yq�p2�2�v�2G���+�^f(s�-����Y�ظmTy���1��%��$�F+c~RL�)�:Hw	�r���"5HQ8G���l�bьv���O؞�D�ߡ�sx�������z��qk>>q�nLo��>��
\혖��q}�fF��[u5]s"=�x�J�>Z�<�#��pr6�-p��px����J"�,.��-\����hPW`_����d��Kk�d���� ETk�D�4�;�����jT#-I��v�W�e�@f�V��}��+��l��j����&����b2M�����61M�
� ��\�pV���C����7BD�b��*%V�p$�$�r���c��L.�`Ƥ�D�B��BE�F�Y��h8�S�VhT�̜��FkT���KH��������]=7�g|>�8!�z��~};�e���$e�X� ����iQH�=o���4"�y\vA�pR�O]G{�hC�n�R�x~2�[8�3�=K��S)�HB)���&m�"�т"N�.�<	.�Q�(�K	�rUUQۉ��Q��A����E��g*{D��p���9y3�F�g)��T�Q�愋츣 ��qYh��y1d���K�,	�q1pweKw�KF ���vﴆwCuA#�t�w�X1�Ű2hq8ǁ���'e6NlC��5�\�+�j��e.�"F��9�5:�a��T[s��߳���a��B'�ۛ��[x�"jAC�����t>�|�TQ��ĩ"Š�E�Zq�#����Ґ��r$����
0.�2�I�v<�������><�S�j�+*�?}���ǰV��d��Θ:^[E�3h4(>�h�Q�:YC�)iˤ�MAq-prpz������ᙊXW	���Lǽ�Yoh� ~klP�F=��|��|j1^H$q���El�D�cm\]+�by�BBD�������>�%<s]ՎB������C��d�~z_�V�x�/��6t@���O�?V�Ǻ�� ����������\4�<������������O�������ݗ���"���^9��'��7m�qn����C[���!h�J��E�=aP�i�/�)cclC�k�A7^nMN%Xˤ���>�(<S��G��_{�Ѳ���.1�	�,*����m)_����������E==�Hw��.��<�H%g�������
�����xnWH(�Ŝ�Y8�2{�벹�����uɣmx��4(`͍�����$����� ��Z�����FQ��#ꜞ�^��oV�s�.�̅�R��Q�� 3>G_Z�Y�P)��1 9|O4,D�T�N9 �@��S̎1��`rD��^�a�P��%�'�c�N�]�z֩�㖱��Uע�T(�rS9N1a����8��,I�hX�C�`��~�g|>$��dsv�_�=~����5^σSeޟOf7����ӿ}x�x�	��$m�`C:���PJ(�i�r�2�G_Z��Ԡ�� ��y�(a	�;�5��~�P��F����z���L�(��/e�XZǊc�L�W��Qa�i!�u���o�H$痣q����	�Z��h�4E ��N0&�LĄ���X,7&��5U��^C2)��D��y��Kο��r��.�¾Sw��o��w) �¦: TP�zTGo1&NǺ�J��B27֞�@�yx���yf�6�5��FL=�ͳp�"X�I�P!Bp�z���?��+�*9y>�?c�p2��3�;�PȜ߇�� �K��>�pi�[Ȧ�(Ϝ�w��h����c�R��O�J&���Y�M1m.���(�IF؄㲒�e�fu1,K��ce)\�C�謅�f���96v>�`F�)ҹ�����<ЬYiV���v��L;y|{���/�ճfX*�����k�gU���V�uC�u�dSxxT����|4��&�-�4�{���O��<�q�(���3Q�:���}i푯8P��0��-�)vV�N+�p��{�녕����s+��̥	Y�}M�jۿ4�|��J���	@bE�d�oV͵�A�1 �6C�y�����R���a鈚��]� V��y���<��� �Ǖ�+|�d���#�iG�1x���!��2n�2�?$R	���n��&B��p��҇���w��H�ݕ��q��Y·�Zzi
>��g|.�|+	D�*(��)+���Dk�o����9�������УAW_���1usl'��B�I����t������3Y`���B9��['z�/�{`Il|������3�9x1}�����	��"[,�?�<�]����	��:�<tN/��t�V��e��Ε�
$�p�d�TU�#�dA��[�*��>
E�g*|�"���Vwh�[�W|0�j)0& �{��	e�(�5%�R��*��r%����P	S����;��� V���:����΍w��T��̹���"6� ۤ:�W1R� �'l N�u�R�i�I��/YP�l̅l�<�
(����|����j%f��Gw�!k4��ű�.�N�J�ۇKk�^���H~����"�Y{���[[y@�Oy�ݶ&��tg���T��W[�B�\
��2�F<�B�P`M����|'�ǵɛ�֭�/A�U[5�~��*6����O�A%���N�%��je�X�o��    �S�Q�W���U�B��x�9�Iе�f��7�]���F�c�K�#e0ҿ!�{{����PY���W�aZd+S�G�E�6W�m�2E=������?+���E7��V��B�l���U�!p͛TL��6� ;e�H�j^2�=��z�L4&w�皉1��uM��f��[d�z�ZQ
�^K��G��YJ�K|X���K�謁���6��������������S)-�����\�!!���\����tw��kU	����&�K���v�Z�K���YS�u���U���T�����o(5�����C}�^xfY% 6�6̸7:Ε���%����~a�0�$ �ٲ�(��A&,�/� $쉞2a��]"�ه�;��ʸ .�J
�(���W��zSR�9��Pe6�a�2��Mܝ]	��PO��NL�0� �쟌y���m�za���m�pH���sQ�aFM{
��>�6�l�h��#��&=Ԃ{�RwxIy��ew>��b >��eQ�he1{#���mPx}�-�͂��,֭\�Dh��}��KP���%Ӕ�iF�9�8����AR����zH`���Ȑ�����ӿ%�����GG*��e�+`D�4�J8Ap�z�٫��b$Lr�M��gO,�jϞ�
1��儭�q�=wO[w��u��
��( ��v����e7fc&+�Ô�
8syb@nd0pY-�@�05&/c�f�U���
jX�2T�3<s��yT}��HJB+���F.J[=�+����<�2�	o�C:+���ɐ�I�"��������^�.�|'��ฦeNxC��	��5��ܪ�y�N-8ئ\��$��]�k(�t#a��	sD�b8.�UZ�*��tƄ��d��&�$<s��X1�pDE�Bf�]�A�	��(�i���8��_Z�K�
fծ|���e�=/��f��w�y��g��>��	~���:��U���
X]���������7jPk\ ��]*�H��Sxfwl��m���)�z��y>�f��	ʙ�4�}5r&�I�41=<&��I���K���gv2dMBI��j��|d�)�y���_E���|�T�'��-�}����b��'7�7dB��4բ���K������;m��&4�ϩ�'2���������ǂ%��o����L���ܳ���`�Pd'��4,T����y�5%�Pon�|<�<[8����y8����59�^����۠�N�����^����5�
I��Y�`��#��Ip����Qg|��q��  9ut_<����j �M�B�UY)�Ū���Q����U��Loj�	*��$��On���LlKR[�t�U2R&��#�G3��4�Ƶ�>�{��տD��y��6��4<s�����7x�ڻV�ⲋa��e���%�*PՊ����.�����I�<����P��[��$R�P�~�˂0�.i���^���B�2��w���2�
�v_f��z]x�"PX<^x��'�A�Һ&'�!B��wWe�~j�.�lb8�ʶ�%i�S^��@�7�1~�/���@�#` ��U��+cߕ�9�8\��}�t�=�ΤӼuyUXV���b�*�q�G�RL`���h��qg�im�D5���8S�����M�^{y�#wA9��a�~SG������������"C�����}��F�GȔQ=���F�4�~.�r���Fq�� ��zE�!���T�2���/w7?$��G���	�h	Bi�`�D���U�t�9�c[����5�kr�l�<�𓊦&Y��I��FMf�������e'/\J���2��U5Q
a��Ehn1n�UT�q�uI(��=�wΔ���7��e�i*u���}��K���m�URY��J*yba��K�=���ڛ����
qM�"i���m��=��R����R�z"|��(�,%�4�����M�0\w<�'��=$��Q>��?��g 0ɦ%�a^�e
�@Uf���hg5��,�(�g�	������W{��
BxRU�g�!n7��%g)�U� O�p������k#��+,r�l: �lf��c�!�R��ٞ)�/1�L�o� �J���LEb�j�m�7�
�-���Oy������MKϩl�i-��+��M{g&��J6��c��.n��:�/�����؆���5��|#]�[R�������݋�4���Q���<q�����h\X*9�Mq��ei�>��l��"�1I|e�&JN�W.Q,���nB�aC3>�4����S�?-_+�gZ�S�KF�:����K�qIݳ��9.�����z;px�'�`Qa��T����AX�b9dp�x��1�-m�� c=n*+�v��Վ��>��؋R�Fs�)g�I��<n�h�=k�g*b:T���":|ޮ�ɳP��-jϖ���/���c�����]�mY|��}.!	 ����ʲ��=�2���&Z/��}~��I���N﯇Ǉ_`ON�v..����&���l�𰠥_mѴ�[5��R��#��=�p���{�i�G��f])�/1�J�lN�Bj������m���q>�@E��c^^�,e��*U>8�U�,ͼ%�����K�K�Cgx�1�Gk��N>�Zu���X��H�1�Ԝ��9+��}i�����]��S�����Y�}���	�}���s�D���`F�J�s������E�r@�4�+�߸[2�)�w�@���U�ox2_^Իc�3�}M"{�5�������s�E�)�fdJ>�XJ�L� m��=�aZG�E�V6J��rO5�(�$�	��¢F�,��g����&M���� @ݢ3�\��|�ƃȭ��P�dzwyչ���>����������I��
��U���~��N�ؿj��*���
����N�(�1�/�{ �Lc���� )Xf�U�P���)��a�p��������<�gbe�.�����*9��J5�m� 6�SK�Ӓ,@I�GÆܲ�nk�Aϭ�cؚ���n�ļP�%���΃W:���x�@��P ��VYr�R��H_���|��6A�Txa|�Nxf�!k%
p.�~I�;�+Ǌ��"���� �8o9~I�Er���S�=0<S���L6���~m;��-#Ja}A�X~�׻ӮXP��v��@cM��CtJ����?dx�iRI"���>\$K80��W�H�E�fir�i0��l���W�zE�ɯ����g)O.�o��B$<s����WT��f�)-�]���E4Y����V�5�5(dokQ e�@Ų�,����\���:�g*(f��-k���;���%���0QL���?�#����mI[
s����x��g�w��&���[�_��k���~��]���6�N�I�"���m�P��䏠=��dPr�˛ؘP��.1�h�QUl�=Sp4Ea�<�B�x�Xe�Ye�Ҧ�(�����$<�s��(_�t?��7).	�Jf�@$��d�4��ZRXb8���+ ܹ�����)���<������qmS.V7�&�D{P��[��p������@@f�8l�F��
�r)�M�������M�Dɝ��9��FY��S��ޣ�U �&n#�;wu^j �I����ZjkϢ���D� ����q=�\o:����IV+,� 5�e4�²$��0�i�v�+x:8^[air�jϏ�B:���W�����>63�,�J5v��9-�XP��I7�8���u|:��<1���K� �8��
#Zĕ�6��&��m*v��
�U�@H��������VP;n?���g*�HL�H #���f�Z��i�W�&�����2����lB��[v��fJ�����6P�%<s��)3�2��D�:�A�rY�o@�D&�4�u���1�D{jĮ\�*5�l�R��c�b��)���L�h	�j��l��J�&<�Ր���q�%�3>�0����DIo+��d��aY��\�?��^�WL�
U]
;��Dk�YS�s�E����ށ�V`^؄k�^��I�㮔��I���<ޑ�G������!�&� =  �ɽ�q��3��A�O
ye7dH�o��I���>� �����O{�z(��ް���a��8,���~/�zB\�z�ʁQ�l��S�����t��j� IV$-�9	7$&S�??.t�ePx�j9
)���:�e !c�j�а.�شWDAq�J?Zl���3;Fy�pS0t��5�P�:H�v�F?V�n�>0��Uz��aV����	�W�R΋AF��K��U����0�������
����{&��b�~�w><")�8��m�ǫ�G��͵�6�=Mў4Y*Y)��3���LS�ŋ�3(�u���̎S6�)�٠�3e �췛����1ʓ1.5�E�S��7���?�
���2ti�%��e�	�4r�L�&��z�'<�s	&*��p{~�v�Y��R�(°��^�OfSۀ�f~��4�s� ���)��<���Y��y5��Z��6���ݕ#�Uc���P�;��g�-��I�GM�Fe�P][P�jl{�ߦQFޡA��ɚq��	?�;��ߔg���5�\�ĴGWd�Ȉ�¯)10DՐd�Ax���˟� j��G{�l�8$������|Z/"�3;�0��{H)\2���HI�#�#�T����9�Fc�J��z��������ʎޠw��Rųo$L|�N�ǈ ��#�]:=�����`a�lFPY�)��"h��ȳ�۟TDyb��q��|~3ٻx�ӄ�W�Qp��R��8�[L�G[d0���S�9�W�o��P*<�):8��i�ڹ�\�#B*�Zx2��٣��'N��2A̅ڤ)������+|l��PMf5Vg�#�~��*l�ʄ�$*Rk�*#]�5��TQ�5�*�Z��v��)ï�f��BW�M��ù��?B�>������p�U8<�㞜{fɇOS`�|�e6���>������p���7�Z����a-�ǘX~���3;��C<�v r[�P���V��	H&�s��[hgÍհ4VUKDj�i���j�M�)� /�`a������]��C?��e�3#.HLwn��qJDs���6�uiX�S��?�����w�}������      �   >  x�]PIn1;K�����ȉ���K/R���&9��"%S́P,2�$�T��6�N�%���yk���^a]�4����G��2�2�����d�ذ�z�Z�G�,���VB���ۥ��@36>�u�6;Zn`��e���|$��D�|��ъ��K&��*���%n�X_(�tD��]E��D	ѳQR��a��Yʰ��	B��=Q���K���J:n;x
�~nu��vlz�Wt�A����>�zW듍��b�3U�h]ܲR�B�!�1ԑC���`s��Dn�RP�|�ѻ8{�zy�O6z�֧���Ŀ_��̓y�      �      x��\[{#�q}n��y�g�F}��m@P$$� �:��xI��V��t�������s)j��#q%���麜s��?n~�R���A	#�4�� eL�d���8y��}x.�O���<>��z���żZ����Zl��X.�s)�<X'~x��������?�rx��˧�_���W^G���G[~���ȿZ��,T�i;3�L)��t�/�q��|�ğ����c�P)�0I&��	:��no���lhq�c��������v�\���C��X뼔]�U���ڙ��T�c��l��x�F���RO���	�������]1�ŗ���ۇ}!�����^M�>9/Ϊ��|yYm�N(-��cOJJo����/��i<�X&�'�f7����3|i[:%�����B!~�q�I�+8�.L�"��m㣘W�������K�T�&��1�$Ngo^��cb�Z-�o|YYw���D�<����c_^n��tRS",yeeF��3�J��� ����:Yo�0�S/��	���Cc�
�NH��#�J�A"[J�J�ѱ��
,�A&[�C
��5��6'�:�ޙ�z��d��iE�}d2÷3C&�̆�j.5�HBIg��Ѧ7��b��,���%}[�no��kZXE�-jy�U�I.YƔ:+��J�KU�8�j�r�q	�	�db09�U����Ǔz�.�oK1����,7��x��\�ʩ�S�z�I5s�L.1��:�g�̜,�g�3N(-�J�Wi��P��yS��÷�7�j}Sa�>,��&7@�̄v��6�G�3��ĩ���]���(P���:�DL�/G�>GPU�bsU-��K������)����b�re�#��R ^�t^)Eѣ�����<��E;ʅH�1���u0V���JϤ�)[��,�Z9�$!�ӒP=����/�?��R����`����~�YT�z��C���1��	ɮ�������E[�nÝ�ZH�D!!Y���V�������P̟������,���_�����o(���*9,�ff��J���	{�k4(��,�}�7�]c�^�OT�sT�?!��t��\���#�1��*%���z�I���>���Շ&}e0Ș��5v`��FG�1�n.}Q\��u�����):Lu]m��7��'TM2�9L�O3�P{�����[)@P.cNe���o�|�����3�C;YѸB�9���r3p%̐�Z�N��+�)E(ՃPic�z�g����z�aS �fJ6+g3�a|@
����Z�U[� o��2�#�k7��U�)pO%g��C"����An8��Ǎᣢ�>3��e�Mݷ8��F��!r�{���9��� �,����.��%5��*T�K�A�zw]\m�u����j����Z�L27��g�~ ��n8a���癍\��f�f5�Lj1ɻ��D�̺�$�7[�mY�/�2�x�<�魐9�.�gU��.�s�e���	S�6tMozh"���¶���;�q'��1)��{���}@
lwg;D��պ��ۮڜ����!����2IR��fH�ez2H(�]�4��#�	��M�nu�x����/.��M�8$�Tj�&���w3����cz�eڝC��RI	F�`�_���h�mf�!�'�r̀��an�TZ��9�1TWfed��V۞gW�����O0:���#	�������`4h�FK$G���ݛ�q�\��?���T'�Ó�(S�+
VtR��~&�|)��qL�pV�0Zk�!|>���#{�q�89Yo�V��{JQz�����W�U�1�i v �&X�@�����?CL"��F��(ra+�g���hG��jf|	.0�*����xi��C�%{t �hy�y�>�� �Q��>�`'h�b� K����T�4seJ9��P
'j] }g��p���޳�,�O�wt�ѹ�ڙU�����������#xFC���[xҍ|���tV~=,�!�`�%�<8���z��o,(qg;���q ��`z8�F���@��D^.�^��-H���@t"+Jp-SR#'�m4��ka�V��"2�Se^Ìt|�^ 1�����$A�+����1QhjH�Ag2d�N��X��cf�6'JmmguRߗ~u�C_,���L���w���Zy`}y�^9�$������Z�$p�<G<bGT3�~��,Jz4H`�.��M�%[̋�,x�Đ$rt����z�f���PooOێ7�J ��)�N�6"U5�˘e�/�+��r�CbLr�b��E�Z�I_ �
��°�]&<mXS:N�w^�O�%���)=	e�hф���Su<��nS��Lp���.�c�PY�<7A��7
�?�<�Z�.��b2/��ݮqb��C�/��^��h$b˓�е���)�U�;���8=;-Z��������v��)B���J5X!K���2q��c(����s2/�o����q���e�
�M��\��s��WUƦH�I^%Rz��+GJ����MQ�H��z�X�3ୗ4��uHz�����X3LO��q��c�#� �1H�,ρ;�s����*��(�k��8QP"g6zb,�C�=C��*Q�,�hZi� �4	r�pq��K�*K�7�+�>����4��Bb�A�X͏S���d��?�wm&xb�$�Y�7��}l�7*��{�	{�/�V(�1dxh��]3���[Z�Q]���ȫ���+Hh��4����[�{�~�6�g� A6����������׻�}�*MK��X�~��ő����Z��Rs;P��hK�/��T��ag�͢����p��]S���j{S�[,�ݶ��ׂ�{�N
���
��z�)g�Q`��5ż�F��[_6n��,�?7<y�eR=%I�O%3jdY�*i�H�謋W�b���C{�����\�3�2�����d��$W ��� �4�&�A�M/e������U2�|~z@e����M5Ç�V3�QtE�:�0| xg��r��^j4fʀ�s&X�2�<գz$ƾ1��ք�O���c�qyN�r-�&�$��l#"���:��\���̪�Wb����=J� ��bct�#�4�;���{j�x���r����"Co3�% ۨQ�.)3��R`�eP����� �1�.A`��0���0iz�S����T.�������P���$l�B��,�2=���2f�)hX��G?�N1������i7��B�������HA=��;�W�\q�b�岁��i6U��b�=�H/AZrBA�@��DٚZ;���M5_7��jy�=�5���m�-���6�I��E�Y�*�R����&��s�8��hjL�^:��\^��Z��T}O�c�##^��#��L�⶞|�y��ah3�Ѱ��mc��n�Y{��P����x`�����t�}YF�1"0�.cY�DJ)���{����)�WŢ(6����0�fuz������ϋyqX�N4�aI�F���Ր4I2��`	��~�６6�4��,^ ��aI���*����C�iw�w�5��hO[q6�}�Ļi����!
��e��1��ߒ��?�����{`���@�����U��O��� ���1���!	 C�&�M�NCzO�����Ͽ�?���8�%�=�p���@�%�y� �V�����,�c�w��%��`�.��������r�@��!���`	���T�V�y����j0����G�.�������@�CQ������=W���U����u��{�ͨF� <�|k��$Q�d)Id�c���`�D`\����$?�V��H4j�?��@�$o�o+?GO\ �����h�o�"o����O͎���t��Y��o n\�M��Ɇ���d��(	�
 �<{�h讒'G�����������'Y���T�W�q ��jf�=: J{��?�fq�Ӹ��Ӌ����鷑W�j|j����ݞ�::��B�8v��� ��4��2R��ė��r[]W7�p+��_{��=X�*[�� �b%U�@j�;��X]�Q��J��R����=� �I��Dˌ-9������������ �	  ľ�2�������-i&���M�J��L���B��h��$c�5�T/5w�z���82��&�{�Bf[���L��U1v^+	zh��4�$�	͠�zcN�?lu^m��x�q�j�X�2��>]
3:�m�$__H�4�H�b6͓�&!o!S� ���,N�^' }����=��u)��ґ;ߓ�Ɯ�@�vhǱ7�J=��W����j��n�b�^~<�l�7?��M�����W8�S��a�mbz\��	N������n���[{J��:�k��99\�@ϡ�&ѓ~}m��BQZf�)Y�옣j�v���C�s�G\�&��a%c/W21Lr�T�I��toP�h���������vgH��%���X�^_�h\"��YF�hL��ȃG)0��GuX����E��}1x�Tސ�U�	��؜7L�NA ��r���;�F��В"�5�h�k�m���P��B:K��0�me�BR�%m5��0<��OqƅjI��,0DK��L`x5�4�N`�E+'�k�j�!�u��i��8��P���tG�;W��ȵR�J��aHN�I)��i@̚�C�yy��Zhm�i���֫y3y��"^<�iwdd�#:�`�J�	MHD:p��@��-��r�����=�?�~���B]p���RO�Ģ�jf��R�
4�����ug���K����ւ���� �F�t���(4�:1ӵ��֋i���Kj�zt<��`%P���8�rt�=!���C�&�>	�w�rϵ��Y+i�R6�	�jN���
m���T?Ut:����#'x>&�i�7��vjx�FHv_kh��$I4r�%
l*�a5���1h��q��yY]��۲�fI������Om"�r��x8�H&2����q�*�ڸ�gպZ/����q��%���Ő�-������r0�]� ��x�I�����9�^��Sƅ�M'�]b�v�|Lܣ�0�����
��4�Τ/#�>cy�������p�F�I�B�p(j���<<�2�!w2��'	 �"ph=���wM.�+�3F�G��L���p���֊��%;�ƣ[�4g�A�s��l������M(�	�D-6��H�XO�ۉ4q�]{DS��f��x����4�7���=����z�ѩ��L%U�;gR{"��Z(���K�9��/����t�Sb�&]� Fs�x��֫j������ ?^l��){<SD���w���e��䠫;��^��\k�[�ˊ�y�1�T�U�ð����N�X�F��1�
1�9�mzG�]h���jB�� �>D3���6�K���-W*�5A�Rt*��*�e��� T���e�t'�o���X$��I9G<a`���ϔ�S�N�x'b)���0�����	�a�T�S�hM:ӇLy�Xi��80?_(:e�V*�I�t87%#* %��������ۇ�h��V�4е:߭o*�쿨�W�Sq��jL-�FO3�Q9�G�}$"<ǯT�U:�1%�]N�;cz�;�r�ʑOt
UTE�)C:Jc��R�)�v(��1�����M� ۃM�g��K~���R)�rs@dd�#��}o��/�fG G��nh�v<��m��sk��"�0��ESnX�i�6�*p���X��-�tk��;d��C�6�vެ��ǘ�&m;�c�d.��>�Ѕ�;$3W���:�����	ۇtP��!{?p%�5��j���B�H�4�ZD}C���n�I�G�����A(�)�?v4��ˎ͑���Nd�bu�C���dw-=Ϊ����TNf��I�븜�7lw}���Y��+]���,�|��H����cy�.�����g��k�v��u�P3�*�)�E���FR1���o��8jYJ�?j��8�҄�7XOG�i��s���t� rY���pro푰[�����_��~}������7�c�z�F��ZU��"�G _��l���j�^�7�euAO��9�C��4�����6��7�@Z������N��+�W�1��I����1����f;�����:f�כ��(b���,�M���*���ߺ�����!!�����`V�:w�!=4j�F9��� �v������-�_u�ǩ)�':�'{����O�����ẵ�Ǳ����x�6�������/���Ǉ��?D�8q��/�o�,�����r�?�l���H�/����Gõp�_��xt&�9�`ށ�uz�;�@�>�99t9ml����6�]�tܘ��n�TƊ�=��L=KVߕ3�����<����SkyN�<}��{�a�FjҶZ���ՙ�P�h_S��
�U��6w����N7�Z`.����7�)���ۿ�!|j�����톮;'pp�d$W��>�NC��[Kōa���.����;�nx      �      x��\�r�8�}F}��g��� ?%�R[LY�C��1����ZCK�x�~��2-uetwUVEv���{�=w���\�_���`�=�ߒ�Z#m��tӄ����n���OI�lCe"�X�q>�3[��B|y[d�<x]-��f���Ն����_���N�w"
����;��S���U��t��3�?�m��.�ճ�Պ=f��i�̖�Q��c3Zo�E�X�Ӯ#5!菉� �"��`Y?[��w�A6ݳ�l����Å��\����b��>9y}]헻Z����u����W>�2!��a��IO���6bV*�x��"�]�M���t��=��Vŏ�mvˋWwR�)�Hxn�?\2�I�̠=�$��C2l1��Y��j5�b�D�pk4� '�#{���nKy~�`ᝊ�dh�1H�b�tX~R��Zݤ�ԓ!�t��0y`F�0������d���q؈]�}�/��~�=��G��������c�9W0��~�^~�g��ɼ�̇
&4k4��I���'�����?']2�v��?,�c�?C(~�l�[�����_6�q���� c0w���8��3�9#vWDl�J��t0�6���`�{�J��F+�FgK֪�D�k��`�7�L�sl����)kBܩ��J�aR����`�ݔ���HJW)W�NZ�
LDjF�-�A��曗l\ �f����.��w'<G�Xt���U88Ϡ�����X��6�ư�䏃��0
�͗�R��wJ:R�@��#f�ިs���/Vb�z�X�k@�f��38�f°z�=rG� S�Z�q�[1�ZFl�-���r_"�n'���#�� .x s���1�)�b�;�E�7�z�M�i+�ų�(V��m�go��b�:�a�7LE�iк	�h"M�?	+m���������!�WJD9��n��o�OtG���
D���2)A���`?JH��~���k_���� �?���RRF�����4�ͳ�]d����'{��U�n-+PyA_���sr`��dH��L�+x�y=�ޥ��<���`��j,
)sy'�@T���B��s�RlS�9�C��m�Wrx��C�=��z���:��d��3a�~t�x�~� �*�Ny��u���V�G&R.�ۇ�����C���i��v�{v6I��I�+ �<28�(�Vn�p�0H��F�(i��1�P$l��d?(rg˷����EN���s��
T>Kk&���e�Z{��6�z��3���4�ϳ�ag�Z�P��[�\B�PP]�^��d��ĥ�K�V��L*bp����N(��[	�K:����[U��8���݅��7oGK�J�Iq�M �0y��b�/[�'}�=5�g�k.1H:���ϗ�I�/<PD1�q�e�eЏo
�N�8̀GUG鑕2�Xj�C\��pE��~\��q�����v��>�#��E��gB���GĠ�2̓�T��@Y�d���݁d�T!��[�AD�e6��G����Y`�wBC�T���g�؁T#%�t�"1Dt��9I]�Y��s�a���;6�Қl��~M�F$	(����#�У�P0�	�
��j�q`#ON8Z+M���d3Y�&��v���ƾ�d@�*!;+px��8
:�ֻ/Tc��:l�{0Vġ�-+���匿]&Lx�$#�!�ꈫ
���(�ڃ�1�b/\hs��K`nJ2BP��`nX,��t5�p�K!=���qv28=д�hv��P� n&��/�8G��H{�ӅK:f����@eA�č���B���0�����E��p��=��J�g�1�K�+��x�������a���z��&4ؐCT=h��(�A�
�I�[���d�ؾ�D"(S<���<
�����pN���������H(�A�x�gǐ��k��0IMl#�*L"&����lZ�������9���c-c����v&l��q����q��O��Ns#$����d!I�1�|������} K׹Pz�x(��NTUޭ=�ӂ��i���$!�2ԄQ�AX��^(<�FN���,����1�)R�L��� �#:2����$�$�S�PA���vB�J�;�=�,�WCOL�O�
���8��H�q�H���}�~K�))���Ę�)=�/���Y0��n�����S���SZ:b0�T�0yfPV�Ĺ�{�}�&6�(�߅�Րm��8�4��ᑈ��ɪ��G(p�ϐ;AgO�e\+cH��7�������%:*���(<�]��8��Y��"�)�����8f���f1�f�)���0d��6����C[�sie�O�/2�c�+�R#"y�n�6?��v��f����^+�*��$��3�o�(��"�&���gQ�Ob�r�LɣBֳ��ѷ�ЗNՔ��DBd/�#�P����WH k�l9��l9�`7���&�u�5�L�G�B`�m״$�n؍qUaP�����*�:�Ȃ��ٷtx.^�ߴ���FE�|7y�^;+�*��Jo�J'D��;�!T�S�MK����*�6�R���B1��aWH59U}?zHNi�q�"�U$�C��2{�fgZTl� ��#{�%��
K��%0��n��RJm��V־J��2xX7��W�JrmYk�_`��l^k��ˬX"*�`�%}���v{Nɟ�Z�+�"@h����Z�fp4K���O�3��s?�b��� ��R՝��/���U�|��\ۡ�ՓuQF��!/\E�]�������K�}��l����Ϯ�
�2����O���KW����>D\e�^Њb3J�V�N��4��}?�gt����e��ke��N���k;S�+Nq\V�r"/rE��|�E�<�)�̸����T��2�xv#>Ϛ�<v���._�"/��!ïn�1��'�N� )_��_���	���l�B���[����~<����j�E��R~)��N�r,Xd��-�r>��ɉ�gc,R1d?��ư���J���1��2�r/d �Ư����vA�G_���-l��oJh��f����O��"���Z�*���i��x���� 0��
�ġ�e��d��>���t�O��PX�
߂V������؞Ͱ�ͤ�_Q[䝕���H��h���w���#Ya���3,��t�xgA�y=<��*��#X*���d;]�MV�_o2�_�Y��ʙ}Q��������gK԰El9������D��frnZɗ-�5�pv��-~�ɸ���U@�}t脴�[�ZQ�Z ��������I�EP D9��y��}��Uw\�|lY�+k�r�
0��Uc'H�z��"��-�RDE���t����ؽ^�Y�!�YI�l��|~c{��X3�z����N�5�Q�T�_Z�V#A���u�wT�Y�i$�jP��BĞ�#�!daҝ�{���"�>���+&�(��aoء�|�}?����QA��@UE�����k�x�vm��#�u���ɞFg�N΅V 	�e�l�M����s�$%�T̬�qOĆ��3����=g���%;<X������x�{(։I�Ru`��/,(�=��@} �ZK�=2�9�a�F0�(�Bξ��	` ���o�reA�u�T�={6>��1�A�4ու\eP1��2�5�BC��?@U�ϏE�_�p�AN���(f< �j44$v�6sK9+Cr��ͨ��X#Ʌ�J���fO���_��ŇFR%&QK
�Wu�'� Ȁ{j�2j'�a�.��( l��oV�͗lL���>R��eH�4a��5�wŰ#�D�C��_�}_[�_��O�N���]x
Ɲ����~Q��t�����$���|)�0���OAU���6��p��k6MGu�bߜ�sH���.���N뵢 bU���ÛL��5^܂�&ҚͧS�;��NE�(�k.�M�L���^���8�>=>(ژvd� �͔a�t�f��v�����a�D�źC�`����XdӜ��j�Jbe�Zm��_��!�E5�C���z+�O�i{p���21���Ѡ9l=�:_�#u##s�H���<_良2^�C��VRZ���T��L|���۾�ŇC5 �  �mE4�#�t쵝��)���b���պ�U==lKYȊm$ ]�{��l��U�S�Z��8%b�(�bF?r���P����+�B�t��8B6$�PX��L���7����/!�4F��
��`��)ѠS�]X�I�GbG�/0��h��FJe���"�2�����?H�=��Ǎ<rR����Hٓ\8�ʞNY�s�$��.��_<ѶX��1��|��<2[E���w4-b���_�	�p48��Y��	!=\�<8�uÍ�
� �P��k���c�F��P#�n��|W&5�i�,:��&vN�Y�����'y`�q�"�)��e�GW��ܢ�
Jи�k,'NW�y�C����~lE�R��r���Kd��6e|�è�H�0�uF�a����Z������~<Η��O�P?E1(񾣕�W�,3�zz@�E״�1�(��n�Q57̓�bwe��d�4R�*H�����x2Y�bu�m�<�M����d6-ש�aCα�x\�C��إ�
�����h���ün���m:��*��B`>���C����F�従�N^R�t� �th�`�WpECO��9<S��r �?"���o\ߊ
�'�?�ue=s�u`�ę�? �x��qԧ'*0����A1�y\��YKɨ���o�Y1A2�6�JU?���G��ӿ,i�R(�I�bŁ��	��@jcO%4a��1�D��"��AV$��~�b*>�!��$�a�h�:�"�'���B������,��5r������W�K�$�����b{��G���8	�����#�k wV���;�����#W� �]�`Շ�ՆBLh�/��g��.�(��T��` �qI��*�������qv�b�*��,���{�����[^q7QJIVDջ%}T
��аܭ���Y.���n�{vq.���G�w0x�]-�y>�&K
H�䫂|+!)RH�="�v�N��%���#��Ǵ�6ʹqn�v쏢�yj��ޤ�]�Q������m �F���Ew��x���Zg�`��,6m�w��[ ��o5W�Dʪa<Q]� "F�3��Ea@F���X3�:ʕ"{��U/^ަ�;���J��%��bA�
�aR���Ǐ�h�
�>�8rn%D�#Mct��|��u8��&'�'$=u/��}�N6������\�޾?ܽ�)��G�ٶ�]a.�^Pu��BW툪�A᝔*�-����&����/�|xZ)�5�A-�����?&/�S�(���Q�>$����َ�f���VE��в�=�������h�B���>����KD*�<�?Xd\Q��m�7�wf;7g�4Mu�HqX5��1�V,��c?}����կ�Eo��C.j����͉�������ʱ��A(�kŭ݄��I��6�+�$mE�k x��.ݤ�7�q��J.�"%��`�!�x�m�zY�<���؝�����H.�r�9O^��Vׂ�*/U�[T���G@H�z���ާI��!�u��b��23d��_� �=J�3$E&v���FE5��Mh�{w5�^������ �TM����Y�n��Rq8�V��LO'��S�õ��G[�.��b���KUE(��A�£�����C�ߌ,������)/jIH��	)v��Z��!X@�Q��󭂉�b����zj���tFZ��؏����1�FB��+��U�tqY����:��f������}���\;�|�1 �����-��o��G�^����"��ז��� ���vNW�H�9��ߊ�y�D�"�`'��|6�Uu�>R���.����~bKt��g����E�Μ�g4jzF�?�|��W�(rW�%uy+�^ ���Y���0u9W����S�I�H͟�Q`@��FGŲl�8rd��,�t���{��},�@R�.uZ����zm�b� 	�U����پ��u:�r������mV
j_%��X�c��`����i&�\�)PNJ�V~��ҧc�%&7p��@U���9�) n�˽�RJ%Qp��T�Z�T�y��>"������9�$8���l>$(!�?}������/�P�/b�V�P&$��os`گ?�	/�����RU|.|)@/��w���#���+�e���|��Z�#��s��Bh{���4�E�4��� �1 K�����'bZ����Ӣ	{��▸�L� �7?��$+�c�F(-e���(!���%T��ԏ�)ʻG�=胸TV������u׳ ��oz��d2��LV�/�)�	%�W�.�������e)#*���U��e��m���ǩ��T�[�+��
��q�@�� �=5�m0����'�0�~���T��UC�GL�=�ѐ�]3���%���F����+
t��OG�XO�����f/�l���%����3H��`l�����)��~�-��C��8Dʉ��e�|�����n�E�%�`U[��B
@:�]�n��T���n��eTt9۬�!���5T��),�c���Z:�����#
8ƥ/�tPk{�0�vtJ���1M�P�ͷ��$r�3K�pzT���j�С����2�-�#� #��5}����H�L���q`*S	�z�BrC�n����*
R��ک�Kˎ@�!�І�l�_������A�J����� p$l:N��=���7t/�)��+yaL3�;�,��R�O���Hbztq�l�n�"� 	ziMq>��`��۸���a�o��-�����B4e������b�@��do.��R��1��1�+D� Ri/@�C���*�Z;�e��Ԟk��{ᕂX̽nd���2ɖ��Ϣ������)�q��ײ�o�I�ѽ"�qȕ�޾�&�_����!K���!��P�a�i��C�|�V�4.a�';�'�SS��=��Х��f<�:N�0r�-�JJ���y��,�# �q����*L������/G��+��Kh���	��l�O3�?v�)�{�s�iYB	�O�T>��J��^~<H�r�� �*��_�Ba^hΎ��*ߦFZ�4�Q<(#?�������i7SLo���R���FH�����hpй{�� �r�Rnb׬�
�Gp��\�z�=��i0^I��[Y,��}�T&�����<�U��2�_lh�����|K��z|�H:�N����|���yD�y�ގR��a��7 ����_~����      �   k  x���M��(FǙ��yGRH����A�z��h�V�5 a5��N.G�1����Ş�7�_�~P�1����L�(\��@��������p��i�C�<����O:.��0<c�ڑx��
������T~��E��p��B�
������p��A�I*������Ɩ	���彋�4�i��Kk��<�÷�.������;�y�e�G�4:V�I��ׇ��[WV�3)x�����W�������T�c�ژ����נ�]���n��E�Q�
>�L����+.G�1'y��𵲌�t�����[ۥ�;��v���7x��=���]S)��֋i�Ez�S)
�֧ǋ��=��p���|���?=z�4���������2��x�ZWr�^�:My`��U�1�W�\�=�[RRFG�))=�-Ê�~L*V�� �R#imOS��_��b ���y�[ �9&�#�Ԙ�s�HL�b�J�6�"��13�0b���P���=��{�᪄X��N>x�=�ⷐ��� <���gq9)�:�)��34RdfOS�+���������y���s^�bhiF��X��W�O���K^kL�FS�C�Ed���L~mL�	XZ��JD&Z�6���%�Բ���1��9���Ir��GĴ��[RR�1�����1�7I�gep�xz�z ��@���R��m���M��y�������clh�T�=`.I�Ɯ�u>��,=����'�ۏ~���S�ҍ���WB�|��o����W�����u�a"l;F�f��a�7�vo�6�Ƕcl�:,;�Ye�*cV�ʘUƬ2f�1�XMu-�ľh�][Wu:@�@4Ct����#DW�^*&O4䒠�&�%AqBPd� ��'�%C.�r���:n�4p˦�[:��i��P������-�:.�TϲO��>�+���h�}��8ke�8��'���^,3�����	�3��^!������U���0���aIX�aV�ʘUƬ2f�-��
3N��nY5p˪�[Vܲ��bY�Kd�'�}�U�0p�>a�X}���a�	����'�O0R�H뼚�K�����i�Wq�p��d�ڋ��Ϋ�x����y������nY5p+f�H��  ,�ʘUƬ2f�1��Ye�*[V��V��jx؏����e�66a?R�վ|�%>�k��_�w���{����\K�a?RsƷ#5�e���~7p˪�[1c�XGn���
����1�[e�Ǭn����U�p��V��1�[e�Ǭn���֝�c~��Uk^���.��X�E0�����RaМ��͠����[�7�`8cx�����#�W�Oop˪VU��/��-�nŌ�[i�V�n��[Vu�-��Ye�*cV�ʘUƬ2f�1��Y�j�����r��Ob�$a���[@�
W��+\1V�b�p�X኱�c�+
W%ߋn���S�����<N��c&i��K���Ϲ��k���.�~\�.��,PJ���z�g/1�B��0�+ܲj�X��e����1p�#�pO�
���6"���:͆P�6|��Ӡ�m�4h�%[.�s���_�M�)�񭐯=KW-h�t�t����3�'�^0<bx���!�7�%���~'�*a1CXG�aA@�UƬ2f�1��Ye�*cV�ʘUƬ2fU�qO�����ԥc��^���5`����L����*�L��u�W�GzK�gr���3�ܒzpK�g2�%�3���홆\n��LC.�T{�!�[�=Ӑ�-͞i��d�W>�jY9:Q�^��o�3�U���V1:�[��o�3�U���V1:���Xg��`;��� �Ǭ���8fu?�v�1���3�Yݫ�g��Ww�8fu��q˪Vf�Ju��[Vu|���t�cU"�5G�����z)k�k�cp�G�%ݛ�ؖ�ׇ��0Q��+M�����?�c��:�����u|d��֬���r	���ۮ�"��W��W�.���<�u�d4��ЊA��gU��"������w�w�3���z�U_��	�3��^!�6���-���;aV	��:��  ,¬2f�1��Ye�*cV�ʘUƬ2f�1�X%�W��_�S��J
&{�Nc۔�\�&'�4(y�p/��ť�����aa�Dٖ����>|�$����6���&4�s/��";��~Tou�7xR�>��>U�Iy�I����/=�3�i�4���V��G�)�6�J�/p�m(����D_�������=��v�Qe�}Ʒ��ߖ�g|[���m�~Ʒ��ߖ�g|[��}�}�1��V��cV���Ǭ�[�3�Yݷ�g��o��8fu�j�q���>�U%Gvܲj��U���eU������W򻝰��2�?x�WH.�v���3�7��OE���Ю����G������C��.k;V�1x7 h�6���d��˸}�����|��g�O �A��|4x�N��W�'�_�����-�oŏŃ�IV<X�oŃŃ~�ˠ_�2�A��e�/�~�ˠ_���)>c�$6��?-�GJ����xu������O��_�ˮ�%����������������6����x}>��o���D����+'Y�Ĝ�ʏ{�����(Mݟ��[VRk����N>|�vU�q�-v��}�.j;��3�߇��g��{�ȸBIX�y9��&k����_}űvˎ��z����s�m�EO�i9SF9��r���0�O��F���޴�q���x=�+R-~�K���x��Έ�.� j{n��?|���G\�n��6i�s��\[e�{��{�C�$N��i&������!j�/���_hC7���.l#�{&!�?Uƞ��])|�������U^���[f�}�j�#�P켌�Tu��	�������NR�"���=��-��:-4(�S(��@˴u�����������y�_      �      x����v���-|�<����?ͬ��W�δu`H����X�ږ�!ɝ����� "Hdg��%�XQ��9��y�7��E��]�7ח�7��'������;~������!��m�_?�?���/�g��Y�&?b�����Szy���	�~=�;?�lq3pg^�g��/��"�c����$˼�F[�4�c��������[*����}�'��c������[��,=Ň��Y������n>0�=�vy����/�����������I�|_~|9�ʮ��������K��%S��΄��I�3�9��g.	eC��(��L��)_
c���U��EL<�X��(���06��󊘲������0��?Nn�����|������c�:�.3��t�y=$��z~w3"��/�ie�~a���e�v���6{�I��ïo/�|{~yUZ�<��ʷM���>p�A�	c�'�5��\�ߞH����Y��]��f���|z�ȯ>�s���ӫ������S��h�1����;�^��nǴ��P����_>�Vx�b����5�g�x~y�W��{�&J����ѿ�������Nq�*��Y��q��b��� �Wx�c���aL�9*�wUbe�e)*\�����dY��1�9i*�V�=�e���/����W�|�gן�W�+:1�<;6�۳1��\1m|#���/�n�Rh���hT-pg�U���!4%���[�Ň����p��^Rcd��� Ą{ѓچ���(aօ�%��ȺOr��<9J/o�C��ʇQ��0K���k�a�ƟF��� ���k�p�l�C�nr������2����S-כ��9�O�4Qz�%�&��~w=��x�5{7wPF��s'�s�Yn��><ŗ�j��_9���{�]wP�t��T��Aq��R9螲�yؕ�{	o%��Se&�y��dq~����8_�g�'�;M<��Nt���c����[�L�D���>��d}�½�T��_ؐJZ�w.�鷥�z]Z��������i\--S�&�3�k���u��%:g���kh]����?Un�}���N/N���x.��?�
�����0��w��k�0����{�����Ãmx���%�Jp"<}��}/e3dF�� ����>�oʆ5e$��\,�f���K�Y��1�ʹ�F�d�ee�,}JQY��K�}���<��Օ��)�S�S�7B�ʗ���Ʋ��b
������|zz�%η+`~ ��`w=�;Ѳ��[)�/0�k�Ͼ��o�U4/���"�A>$�M ���r���R�����f3U���GRɁU+̉r��,��X+*S
F�2T����Y���Y~prus2�ͧ����������+�>�)�U�\
��^��Q����]ሀ�!��L�o�|����J$�?0��g6�~���v���_����KAB�����e8�,g�^�R�R�T�"p�B��x~��_�2���M�	�|�;�vxr;�l_|7� ���ۮu����vؽ���NFd��h�����2��+%`0m��%|���.�'�j/���F-����������6?�S.S�K��i'�����ܳ�%q���("�ei�-���[|���,��Q�JH��Yѧ�P�|z��ͯ yϧW'�/C/�G���ݍ�K����Ao�]?Τ�3 �|+@]�<9�팕Lf��!|}y~L��������$e҂�����ĺ��PC�;q
<�Rp��..��P ث�B%,��G��w2]���0&�X���`.��4\�3R�'<�]���3?����/.����S~A"�]Ct'�\9]�����p�E�ޏw����1Bqٗ�&K��{�At��Ϸoa?�"k��(a3Հ��f𪎂�w	N�pR��O�_� �T����Յ� l80Pt𐹅C,&Y!*�sa+T�`zd�7d�� R8X~yruvv�����E�*�_ዕ`�sM��� @�()�d_���z~7e��ȉ�@*#�; R��$,���c %�����	�a`G�D���������wtCa;y���_1��[8�ɓ�\�eQ��<&Y������e�g��G8Z��Xآ�-t�jzu�ߜ����y~y�Q (�A��tÐ����]�B�O�ѯ�M?�6!:�5�y�k����ۊ�|��s�lCⷞ�!��4 L�$ ����Q ���[�2%���i� ]L�s�`S:K��R�E=�B�cK�Ip��:]����g|)�_��b���󓏧��8�|^����I��~Gƀ�P�g�6x�|V�0����5<�u���;C����j�V5OlƝ�*&x&�h�Y�l�'5 �vq<�J������f�����Q����hIs�P�5k���{��3�kB���y~�����CU�������0ٻ��8�Ж"�0G�i�`�1h o��3(�h+b�V��1���|�G2&�J���
U��FP�M�R*�U=�&�C�����ɃE~~}�����f����'4y}1[0�������#m��I�#�ݗQF@��%(����(�7`s�	T����>�������k&.? �
�,�z؋ShSʉ1�a�����n�'dM��`*��+��UNF��L��b�,�
i�Ѳ2)�i6��E	'�.z�����<�쇽^�O�Op�j$Z	 h��|0��]?�|�����b#��%>"7����b̫��JO�{ T�����۩�����P���Ƅ�����dY2S�	~�%��x�JK���T1�k�tOd:;�^�_:�?ρ��O������m뇲|~8˝�z;�p ��iAĆ�uG���1���H�WrמL�@�,V�e}��>=�\��}�%?0K��̀��u� �戦{�w�� b\ �(޺Lj�=�=���V��� gV�u��$�
����B���<UV�
?�V�d�}��);p����iO�_���ӹ�R_�H� �:�Ԡ�k�G���=_'��ަ �`���/�����>>L �(ǳ��'�_	F���:���@��"�'{W4���I22�f@�F�PdP3Ϭ���&��0W�����	>>�T���Ck�נ|2zU)	D�_{|OH���n��۫ch*D7���O��6t4��l�9l����'��ߏ�wg#�n�Q��su�1j/�"t�������&��?�p������e/$�}�!�(̄��i�m�Qe��|:?-n�j����8�5<�"�����Z�^/�>�i���{�۪CNh�d�=�N���"�?P� k$���>$_��p�֐������I��w"�S�n��㷔��y����ՍD�����p�"l��wr���ƖQ��4%5��7�X���j3������$��y�ܶ�����E�r݊0?E3 ���iM�K��
���(/��!J�:��y�$a� di�"⽄�{�7����@����.�������^��9�����濚�GMZs>n<�����:�~<���|H���k��mꈰ�����A�력�;K�`0�!+�)�� B���D!?V)�M!��eT�B(�F	��*���>qa��UdeU��U��,��V��yvy}|2������աĮFa6�~�oN.��ӛ��o����.�昤=��	��/���\<<>��xp��7�{-��,~�Ǥ^��:{�8%�J�`�q?��P�Ƿ������~ⶤ�8L�	P��:E�4'���Nz�Y�|W�����2o@��e�-��%�AdJer`�"x_����2[�9�)��>^C)���_����`qrr܈����I�4;W0�Ir���m5)�|,k�<��f#�D����ʬ������[ ��7��Ub�]�ÒD�4��;z_��[2�(%xx
��|,���GuJγckRU�B����,eO^&[�R6����$o��t~}UK.?�8�^�.n(�rx=��c�Vn-���D�����DW��q�49J�]a��h��&��� �}u�ե{jb̀�T�Yrij��.M��+��͸� �2z    �bD�)LRU����1DC4zI9Mi��<����ا+*�bS`�=;˲E,��,��RX��K�;�9�����c,(ƝA��V����ؘ��c���\�&�t�TM�U��t����v�Wt�����^/PQ$:!'jwߚ�l�,����VFh�*�� �𸔠���I�J��D&� ��pWW9ѓ���cг��Ή��"�������B�{��Q� �lh��}��P���C�j�q#$�o����������L�"]��x7x��X��V�"P�<���z|A���daAM�pt<U������6Eq+C��.E__P�]���D�j�}�~��W7�A�^����m���G��a�X��7�v����PF:��.m��T%��<�	�h�2�o�^��[z������6��X� �Y������nݣ�b�l��j�7ˤzF�7�㰦.�22B�ʤ��K[j����-�+�	VY�)�ԏ�I�Q�!����^-�<[�yprqrt3��G�Wp��G7��������ώyF���T"uG�j}�4l%��~��G9x��^�S�w��ʷ���{���lDS�ÀF��ൠ4�綗�,��oe:������M���q�eȗ_���"zeJEq	��
%Ӯ�L
��;�Jx����R��{��f�u��t�=���B%og������Kŷ9�����:01X����0� 6��fx%qu���ׯ��TN'J6�k g= j*�'V���I#��/�Ȅ�4�u-T&+��"M�e��A`��EU:y�1 oK*���JUA��	m]ey� P�K����{5������饶~�!r�`�Tq�׏6-��� ux����}z����kze�u�J�JEq��wcֹ��U5kw��Q,��S2�w�$4�/� 7L�M�(R���VW&0�
x��14W�'0��n$	��\Ϟ*��E7r/Q m�-zBr
Zl	�5׏�44gh�a�|�s�S$G �e/���u�����W�+<�A8
N�L�Z�*z3������i���.��Z~�bʪ�SPN��Ȁ?-g:&Q��W�
��S�U��,�r	N�';Ygi?A����ֳ�C���OP/��r{c�OV�u��t`s�m#=��XPM��\�Ƃ��,���~5����f��o"���	ߝy�r����t�b�]ZL��B�`�)l�
��u�U���}�w�+i����~.�j�� �,��#������5V�)l�T��׏��6g(�����[9PTm�oj��(��#�Z%<�4��5zwk��]bw��YMƫd�P��*n�y���)�,��NV��e��ep)h���D�\�_N?�6��xt�<�c|�z˕��`�����(n�3���sk�,3L0��÷�w���a�����P�B��N^���K��%/V�U���(��%�I�����*l
I���ŭ�lS��Hճ�4T?�����U�����˃��Ng�@*����Ns��^G�	!��f�����:C
��H?�{�I�{���
/���}�f�(�+�J]�f�y*6�m��z�(���A�*�R�b��s+�}G}\F���T��m�:MP�8�e8S�������a~<��;��/����dv�������T堷ՕuG����p�p\��"#�2{,�7<�'�_ȺV/6���C�u3X�A�z	�KP�2����0re4�
�H���` ,,���Eh#<*m�&9ȱ,!0	��S/#8�iIzۗ~|{uu}�����?������"����qFP#M�ș���p#%l���|zz.�Mb�;8�h��
ˇ�c�YA^���Dʝ23�IÌ��@ˌq�v�P� �LZX���DTE0LFU�X���VUT��'ևXXW�LFO�_�b�5�h_���z������Ӆ�z,l-�n��.l�O5�gP��J�3P�f���T(�`�^_�2�ֹ�>��K�u�V�ZGUtO��RY5EEw֘5�C��Ġm�Ԃb OUL�'})+�X�Y!pb1P+����J�
#C�+�4|�6Yk�ͧ7'G�C/�M�5vđ�s.���w�1i�B	��Ȇ+((��>.J+P��ח��T�O^�����r���QM�7��%p�����3	gS�X_��GFh����O�䎕U,� ��'^�z�Q����"^lS}�:��xLI�mZv�yv���l/��0�mKuG�������I��s��GiO�	����?���?����'h5qCq�����&��wq�l��������e�^E��Њ�1Ш��I�:[�_��]8S=�kO�X����P�����u�!6B�`�4W[�ew�8�����S�b�x"@������T0���K��j3Ѕnؚ���N���W[A������J�FQ�jō-4�\�4�+)�b&I;R�d��@= �1���?�-n�����ͣOO6�_�xK~x|��̘��T~)� ��
��,~w8��8O�[��׿��N0RIh���P<��?T���TG��@�E�'��'�@4�t��K�MuSP<6E����IFW�
�RQ�J	�`m�
�GXS����o�D�8�g���H�s�(�H��i����\�/�
�1�I��0Jf��S�=|[�M (M��&�E�F�0�$���
Y�3	���d\�P�Y�K�Z��Le�����
�0��њ��LO�\�ȯ����cr�+9����17c��4�8�p����#v�<��3����;{MM�/E�[Q��}��� �D����^�Խ�����"^��Ԯ�-����W��1�"2+�T�q:@��-3%^U��V�D�
0@�L
ڋ9��/�o�
������*�~jj���/�kl�~��8(���Ԇ�m�^{�mcm�B�@��(k�?��ƭ~�Y���Pާ��f��w���Dy�U#(5T��{D'���3<M�h� (��lV���r�J����Ãq.S��&��³@Mͪ��%+l�ꉏIs�zU���=g�5�[������6����B)g/��̀xZ���Lk{��v�1^���U�I}� �4����%����f�΀O��4��/���g��Ro0�=*盏f��W�N,�[Cn����<�0(�:�������\��hf���,A]�$�M��RT(A� ��$҃�_�2�F@�s���
%\����5���:>���aB�^?^�Ԝ��Yց�JRO~C�/���C�������A�J�C�w�<	\�Հ)z�G���Q�6V�ϲ@�N8A�n�D&�Q��6H_H*73,��ʴ�(�])c�Hc���-�-]X�2�?��Q�s���શ3h��׏��-��Z�c��(�5=g�~�o�5<����{��f���_v �bV#eB�����b����d�7LP�,�P�p�2B$I��YF�"�q�Z�/#���s��4�3�-LN�dB���O�j��u�OAEƲ?�{��Cf���h�ssp�;k�����N I�:բ̕��l/1����:�&~f���+_FK\O��lB[8fڔ]�	�^%��Z渮b�Ғ��d.���L�KQ�-$� !Ee$P�D�,�y/z_�T���ym-��@Vx������\?V(֞aEWf�~���:�9A}x�l#���Q�������cCBzG�xw��L���w��q}'8 ��e��R��F!/�h60NA�eUbJ��� �T1I��H�0��R�㯍�RWT���E,�qP�z�G�_no֪!�_�/O�����S�5�|����~,c�< �e�$e1TH�ӻ�ח�By��Ϸ���)�fu��r~�A4�kp#��űݹ=!�<�Y�__�� fa�,�j	�+�	)p_�Ҕ�����k�7���UQ�k}��U�ꋾ<Yiy�	a-��:�~\��~\̎�\�VkJ��_�s�6�iw�Xޡ=Ʊ�R�֖hŤwM$����1����U}��C�#�_�Q��	���[HI���Z,��Oo�������Y<?�+m��2�6���    ��Ԫ~Ӑ�|��84���.+m2`� e<��I��b��&s/9%�]���J�E\��U���hY����φ�� �>;��z;�����<??�yh�VR#	���ծ�i{Z{֨�/�s]�gY�a���@L��YqZ��(��@I�����Pu�eOs�$����7�5��
 �Vz�&��=�����0��S
��e	Xs� ��LAĶR��U���*�>�)�wD�K.[�A�d).o�����`�_L�;�tzuB�bF��i���,����	�������c���k�᡺����6�7������GZ�����I�Z�l�N��a%������N��0��N;�|�Xp^�����/u� Q��<�F�h(Ǐ���A�]�b�,M�4e�'p|�"�,��eS`�H��${`���v�t;61�OxJf�y~�u_�W���>qe�v�B�9�0������<F ̵.��խ�H ��׺�}�Ïpb��up�'X.���`kW����E>bw�wY�����͇�-�4+D�E�2c���\e5�.�� ���9��.J�s�[�[L�[�]O�-?������As��5�v('(�΄�f2;>��\/FF�g�����$\�)%��s|x�o�߿���.���&z����5��>(N1G���\1���9��Ќ�)'�s^�*��mE��Q+lzR 즀��X�J:A�t�����E�w݂\�����{�x>=��~�ӓ���D����dq3=�ץ�w��f|{�T0W����A�cu��1^���ܖ�7�=a�W��g�§
�o����%��Hk�)Ȉ�:����wk]��n�r�i ĚF d�Rg�X�󜻬T���aф����(�i]0�4�UT�`i���z	`=�	&�'P�]� [��bJ�:M��e~|�R������F	�s�{����ّ�Ҏ8c����l�tG�M�n�1���l8c�bA��)>���B����{����j/�zVm�S�g6���`��び��:%��ş�nR���A��;�C	�h��H�d*��M�M§���«������p���¼����&�gG���*/)��0��*+�#�"��c`^W�Yϧ����Q�sx('�,_�@�]�R�:|E�55�zM�U�5���������js��d�)Y�"�)���VrQD�!w�� d��t�N40��$ʨ{{��=���]��$@�֊���	�5<���~,��<?�}<R�cCl�jK@l��|"9�}�'���Y*~H����IE�:�w�Q���%M��@5����X�2�p���*	���,���	x�*{s4t���r�����%u�.�_̏�O
z�]|4H�j�8>8x��~�:�=���Ny����egޞ���H������z ���.��t�R;����z��a��Iቝf�V�@��0�-�ϸT��Fp��S/&Z�%A[�x48��@�R�j)a�+�c�Cd�-��*�R��/���e3|N0�/+]$/��?Og�#bkK%�1�r<#Ñ��z~'F�-�a�jM�j,�> ��:R�\~�{1BR�xW*>��n����;K���k�
O�qTd�%5�P�B��稦�d�)����+�"Lu�>�dɘ�rW
�@$�}����7�l	w/�i8���l~rrupq�����9�����@K���#�h� ���G�QP���f\ե�RtTN.�=���������y��}��P�dC۬�XK�	$��w�Xh�&�AŹ��Ȝ��5� Bz��*+J��2T`%ª�/[H�#5hr�QC���(M`����s�Ψ�o<;�^����{�q��{�f�f;t����b�!�?���`ȱ=j4��gt7R�Q�� ?��J`����Ǐ�/��/�7��;Lx=�_���s \��	g�f �v�L��՗hϼ�Щv�Bt�����?�,EA�����xY@K�Lɣ*dE�fj!�WS�����p
��`o���Ne�G��Km�ʘ��v~����ή����N��4zF�m*��G&H��x���hh?e� ;&E����O���or���N������@�Skr�$u�`��������g���n?ܼU.�I?��%,�q�+a�a7Je�P��6X��� }*�	foL\T:0��- ݜ�`�i>x�,���W����-o��ӚW��M���K���l��b7|"G�������c�1��?؊�g
X<|�߽'�,���8�P��GNY����BT0�;;��'���'Ei9 ��N�}X�6ǲ:�pU��R8�=�upt}=;�Y���3R��S�у_Sr\#��{ڧl������G��[:X<�x�ў#���ϲ�a�Y���)�������a�;�rl����EM��r1Ĭ�|Z$�3U�s�:*^Y�c.U�zW������ a��e	����b2�c4vOӮ�"�IU��Q`��[�U����ԛ��D+��q�.��W!��)�%����z8(֮����ۣ��b�"�q��^�rO���hƗ��������� m)�5���ĆL�Z�,7�2mC%4D�yI�Ƒ���7����Ke6F	����0:����l�Qo�me���h�F�q/J_�4�Ė��){uNfG���KH�F'���O���N�;�@�9��}BX��(�l[�qs�h�hy�w�U\�}(���*+��On��������cx������k��c�K*�g,�ur����#;]�t�v��K����wڗ&�+�U%	��(xat�,
&C�\�8|S��� o����g�*���O���E.�x!ϯO���vvN��Lh�����:0:CS׼_��m�u *^;Z��-�����5{�L��]kBqȝnJ��f%>hZ���G�w3�VmUR�#�[PO�h��+��*.R��R�!��WԕH�i���ɪ��^���k[''7�+����?�n/ߣ~b��m�4��1)�l����K|��N�RN˼i�N~�����6#���9�C�4�]��fṙ���]��gs�:�̿ܮ��x%ϏO/�#�Xá�o���]?V�ܞaM7�����?����0;vr�ϧ��8���e>��]_�Ȩ�C�����d�ʋE݈,�2�=*�́�H|r�Dh�����<�:)C��Ȭ��*��T�e�L2J�($]�m&%k5�-���Uȯ�����y=��hm��f���l�t�4}FW�-�G��f��8���:\Һ�z�M&�]ȯ�DýT��R���	�
tD3٦��#w�H�U���Y@(K��`�zScPE�yj��FS/O�S���L� �"�$+�J�+� �9��=9 4���:������h�����")Ň�����z�0��}()����*+��!�C{�{�Y�;E����G�iu(�;��{��% ���L��|vs{�/�~��wy~uz#���JGd���[{���g�V�b��r�4��fo?���������w)h�(��QD�o�L��'(��^���)XHO� �2�a�O����&AhJC$��A����Y�+HI҆^���T`�I�W�eFQ�v����
ߜ��gus��xx4���o�NKG���-9��#��H-���}���>V'=�^���}�����������}�KS�h���'��冭�F��Q�@:/���R����р�2P�g˪�ee"��\���t�U�Vɸ�.1�A��N=[�YvFsm��9�9�ʳ󓋋�O�I���󏳏
�y�Ձ�Z�8\@�ߏ#��1ƭ�B��iЎVU�Bm�ݧ�ߟ�Qd�i��b��~��� �PL���h�].;�b�vO��'JH��/�0<�'�K��� ���x��h�T�+@f�D9ƴ��[��m��#F���H!V0|hyyMs��&{����l�_�'���a_�k�8ۉʑz�&=I���
������n1�q>M�Ql�F@c'�Pb�/�����=��-DE���*��R�O0���:���ͽS�ˏ��s�l�� ��� V[D�1�1k�|    [5��E��0��f�-�3t�+��� �Ni)2��:鮬pY�K�ݢ�vv��~��	�/E&�]���Kh��h2���,���	g���XiSp)|�CA�:�"1(�e٣�ڬh�ڧf2�y>�ohX������;˻����%̢�^��	Ӛ�m�:��Ύ�<O������O~H� D|�ן/�pR����%q�u��83D���6��4fg����
�EB,����?7�hY��b�J��X��=�(r�h��*#-�v���F�o:M�r@���/i��q�?��mӫv�|�W�x���BI�Gt>Y��m:�1�l��ܲ�8���dT��>_����à�����y�����o��U']�R��
^�B�`B��W�ֽ� �+icBA[�i�:�/����CҮR�pU�*���p�T��0��.�}ޓ�G���`{���u��2��;�ڳF+?����q�����0+��J��p+%�4��j�:��~-��Q�b"y���Ҭ?��A+;S��[)꿙�$ (8��^��G���4<@F릨�YD�g�p�}_��4F=2��Xp
�'���T��뫪女���%Ly��fq}�~�v��	62O�	?���@��]������=+t���g�m�v�����e_���7(پ����j�鮬? �t�&R���ף�UF���Z)��SAr�:SV���q�b }��b&��ZAĦ�X,�(lU�J͹�DI�X_r����=�w}ݦ+	�U?�Ύ��J�);���W=px؄�1�k�i7;��Rk-5�(�Չ�'�Ȑ�AY�^��)�bU|��I|z���=E��m�'�h�K8�`�$t���� ����а�������BDJN;���4��Ko̯oo��͗�R�VFҶ����� a$=�%v[�Lw�8�i��n�����t��~��a�e�Ka�+2@5�(J��ԗ���H|bv��~OQ��ɞ]zlE�l�i����%���2`�%ӥ���87�ic��\{�ؽ�.�s ������ӅVV��LK�z?�޻�~lQ��λ��4&p�*���sE��,QU�c(����ghO�N�^���2�~5+��6J�}�W�bC1�~��)`V#8(�L!�RzPE)U������1VT�[B���jT'V�������m}{��?� 7���Ǥ�Y~�yvLCGBD@��Rm�Q{��S�y���(%8?�X�����!�fE��C����Z�Iz7<�>S�7�p*
2�6Q���\��UP3�x�^G-m�����*>%/� a[��[R�ͦWW��gן����X�Lۥҽ�=����i�FR"^y�-��~�8�m��luZ綬����}x��K�f���j�B�͔��$�^��т�ݮ�=�<TF�ѮB��Oc%|	x#�ׁxh� E����=劊��Ik;Q8�����vr�8�Betg�@��/����L9ö(\�9��c������<�zm��`��&�<�����cx}M�W�����=Z�Hfٔ��D���:ݟ��v��6�v;{��6�G���Buh�E�}HQ�4)��ڥN.r�D)��<4`0%Z�(�����_�����lq�����ޜ.hy�v燻N�$�o�h�-��Ϡ �*_m�<���f�.�5<�oO�!�N�-�k7fCx��{K&�okB�d�f��<
!]T������պ2VE���M�[��)��Ko�PӀ��Jk��G��j��ޝM+������]���Lf}��;ǲ��$F�c�"�	�\~�iYZ�k+g�0>$8f�l%$��~wG3���3�"��e������u3P��[��~�P
6����~��7g�[qsf����[�O������X⿓?��Мv�Z9����"4��(�Ę�;���\!��&�S|�`6�N�P��zn�;�r�B�#UT��ef�����tIs��f��hS�iuAS?˨��-�вZ����?kh��R���K$~������`����>�;�W.�_
&x�`����	qu�_a.�J~�̔/��W�(�%𹢯�p�4�)���Z�(���<�����!�}̿�+�aN߇�|̧������#p��b��'W�׏R��+́[-�sǿ|��~�7H�=�!��2i�`�tw�]#�'���	.�&�����	�-X0�J	@#�*L#� �4 7��8����^�
m֮yFO1�:m2�:;�b�O'7+��8�-�fv{L���2�;L���#�X����VkO�@� 	Lԫq����-��ݐ�	��+��TD�!4Z�b�i����5��Ԑ�C�d��FW��XT*ESZ[V��b��P��� h/���g�AJ�����&�y�Ә�����_�xx5�-��� ��q8��ҹ�~�sc2�1P&Wd&ƔS�P@�2{�9�k�&8E���jb��N��rS�C}��ze (������"<��=�	XT�Z��S�R�B+�N]��*�=��L!���좇�[\��e:���:Ϗf3�Z;f=�w��s�1Z/��߹B��#k&�#�u����Z<�6jL$�0�u��4YM�N� �a�l&�ɝ��)q8g2��G���L+i��@,<u��ʳ���M�,������
}����bv�/nf�_.� �o!�1S�o�o]�7Sj�d��,~��ɹ>ϩ�.��l�Ьk�7`�5�5������?�~�������.����y�vsh�ݾuE�0�u�1�q���r��$����}�{i?D�����D�u�8�7�41r^�T�v3QT���@��A9�@:�+
�R���5��8�ڨ�Ud85�oQ�\����gX�w�[H����W�yOQ�x}���R��61�C���r��n�]�U ɤXJ���$�z��h=\p	��AS�Ї-�g��M/�~�K�!LEr��n�%*����cA4ǥ�n�h��6gh�m�k�n�b(�D��(���zN�8f�׾�pc"�rXNr��9�W�KSU�hEi��Ps��x�5�Ē��<��J%�����&/�hYf�T���_��\'��]�qx�����t�0R^EZ�$T{0��]?��=C���f����"OȌ6���,�&���i�u�V9H���.>�;uKH��0�Q1�	�V�J�� yE�R�n6�+X,X5�@�� � ܗkqN����?N�&���_�渡#c�	�(`7<������c�X��P�yX�j�nh�w�������R��˶7��Sm��F7h]l�Q�۽Ƿ�~�(S�`U%e)���#�*\lb��hDx EO�NF%`K<X��Y�1*[�Rrhq{�8?�t���� Q"�9������X���"[�m��V��1oi�!H�v��e�tc��S O��)�I��h_�J� K����鎭[O���Ν�A,{�2-��c�d�di��D��\�������*��a�"�JxJ�q��ѯ����IWN,�Ӏ������}�|~;˩{w{��HݬVߖ���'t�>Y-��C����~�)��|[�����)|/����<��¶�m��,��>�׌5�p��YCQ�!6��,���Z�L�T�����	��*�+��$�R@	-�`j*l��Ѫ���*(.��M�����?NL��a+�>4�B�aP�^?�|��Ļ5��^��iJ�tRҒ�������[��S6�\_K�CK��N�K���F�����t���6m�-��_�*h�eQ�T=��$�kLĄ^Gi���(mv��&�&H�R=;�.^ʯn�f��������t�n���^_�.	�o�xb`�����xKw�h3Ts���lk��7���5��������h޶����UC�R�eS>^/�s�X+�|$ؿ��Hm7)o����2�+�Vxf"����y,J�S?��e�'�W�YSL�S�����a�. �V7_�?�^z.���4��;>��m�[�ٜ�.`S�pJf�����^_���>nT����İA	�5��FB8�m���p��h��*��*�'����f.e
 �  �9T��T�yQ��2BFǔ�eA5`d�E����ݗ����ö)�l:�f��/����|zT>5�B���`����L�Č��A���D�#�Ț��1x��"����6�x�`�����*z��}�3��P=��R�k}�V�j6�{[������%nˁ�Å*+����jɬO��)�e|�eQw3��22�J�a
#t�`̃��N��@�_�K�l;8���g9UE]�m1�L�i����n�ȯ���_���xvF�uG���e�u�"���lq}����`��'�~�|��������\A�Mz�E�nQ_�띸LL�؉huQS��R�)��:It,�_g��im`2�P�P�>3'�����N�`k�W�w<�-s����A�ųõW�+�6�ki�ۆ�uG���j��V��Jn`JCI��ܼz_�O�.:�_��-�I��*�U���6��la�3Q"
͊�W@�|��#u�0W��� #�	LYR���/��{2���^�ΧubS:��F))���=��]����!��c����"�1�R�<�/�6�H��U�R>������@3}���������ٺ.@N�`�C�M�����P�x���]Ew׀�Li�(��(���������t���,]��nR��4P�+Xh?�#,���y��9X�ѿ��������[�F�����f���׏��kZ�H�Ė�Gf	d?����$<��|O�e�=	SX�[{	Ӯ��z�.Փ�w�j>�S��c���k,�h�Qx �h�(�+�k��0���ⴒ�ԨJ������0��g�'.<4�B�<;�~�.�������������Ab��1T_(�����n:"���w�w��TZ�,~/�}z	{n&�5=1��&8�L�nM�{��9!'j��fь�9�G���Yp�KNeˮ�LA����l�m��7���nZ.#�@bH��<$j�pEJp�U�Ҋ�@(]w���:e���9��w�����f��ӭ Du�Tl��4��^��B���p�������񡶻�����}��)�(`M����z9�
h����4���M�ԯř�iPCpnXے>j ���	eu��h�j�]�K)� ""	���Dk���� �Ԫ|������O��m$dh40ei�,lw�8L��p��8f�t�p@,S����=����2i��D�^Ѝ�zoWuQ�\	�H.&��S oΣ-�#t��!Fj{Ҁ6�y2���SιB���ؗ�̀FkQ�F�l�V��:+���5�w�nx�b{�xR�>6�[��4���UI"Oo�^�|�:��l�Vg���5͇*m�\S��P�,��-3�����c�$�He�\+0�1`Q/�pf��h�A���6��x V��p����`�ʾ��u�w�9�]%Ո��0 y����V�D���f8A{�ST������+�H�h�(�:h�����bd�$�|(冃:����Q�p)�5.*�ZJz�x\)�"�*���̉
�R�ρ�z��SG��;I�xz�����tOk�䫍e��������ᨎ����u���Ru
�<����~��������Uz��R�jC��������#��ؚ����#F;}a�yԂjDFu���%Y��(M���z+��[�Xz�g�U��˿&��_�fdT      �      x��\[s�8�~��
<m�ԑ( x�m)-�T�l����xcM9e�3'��|^Ȑ�lm�V6�(��������z$C)�R���Ь8|��L
v����%�E��#�<��{������|w`��a:��x,��ց���z�B��~�/ֿD�0F����s~��g,�2�3�ZT[^V�������r���u��U>���B(<:�X�A���`MG�C�^��y�$Ǯu(%���W�fӭ7��|�����t��|�[��fW�v���ˣ�H�*"y�Dy��J��<�I�y��i���P0�~����,8�n��S��,����*ߖ9���Ks�u6i��O;B8�0e�,���9�&�����_�p�Un�6_����%v��(�*'롻D�,�{y:��x}�^�P$0��ƶ?<?�_�׫���÷�o|�<ywX=�V/x��`�9���ئ�cq��sf�,���8�;~w(��g|qS������|s�����I:�l��3�-�lvW���q�6�����2���v�_o��fpw�?�ǚ�O�$IF*������H�1�Y��8Z=���WO�������i�w������n�\�]��GJ��VA����3G���o��U�hv�� �|;,w��E���o[c�����=x���A*cG}�z:e�Z�z����d�*�����Pf:�z�êE<hl��<moY���,��ǣu�:tʄ����M����:�=slz��
x�,���
&5����^���8A{1�A*&��~<!�( ZX�=w�{V��8Ў;K��7�~-�(���������n�Z��c V���DF(÷$�2/ʋo��$�҉o��c	Ӗ<�)�61E'���os�(䩆s2���Sn�{x��I����G�9D�ӱ��,�@�>�7#����&�l�O%����ͷ�)��$��<<�0>���9��'Y���Z�D�I+s���٣��`3��an#����..���8@����x��^&`k9�i�e��s�2!A=#T��ć\�j�i�Kw��[誵�U^�ΗP�"�ۀh��/�e��lC�`��=Z��/-_�a]�[^}�ز�۝Q����ʱ�ק�J�f�8�̘��w��V�&p�X��_�6db�z��И��}�VG6W��Gٹ ��{� ��v��}Y�|����U�CD�mg�d
\qB ����7�[l'��m���w6D`������DľJ�)�ͼ�	ߡ:�P��E�&\i�4^W"/pr �maN���	W�����I�	��eDX���;¡�k&i��<�Pp��٠b�^kV�'�܀5�G�R�d*���o�YN?��ǘ��gixxH�C9ƪ"s9�����qk��ݵ���6^�,�m00!DI�̳���J3e9-����>����p��<=>}�}�x��x����������5")���	��?���7�i�c����J��TBR��J��?��ڑ4fʋ}��>�8�`�[�֔ f5��K���0�y X9 ��[��nr6�Yh�)�q2��� o�fST�X��ӯ\1(QJ�0���r�V�LY�v޲���Lޖ�P��lE�c�'���cfï�EU~�p5'�+�y�O�Q���c��!w:��i��tĩ���2����#���ۜ��p�L��P�C��vxS�ZVb1��������v�3�3B�З�)���)}Qp��]�0�5�[P�ݺc$��d�꒠x�-(�t D��1��E�P-x�T�K�����l�t��N�w����L^1��5��{�8�>irH�i�� $~ٿ<ԭ7�we��"����t#q#Ŕ��&�1vS!"���K$���m���:��a��-D:���$�'�E�FS�E!��tB,���Y�Y`P��(Ch<�|��_�A��[�2�0ᛖw�"7�iF���j�ޭ)3���5��uI���3�^��Rѽua�uw�^�GȬMZ:�h
r8��Y$/�:ɀ/����Y\&]$TzA��� ɤG�F	��Ƿ|VU<�����!��ߋ�ݹ!JP9 B'�-���K-wl�nK-L�R���A�(eQt��"vSm��ɸ���~��wL):Dj0���A�(c�e �'F���n�@�8�$2P�Ո[�Y{��3�a,�M0��z�pE�tNt�{8��"
�w�[K,r� ;X��s!�C��*H�|3��ճ�&II�Ud~of2t��ԧ#}Fx�8�y�U�(�49���g|]\O�H���r���V̂alj$k�F�H)s�C��[� ���b�䝪HB�Ky�Z��J�2J��B����X�?��d$t�?bӘUX�a�Y�� Jq��;�wKr��u����*�G�n�����n�zV���H�Ä{�z4悢�����(�Y|Bi!��A��AD�b�6GJiy�Ҳԗ�i���1�w��֐�,�0M�ɻpL�HS"�#�=� �&��v�ȇݫ�s:�6���vBJ7��LT1� R�+��H��F����eY��Ps�t��'-�q%9�z`�P2�^:"U��"Mb�O�5�系��`o��6N[�!m	�"Dz3h�˘�Pv��S��@�A�� x~FN�P��o���/���́*��Ѣ��@��̗�8ʎC���q)d�G����*�����j�$7� O�[,�Nދ�p�-�G�i��mDz*�)U���T���A�X2���l����5�f��P��*��$j�6ސ�bMuZ�2 �Wڄ�iV�d&3V��Q��������A���H�Ь�"v�;X��06�@_=Q����"t��bn���E����Y��rSH�����c�j�&d2������SF"\$[CMņAY,���	���͔�^���!�b�Ú��D,�i���C��i�t�Xw�s��_^�7O���-�}=��龙zL����?�7���-���T��XS&��*'a�5�-�p��:U�"a P�x�⾒5C.��S�jEU �b�6��=��WqH;-��"�]hmjo�-c�c�tv�!eӑ8%W�e㉧������ �]�1�-������6���:dz�F�چJ(jl�qzj�%��Ӣ�F���"�JYT�c7�C/��V�z�/��Nf�V��ҕ�UyI.._�b���HZ���w�mؾ�����!��y�G��W:b�ۯ���(������C-h�!��\�m��,�H(�J$���8��]�vk�H5�M��'N8�[���+�9i��8����4	�Ԡ�]�cо�f�0��<�5b�+�`"�ଂ��ʯ��oD\�B��I ����1�q/e�Ŵ���B������;_�0��@�f��TMn-��D��7"e�01dĴF�/�|M"�������/��v�Y	l�1Ÿ�5�}��o�M7!���A'�����L<A&q�$,N<Hj����PA�2mk��b1���>|���fnJ�$��֑b�wY�QG�P�X�y�!{,��ʬi<�(����Њ����)��]�}����D�8�kȴh���zj��T�kG y�/�V��d;��v뾘�H"�~E��7q�%����v�$�4Ej��龼`�& ����|�|_���|�D��gi2 �zx��>ܿ�U?��5�uH
ز'�$.��X���	[7�� y��s �T�k{}������=q�����)�PG,i� �@D>���qI,߶�`J&�#}���$f����z ���6j	`�r��&��k(rK���_��O���N|�dpq�}ԙ�J�ė�O��$a�=�A��v�8q')F:���_�T��L�頫fn����ehF,I�:T�ւ'�&)K|8��3�r���O?��5hb?���WP���k�������t��2ߴT��set�$�s�1߂׳(Ҕ�Bnj��7�X3��'��cͯ����?����G@�z�_�����-��`7ukz��{D�v;������z�9�w�w���Ea��ِ1g����"��� N?IK,��<��Շ�4��f����������hN �ڿ@瀒��M��G���I���:ПF,�����I����r �  X��{4�|�u7;.ڤ���X
$�tz��:�1�,�k^��ְ��OO�TE�Yp48�a0~u䷰��#�V�?<���|u ��xi�����K:RK�qB%5��&���hE���@cc�^��h��v������W:�N�2�sE*����>a�Qȓ$gX�7")���7�
��?,*3h�S	A�$�g���M7+h��9�
MƟ�̎���R'��?A��&�7��й��~=-���c��A<�C$� |0�h;k�@���n�L���%��脘[��Du�@�Yt�`���&�83"�zL�J�D�m���eË��wy���׋�)K-*qV�9Y��Se>�ȵFmјFV��zjZ��ٮ��9%!h��҈&@��?��:!�Xj����Q3�X�ܘ���I.�f�a��+O���ZP�ܷJ��e�#���E����.�',u����	.��4�6�2ݤȮ�"$5zj�y��-�$B�� ���ʡ�T�gA�>|{}��K�/f6$&h_��:\',��۴�\Tf˷��z������VKSO��9�,�,�pdY�|}����L����/fnz��g�\a0xR??}��@�9������F|1z��f��PTӈj��A�`G�X�'�XL]��+r��?��gZ<^la���c*�U�̉�#M.X�8��T8��*� K���ܔ�of��j��]s9��M��F��l��͕9!�,{w��>i&nyE�N4��w��d�`R����י�Y²�=1hj�4����L��\Ø}:p�8�Xv�"Ů��>d���n�uQ,��tBX3Z�t�eW�+#��"�4f?��c����yA�2szB��"��@�]S�Ck�5�̽����%�5���qkV}Ww�4¢l�88�����,�e6�̦�j��tr}yU+M��'>!��4�h��,#)���&�@c��YE��Ӌ�b��F���o ���J�e��:�4f�_�t����gIF���]Y1:�~�/灂�`	Z#���ɩ� |z��	��?!��� �ȡ(|*���7��h��&U����D3�өծ�ͯ@=���lN���D����4�$b��;�-SX��ǿ�]�Ks����qs�G��@I��3w�?e�����U��;�U�GZ���r%�֐}���\m����P�5nߍyǒ���v��4R��g�N}�_�
P��1on=uW��D������T��Bj������G��/��y�������r�D	��t8>��<����i���7ӡA}��؁�,J/2�S�&A�A�zΛy��
kV���4�A�����3���B�!������8Y�L��>\ǝT�`7���T�^ϔfN(�
��<�dpE����1H��d2�Ni*0.�v��	o�A����~�ޡ�0v��	��Or����(
Ǩ����p�vz�W͕�m�n�
3�����̍w"a¾�����-\G����3�h�)�y[{��x�I �� �灢>Z��\ ��B����8���!�S%��9U�!������ڦ*-B��s���}���p�3%R U��O��s%��7E�R��Ņ{��}��ͅ�~2J$b$�f�sF#�Sp;��uVQ�x3�>�z�e����pYSl�,����mq!���I�ԌC��� �E��h����Ǿjv�Ȕ�+��d�͒y���|3�H�$��ػɳhlҙ4�*��j���"��h��7�-_�%}n�oI��`K�����S���4ɥDr�#)�L1�@�f�۱�I9ooU��Pܿ֏������2����̍(����b������M~�ݒP0$:���~�ݾ��a]L�ɦo���"�Ϧ�A�пǖ,��E��޻��^ ������cȪ?�^����Ǳ~��z�(�q�3��r�{�a�Tf
�{3�3R"L���E�5Q���QȺ�i��,d��zKt�y��@�N�QK���	�z���B���;�#n�L��/���_�ϷE���4���(�;�)�`¾�v�=hPg�w��� ����\��b3���g�����v�_�׿
g������"C+�?��2�:0�LYS�(/w4
C�üh
����梣�)�Ѿ�po�	E�X^^�*�7-n������(H$��z�{Q�	�>�g 飻X�M;,���}��}��@׮�z�p�,)��{U;���	����曇��������S��d8����;��)��������r���/���r�      �   W	  x���Ko����O1���,�ٷ} ��1��s�EPk!�e��	�O�*��A���M)�/�]��ެ���{�]�}�>�>��\��t:?�����t>�&}��Hv2n�Q�L�i?Y}��R�]���_ο_�������ܑhb���F������%���o�뛇�Z��Ð���$SZH�p$?9?y�bO.k('5I%��x��V7n�,_�ɑ2�v�A�o��X�̝��B'���-H������������KQV 3Y�+���N�2��Kד��;�d�KYC�����n����[9�R�P#�~x��C�kEɽ��VZ�J�5ҋ�+k?�~�����������w�ϧ/͍1�geBz	�5l`�,֓mI���Y7Y˲�؛�����������ۧ��ۧ��I�}���S���~�k�!E��0Q��Uƃ@`bCX[�	���&�I��jv�DrC�0�1��҉��f"�(�%�V����Kx�?I�` ��^vӉ��"+V`,Z�mx���-W~{ww:��66B �5�PK4� � й
tn��Z�0i�y�����)#ͩ�����Y�$E0> Bh���k'<B��,'�QihK�!������?�����/���d7^��ऊ��LȜ�r^������iN�9�p.�����;9��
�O��2�����Ot�a�*��x��	�ix��4��f��!��p�!`�:��ned)+&�LB[�������	=�x�LC����RV�e��z���KWmzr웹�E��a#Z�b瘣$Z��2&6��e���R
�xqr�<Tj +�� �C w] ��k��U��w]J}.�9�4��n�����\JϖI E�ȬdIw�!���0���Ř`,�� ���!t/g�73����!�$4J�R E��WI�Ih�D�=;_y6�>8�+��L8!_9!�P���*h����=0�$��go9�CY �?8�p=�.Be'�I��0�0�"T:@����<�N���*K
�,ɘb�\T�	D�P%aig�t�X�|���P�dX��)kﻅg�aib��@9�[��)�'�	�Me'ai's'���@e&�5�|��,_�A
V�Ir����@����F�m�v<�-`�1�iv��	��r��$�='v��Oin��b�%.Y#��T]yʐPb؞C@�ʯ�P���������?N�*P���9e����-��(e�I�M�*��4�3��l����\y�l!��/�dѻV�U��)Δ�`Y���u��O����M�]���_�T�da�2DX�����1s�.]�,���q��=�1@tM�����'H��9�Z�$����QZ�ZP���!@/��M�X��9m
�(i�8���m��(h�^��u�q�N�/���(��j�Qk��;Wug�����`l[�΍�E�w�;D�(�&�-^fA/�EeRw�#.[�l7�����wp����#G��N�Ե^�l��3�{�LYQ�}����R��{y 9�}��ű�}�"JI+���o�h�B�a��z��ז;g���h�2#�|}�Rb&kaM�b��J��$.�F䷔fdC�w0�Ҟ��H�M�`�)Ɔ�ᬇy0H�_� h��_�G|��4�����"�_H/L��H/�O�K$y �Ay:�,�2����e�Δ�$��er?�mfB���2W#.t3!��v�<v2MiDTsAF{y1��Y�f��f���g'�Tp���B5����+1>��@7��j���8�(�pu�Y��N a;�F���62BO���~�oک�'�2�m���$��>$^��ݒ�Z�?sJa�L��Rw�[���p�Q��5�i�{��{�[�f�T�ds)�Ve;��%遱�c�qrA����&f/������P�m�sub��$�"��Qr��Q`���V��3/�v6:���ڵ(�zP�t�u�~W�u<؟j%������㯨�`z+�Ih?��PDS���}�E �͢Y���F���h׶�gF�p����>�-��H%�X�f #.oO�8\R6�8Iu�D./\�%�t�$���:\&?lPց�����oè�f9Y�f �4O���
+����#�X�L	ST=�R�Y��3�Z���ET� ����S���a<W8����d���iiɴ���P����,�5��*��d�?����a��'�!�r�o��tr������[;��V�hu2�✄O�sY4�N�g*�~�raDy�`o'���4��oC��gLN�YЄ�sHpg�2�B_��R��O���y634IE�� d	��ȁ�yf@�?��[W<Y��u\e��fi6�(�/��گ.����YQ/�T�@�O��B迵��
O��j>V��z���� �ؗ�      p   w  x��Y�n7��~�}������j�~�%�n� 
�R�[���? o�!w��h���k����9s��ɼ�r��͔?R2�]L��}]ޮ��y5r�a<Qɑđ�9�BR�Jx	�e@h5��V#��<-�#dϓ�F�K���o>�����O�����77w�w��z��	����u��e�{��>\~��w#�
��^�q䜿
�mߌ@�����Y��uJm7�1�r��"�g쇧/_�/�l<��?�f�ة����|����?�^(�,����˛�v=ZX?�n?��|�c��)
^�R���X 	4h�I5ޑ7CJ
d�2(������'�o��*��^>lv��Ύ��� z�J�]C�^��쬾E���������wB̤m���V5����i^{���5�֢��?@ c8����Nԩ��gcQ���l��Em�#��"�d:� d�T�ՠ��m>�ͭ���˧����䊷2����G�='���\I޵�FXc!shbЯ�
$�������V��8�3�}��]��Q�p�tI`%�>p�Ba�\Ű��k�#�ό�|C� ��H�#��A�r�xT&D�J���Y���@�;m'c���o���r��^�M��5�V���F.�[6-�4�6����ǵ!{V6�@L��T�v=������� ��-f��?s41�>f�Y�j�ƵJ�-8/���c�^ԩG��&l���-<*�A�hV�����ȿ�Е��[�O�i3wܔꆆ�3VJvI��9	�	q�z��ب��Jz<��L�8lӽ!�KR�֐�ǓKn�)�]X(-PrY�3+e�CCl���D%���=�6I�.�ho4u�8�D\=`�<��n��:������$�y8�}�'e��L6���rD0�9�!'U��ǎ�7��t'y������@6đ�����jU?84/_�]�W���>=�����!r�W$� Ʈ����֐+,�*4w����������A0�cDgj�e�ۃ9{�>��-���ٯ������/g������j6�8I���o��%n;uA3�mQ'_�<��* *�yo�y�;�J��t6�1�L����d���䜴>�X�*܁R�+U��zMp+�8��6�M+��7ܫ�������c��:��aOz�8uJ]�|c�����Zڐ������#G����S�,�A�a��{��s�ټ�������k!Dz��3|[��j%��a�I�����_�r`/�BqG��YP��p�pH=7w7wQ1C3��م�1�ZXp@��\Շ1����Ƈ���I���v`��۳�+�����(�����FX����6y�r��L�H�LH!L;�Tև;+�I��.-9�B��{���_���e�M�o	 (:��Y�?��TDF��U�čl��Żg%��\C�|5�x�ی�v�}5@Vka�v�rK������XlL.���s�e�v(t'�x��e�}73A;�>;מP1A]�rb���;@�p'��,�"�p���=�W'����"�H�������	 �ygȱ.��'��?�at�Qt�H�ݧ�7��H���:h�Vr[4I�~+#\�\]]��h9��Pۦ�|\�\�}�	˧���l���i���&�&�/m˅@^��z�
v����n����$����ǟ~�\^G�K�.esnȇ.�KD�cl��?58:�Nn-�Mvpe�M�%���QJJ78�.g�A�������҅#9b�jy��Zh�T<���mǜ���<��n�ߖ����e����v�ވH_b�.}&���&�~i�����Y4�P���j
�4Ν"8�%d�A���5��Kn0j������:��H�X˂�8�ۜ54Ή��'��l�sz(�Vs\V��X������~�ϧ&�6c�뺌�XU�t̝;F7�ɂ�By�Qe���Ph�`�s���M���j =w	��"ឱ"o��9Jb��OAa׋�׳�I
+��L{E�U�1;K;x��!��d�׊]�\N>F�4�?v�Į�ח��p��Y>o^?����b#�=�+�q$�Y�z{�E�ub]c�����/\�����x�G o�P����~I��~�/��,`;��}p�����]�+
k}������������      q   �  x���Mo�0���q#����ˊ�`X{��Ê�ȚF���i]��c�GC�c�"E֕8έ��z�nu�������%G������0WpJ���ѲL+���۟�HҾ���LR�J)L��~��d�#-�^���۫���dWARC���PWC�J.�`��|�����>��I���L� z+f�1��,��$�T��|Z�����.��@���c�4_T��t������i\�no�|=x����zu�H�CO�@]����"����<iqp&��9xS�)�t�[2�ս�R�̲~�fb���9y[\b0����H1<�wu�C��+~b���(�i�6�80S��hF{����`�F���s�{����)�땁;4��/øO�2ٚ�)9�̲�~��u֦��6e*�����?�exfM��~�4gzk
��B�~��3���;0�:�5M]��d���_4M�uN��      s   U   x�+H�K��K�O,�O�����*\|�
rI�y�ȲN@>WAbf
gpirrjqqZiNN�BAbenj^�BI��KjbNjW� I�#=      t   j   x�U�1�P�9>L���ܥsU�?��b|r,+4���]�G�ü�ՙ�c�E#�l\� )%薭��|i�h�GS��U���fk>�&�ϋ�~ ��:E�      u   6  x����N1��g��/���/C�(�-!U�&4�D	y��z����R�\���?c�o�
��q����9�Z
���E������㦾~YԌ1qr��9!����i�K@Lv���,	H<�iT�|y��2m$�I��/1X�� ��"�|Ju:�h�%�Ғ4+��MUEx  �gSv��ͥ,�t��MRv5g�X�Ad�T��T��0=���q�>���xfA�6qz����zGllIxX-���ݗ��=o�|�Z�wE^�x_�J��&��F�/�"��)b=���T�H	��,!��;�HX�Y�J���tV��?�v��A㨼�R���	U��Ҟ��H� 3J(.����x�ݘ��[Р�bD���~�d�J��H&�L�<<%�(m�����j�]�VO�׎�c���3����rYX}�7�#���C*s'R[��, t�kߚ�3Ω�$��|��t��}3��C��a�`
6����܊�Y�����&	"y��a�.�}\<8��t3F"V�����"�gySX���̎-�1y<�FÏ�ۮ�q�cۥFk��\��f:þ�q����q�r]�X�m\�&�8z�\*���C�w���z�Z֎K:��-��F��lhz;5���cO�O��|���=��<� �d7�T��T2�����Ψs�(�Ry#P����;u�XÁ���QP���Q�=�}z� �����DQ��7wƚ(��������������J֧{�3*���ƪ�P�>�����u�S��X8莓���9�M�5�%:W$^t>����| WG��ۯUU�}w��      z      x��}Ysɵ�3�+�����@P��,�uc":���ɖD�R�x���|Y[&* u���V�����9��SZ7X�/���`|P���~]�����nY�����p���煲�؁aRh>�<��>��2��Ż٤�����/ߞW��A����q������ɷL����R���Y;�n0��֓���|#���럸]�b]�n��py7-����W\h�F30����/F{#�����tMO[�&�����.f�G\9�:��[a�H����/���nr=nv��d:*W5����S�U��y�KnF�H�d�<��)8������L�U h�����)������O����vĸ5��8E�X4�7�j{�����kz���N�������щ���j7�Fg��T�e�pY��*�ӻ����;�F[��X<�#j.�1�T�@5�U)\��-ng�Z�6�VF��c�
���菄腫S����.6��lX�մ���Z��SN��vu3�a�_�s����Ո��Z�jR�&6�$��ڢ�gdS��d�j���W�2N{)؈k˘��iS��թ��.��b6/�)��Q�J'{N�����4�L��I�J��v���+�"u��l\�AN�bIKkI�����-u�\��2��Ct-�&�R���j7�|BGY�@r�L�?���?�(�Ȑ�,Hz�>%#�$�^ul�1���06����,ew�Z��<��tݧ��#v�7�u���Jod0�Y-K��1��=L,���>x)�����g�IAVhzW��:d�E�!)��q�|�e"��2>�#����n�s|_�6sB4 5� �d������?*�%�#�4S�G�}JD�%�i����w�E8�bI�3+Tr%��=�>��'AVvd�3�+	H�ȷd��L�z[�KΔƐ���o_j-�J���W��b��%3�h22MY�$�ɧ4����-�Xo�W�'�*�������^���	�g�}JG>��y�Q%kqQ'�hON�M�U�U|H�]�K,���׎MYȻ��Hi�=�D��( �!�\]rNn��:�L(���|�F��?�O/����۷R:='5�3z�����N|�k���u���<q�1��}T�F�������_/;����"��׽���~��"k�-��)���6�ըX�JXJ{� �|í��Y˾���Z,��H+��^J=d2}�*&Rlq,t;�7���:ˌ���xv I�KI���םU]�d�("��2R�(B��y�G�!<لl���w�j	�D'�e�tG�U��e��� oH�儣�։�Wɏaͪ��rw��Hr	��y�:Eג�����4���NT��c^s�03��`~d���HM��D�XF�U�S��e��͙s����$�a#+X�*V�lS�-���|�7��?>��4#�.��*{��Iq�i)�H(�%��]
��y� ����n�ꢵD�`,���	<*���E�!Wd�/������-�U�B"������6׫ɺ��6�u�O�	���8(��c鍬a4o2�EW���d�6>�Fq� �AX|��y8��u�<�����x|�㡌�FʁTF��Ҏ=����%�t
&����o���V�mg�����ݚ>E"��`�y�|�2(�8�W� �2q�8�̰��T�D���7�-��#���^�C|bp������ד�u���5!#�z�a�����QJw��
�La�0%��	�=&�E�iG*�{}��4��RX��H�����HD���Β~Mf�|�)E/a�G�i���cZ�_��:Zw�f�DS�1.<��&�2�k �)��H�G�Пv�{Ҧ_f���Վ�[���]�ax��Y��D�+��^Q�8r�frkF�~�k0n׳�ޫ�}��M�a�!K�>��IT�j��tY��!�̌��T��5��xJB<"������s�����/��.#c��%��D�?Ѻ�%RR!v)��{�aK*�(�r�h�h��Ћ/8�/�Ūx_�IV.�|���8����j�WR�8bD�&�Bt�"e!Ѳ��z>�ULJU�^���Db�H����k�?#��8D�`�)��:+�8ڔ�DKI��>=}�YQ��������6���]������c7��� ͼ}����jgO�b��h�h�_mv��Ȳ�,J9E�k �y�|�  ����	)��'����LJ�3��2�v��D)/I�1#s`��	f�I��w�zI�qU,�K	�
�gR;X���|Q������㧜�戉�!r�<�VhV:))1�����xVysR���u-�������>�?9F�Б;���v�:Z��)#���6�~~��~��?������\����ܓ�:Qi����w�Px{���
ХE��5E^z@�	�򶸚�'�2�h�jSl���)���/�⨪��x�㹓�:����[pp�%\bV=��L��r"V�R�h��~]��P^��Xx��ƕ��]�\����<��h�!#w��pe�W�嫼�uU�	WE�3�T�L�5�. sY�@�K��%�� ���d~>d�%q���+�)uɈ���?�������yޗ	F�)��䝎��~!c-��"S
��u^v+qܔ�d�b7��E�5�����b��^v&^y�q��鸝�f�B���T�
Nf�!]DJ�U.�s������j�
-.��ni�e�p�e�&V(k�0��"�Z�V�bQ��W��Y(��aСÏ9��dM�42e6�2�x���=����Ǌ6�*�����eC�ʲ_u���[���*���ZM�JE9�8Ԕ�=r�l΄�7��π�ɭ�$�&ov0�4�r)�<@�ۼ�J�ʓ����؋=�{|W�B>�"9)�ɚ�MM��v�W��<���Ͼ�z�8�j�FLҿ��e-A|�T�a*��m���2���x\�H�����\	��1�doP0N~�e�W�$�A&
I�Z};�f�
=�R��3^����!�W)�(q���YwNLҧ5F�Bњ����3D8*%�r�d�j#tBD��FL:��hC:cՕ�J�R�ȳw�sx�)�(u���0N��;/_߀ue`���jku�)���P&����I��i�(>��jՇ�����[F[�C9	{"g�v}�R:Q-������d��P%�'�H:2�9�	@k��������YP<7�Zh���e�$;&���J �[�髑�#�Vl$�����As)4�@���8���������y�u�D�z�� ��������K�5#o�2.�C��oO�y�N��lT�ABi,�w˘B���Gv� ��B�.�=�4K�i��������:,�D��yh�ÿi�]c=���wW��E�4Ia�W�m&-(������h8���i����F���E"'ܱ##����d�i�oXz��J�Hщ]]�N��ݬTW���6n\��ȏ�C6���<��}�d�M����%�.4�::�þ��JѩH&�>��}���ޫUVf�D{��#��Wf3pD{���n��f��=���lUӋ��}�rlA�֟�~	,�lo8Q9���m!��im>�,*��+z4Vu4v2A���q�ѹK-FL�0�K9B�Q�7S��Ӗﲋ�K�ii�_7��[�!C,*=�3CQ}�0�d�[�X�\���3�9���}8AR�>��3G�U1.���f����&�����5:͉ļ;,�5�LJ�%�I��`?��E�k��^HKi���;��_���>��6�?}&�A����pI!߷��h��4���B�N&����"c	��ݺ��hͤ<bZY�99���c��1\H6�������c?�U���.9���3�E�,��2ɸ��bx��m���p��#R���/b�x�ܺ�g1�ݧ�bZF�����'���!Z�<ǑNȎ�;��~[,������<���-�m��4��z	t��K��a�R}���lcT��o�END�0+��\3�)�'b얂���򰿚��I�ȴd4��˽� �z>-�>v����Q
��/_?w�2�.|�	"��{��)a4�	C8�[�ǝ��iɩX�g�a1������鬨,���    #��02~��少�ns��H:uM�j,�{���L�`����V�~\�����%����y= ʽ����~��\���%CJT*$��K]��o�}�x#��"���z�W�+ ��ra7�'���?u�����'9�ۡ`��{���U�}�<]�.�\LJm&��)b���(�rVa�B�9S |'��
tJ�<YyLd��ٔ�,�I#����5�PlW�^�?���l����Ճ[����HT�S��-�Mf���i-��5�2}���B������Aג1��� ���?��L�g�#��F�)�و��HlӞي��I2�����ǹ�{�"�ۺ0��Ъ/49
#���%"�)�(�*�����&��^T"�T�tř�e6�� ��S�@~M���<h[,k�Ucz3�W����;��sř"��ɘ��6%��=�{k<�I��S&�-��;��-�lSeG���ٺ�����B�C~����c4�1�>k"�q3݅dE�Ɂ:�0�4zD�1Jyғܻ���h�[]o��[.��W�-�0 @T�B{^��HY϶�����&M�]q!H�|���>v���a-�w-3�6Lhw�0
�FL�D�p��g[�?��� ���qx��y~�(�@&�x�!��o_o4��$�d%>{�~�?<���z��}&�_j3���չ��g[�#}��x5����bN/eUB&& �Lom����31ׁ��&s � �f��As��_.��Ҟki�q~��ʹ��Rh��Q,�ϑ`u�^C��)ȡ�hkJu.���!W���X�������k��]��Z�Q"�C��eMȦ�p�Y��p������<���\�n��t��k�����G؍g+�%)�nU�I�=q�@ì�<k6�[��	R:t-��n�@�����@�Ez$����j�W��rrg�S���I�3X�2r9���9�Y\ʋ��E
v��H}3�����ۇ}�����>έQ�;�ږ��mш H[	o8�����fw�k�����k��b��q�=#x�{�G =�oH�=&�X��v}G�7���
zʗ��K̹N��>\�ȗ��#^�X�|<c'��E�]�c�{��ǈh&�~:~
5����Z�D\ʘ.�w��n��x�D}�1ӟ���|6ie�!�*��v��)N����"{��ܧD�Z"�e����+3�ߓW([��6�� Ĝ�H�e_ΉBF�R���f�JQ�8$�xB2�mp���Tc$�R2G&L���/�����Af��[��;ħ�[ᯑs�V�2*��T��>��g=��q�K��*W{��/<��P;R�z�M���n>%V�#�^�i?<�@�\&�=������$܌��Á���t>�B�l�`�H�Oyշ�Z,g���z���Ҷ�������z��XY�A[�#y�,ϥ��$y�)���K��l��</(dmP|VO���]�l����1�O)Է�lU!�v�m�i��CGb)��#7l�w}L���o�sIf1Â�z���1M�'.j�F�"cn��.�R���?�r��o��v�(��Ow��sw��:+?�i
]�d�(����8�[��/�������[��V�]��amb-6����Z�p��l����;oe~u�)���A��z�����Fz�Tfl��'�-�g亣/�K/uh�'�YCY���b}K���l]6����#�=�}�k�������H;+E6���4K�V�(d�m�DWMAR`�F��z���q��x12pі0��w8b�x
�%�Pl���eqK�]y������K��;�Y�������c)Ɩ/��g������0h�� |U�5d���o�9H�3`�$@�U4�)��4o��R���ܖ�� R��~%v�����cW�>NQ��)L�cW)��7�;d��j0fL�'�*T�޳C�3�{��_]�􇟞�/�_�|:п-c��V��S1q�S�#Q&���T�t��eJ�«\E�|x؇T� >��ۇ���s�<��puw9OƋ:�,��P�����0�Ǉ�ǯ�/�><�[����J�}��iL�4-g^����u�fk����BI�]��+4����H��e�*�|6��4�+qu�9B>T3�>GԓIz�-wm�B�BA=���b��D%"~��|<G�B+Ad�`��87:����ܾ͹�|����Gp�#D)]��:�7'������)�(=zF��h����ԮY�`}��)�L��p���:���a͆7���i|�Z�>~>C�K*��U��v�^J�r�鈉"Iy�yJ�<�It��0�N����3U�[U�@�'���%���UL���wQG��d����Fc�EU��O׫�Z9��g:hʯ�^&��,T���f��}����)�s���5z1B'Ii/��f�S|���螢�hJi,�Q=��SF�"�:"_�^hPL��ô^�ۘ_�$)�����,��h�A���J	y�1�<}߼}��6�fshC��>��Bn_s�2s���b��>79�T)em޲6v|mg5N� ��a>����PG4�C���;�9]t����Y�/M+O9���M��F�d���2M�W2K�B2�8�Mԫ
���Ι*��NB��b<ec޲1Z ɐs��!�'��S�����-",&V���#X���%��G�X�Ḍ����n�B)������O�%$��S��;���v����)��Yi��Hɗ�仜m��U�_��6F#�mr觓�Q�� �J)&��,�Պ1'�u�p�L�$�G�?mϼ�0��y��<����mC��p��kM�s��9r'�yU�~�@�2�8��@�3y��"%c�"i���a�L}�h1�0�.9��Q�0
M�G�j�M���(���D�~".�b��Yn�يѣ-�ھ�>������a��u���.� 
S�#$�L��Ȉ�E4��E�������n���nb ��`�O�_Q�[]����\�47�xh
d\���4yytN��ԍ����p���&�mC���h	��SD/9X������]Q���鏏��l��p��|�ؔ�]Ȇ0�1��E��h�2�h���������k%��*�d	��V�OΞ>��An���� �21�^Y�Sf��)��8�{g���'��ď��ָp��l���30�y�%��@�1�w�1B�=@P�nEܩ���N����i(��c��/ϯ�}�,�p���Z���<��
|�A?n�ʊ�XEK�aPc�N�v��xgd-��W���ۛMG3��L�;L"tq¼�L*Z&-��)�V�l��hm��z�Y�_gY�m1GJ�4���5h"�vdɟʠ��:eM��>~�?��*�g٥-���)0_|���8���͘�b<ۢ���X�m�i1��5���eʟ���h/~�Ba|�;��O��j����Ug�r�H
�&��t�2eP�2�v�j����u-�����|�G�م��r�W�Y����''��teʘ2�"�bp�R�-�'(�*?8�!��6X9���q�.p��eʑ2��T��:6ЃBb棶p�B�)��&.�=9'N��P2�ʔe�	^����L�I������:�#gHȌN��H�C�5��d�$�C�S�������I��p���x̎����z��)�F\p�S=b�򞌆S��t��`g��Pot��u�̪Z'�4����]e�P,��� e�.�dʄ�e�I1���.B��&S�;��.r9<Fh,����](H��,J�>D�o�.[r��`#S��-M��������nCG�9��}z,/n�=*rMU�)���!�Tsh��i=�`_��)[�L���$�m+����{�,
U��>G��/ȱ3���@\�RU,~�z1[5ƀ04E���釈�}����y��� ���L�@Tʦ*�t������V��� �c�i�ζ��&}���w�k���J��"j_�/B$z4�\U�}qD��Q�Ntݫ�8��+?(6w�gLܤR.UQ��#I;?�N<2<�U��e����6���a��Q�o3-��J�UE�Z�d�'��M1,��j�̣�\=F���j�	����<�L�C� ��c+�]    �� tlj��Z}{�����b ����_����o>���wJ`��dR�b��
[Y�
��=}ؙ�rUK�c��*x4�'&$\��(:�kP&?�|��y<�O�q�"7AQ���&T�)��6:�m��x|y~�?=|zއ�
�o���G��_���o�}�聴��'V�{nt��f���u�$\pn�$��U�t��|�FvlF�0��%��>қaH�h�{͵Ui�W�ڠqe��A�M�*vef�	C�i��"��J��hπ��ְ�p~��V5i�V��4gY���vw�R�>g��N�N҇�N�GG�q�����/�����JT�����E�z��w(��]����MƆ���	_Jpц��˔�(�j26�bt�=�q�h���Ϻ4�5�[g�U��4!�H2Zϟ��ӟ�֗{��u������gD�#OCFM�9�[it���(cX2��b=��?�uk�`VX����(��ز��%�}C��D���ÌaG��qUy���Ӂ����t�n�|=�A��:�ܑw4I�H
�Օ�e���3}�6�-���Ot�+�Hɍ�Tgw.�ǉsy6�͇�6�4v�t�BDj�%5�����Q���V�,C3]w���;,O���CtaK�\��=����tS��6�`��G��e��l��zt q�i.��ͅ���.���r�M��)V��U[y����	r��w�����r(9�5q[�d�>�?.�׭D�������tG��v�\��_�e�a�%��k�+udl0�jkl?�0�ʍd��>�%�t���v����kr��+�JZ�3�y��>n�&�z�F/|YMs	ۭLUǟ�8�z���K!��7�q�O5'�
�����׊��ӿ�}�2	E���e����m�)oZ�;^�j[� ��1�;� �c�8h@$2Xw��������nQ\\��4��c��B�ۦ�nt��f���ht���>��aN00l�}�i���>��!�p�(GP�z�8�q��7��8�?��I	M���'��,RD%t�����c�7��*��)�P����	��+��]h+9-��f�����q)P���3o�K��> ��ۑ��`�	8�$e�x�M��`��UQ%D]0����3Q�e0l��pWF:)Ê9Na��zl��:�w��}7���v:,�7�}��婪v��i�-���.�$rosC��#\��=�b���=IW�hS�r��kN��1I�H��+��nW�����"W�*e� �JH�N�.���d뫔��REq�c3���U�+�
]ؽ��\��*g+�)�F{q�6 �JZ4V�!��8���w7c��Zё��*sZ�Q=��#"!lg:D�'�.��т�U�@S=<���o?/$��sl���5��.*Lcx�������*�U��e�ѯ�V�B�t;��q<���q[Mt�5�?K��I�$�a���Z��7㈼,��b�Eq�:�I&��.y7«�9�Gj<ݖ��m9��q-I&KJO&�ʋQ�\&-��~YQ�B��*��
$=%�hc�x���l�E!�^م��������w�P�[d��j|��XhA�p���d�2��)F�r�!+Tm���G0.�z�*i� �7��� (�l������Dn��C�cGn­L�ɮ�[M��9��ܹWK���!���8��O5���\q,��h吰���n��5:�ƻ j��	��cp�T)�Qpq�a\�*4��S���C�Jp�G�<�t�����g��y5�P���u�4)�@L��;��!V\�9
#HC5����֙˻I�`v\z�t}�j���a��zE�h�'�Z gk:f�LK�ut�P'���$�w[��UL1|��R�|Mz�~����#���nHt�֔(��9��2ܿ��X�#AU��j3_�H�k���p�	�
6
���4V#ݑ��9��˿��_�e�Xʘ�͈.h_$��H�C����t�m�o�+rcGؠ���6d�t=���㐶]���Sf�H0G�ߵ���A���f*,a���:�u4ʰl�,B�tQ���,g����$�2q�h��.���<��D���u�D9����Ѻ�%:MI;o���b�E�丸ֆWOpD��u�!K)<��1�z�0��
���.��������o����s��2���b_�kt�j� k�U6�Bnx�<GG�s��7k�����;|��~ގJ|�a�P�.=5�Bx��ʙ.��Ѣ:ɗ��p���GI~����$_S�D��r&�̄c>���m8:چ�$aEb9�lm�MSl�m�yJ�CiG�5�����Λ{
w�E9�<��f��~�XZh��5@E(GG��XЙ���Kn����Vw��5��,�/c�g����໪YP[&��
��v�,�!�.��>��ޡ�1��U0(q��*�z���� R��Sb��[�m�(;5e�h��\ u/�`��0S!�⡊3���U��"B�h%��u͗�ᴍ�!p"�.`�/�n�����w]�?^��C����X\M��i�C��'�k�29I���ݢU6�r��u:������s����"xx)gE�j�%�K��]���2vL��<��yp�G��z�.%.Gz��2����_��y.�RR�Vާ���=�eڇ�$��.�1�����RVs�θ�jre4J�=A����T��.�h��>,:6����<�0��U
f2��G&�+z����\y2C���49ch=W���Ҥ�kL���x6��rk�k�1���e��T�P���܃�0~�ˁ�%��	��G22�`��+32X�
�ƚ���4�;���Li ��6��m��O�\��W�c"SM�cX�ʎ����d�eF��1�����+55�J;r�B����hiYƧ'}Մܤ��)�ٴ�@�Ui#\�j����r�����e�"}V]1�:L�s_ʉMG���l�-a��,�L˙�{}Pq'��h��L�x�R�-A�#��h�ƅ"I沒3Q���*;�Ⱥ`�@�O�49�o6���P�e^���A�Ӧ�3�U��x�^�<����n�u4&ZG3/���%�=�7ȂX�Xr䧑�G~�x�m"Wh��l$ɨv�C
ɤ[_L��ee{�v�`�\:Û�hN�?6W"W�mQ��t�	M���8:����*h�n��x��%��ې7�����H�h)�]!���rγP�!��䲾�����ۻ�U]�%lw��Ɣ�=0hk_��B8z������Sx(6X�h�e��#�4��bx��d��kb%c6��tY�������8�ƿ.H�Ƥk_�/��-�fE�Y��C|�6�s��p$���3�XL�+Zꂻ �N�F�j5�h�O���Y���w��֘t�����` :��l�k%�s�>�G��(ﶫ+$~�%�)���53|�I��x1K����7mS��z2yW�B@�l������J;�Đ_����p-�Gѥ�mb���K[L��e*���h���4�4L�OTy /�*뻣Z!�#�$��n(!H���h?�d��m�����W�����>��!WW�i��\��E.W�{o��S���x|n}��"%'-�^\ϧ�>�[\p�,���}|y��_��NEL 5��eA�2��M�l�D�V�!��������8Wf�ֻ����_ia\�Z��Ck�f���8�~�tǊ�u�=[:%�|��(��6V^,�A������O�FHz^�r���jٳg�RW�^��"'IB�'O.r:�92f� {�����&�[f&�sҽr�Y�FD����}��EH&c��/c3��#�Jݱ�TJ£;c=U��d��D6<U�ԇ�M?��2��B��I7��x#�x:C�Y�Y��Mh,$ʬe�&*�-7�x����!��R�̾��&�Tmc	�\0�r�Y-%�
,|��D�b������H'�T~�AL���h��=<�It�uL֗c��{�e��@.'�^Or��C�k
s����kJ���RÛYSY�U��F5��h����1�md:E�%�s�a�.%�h�
IVN[Y��h�ǝ;��ǯ�7- �  �̙�,���F�.S�	|c�}*&ڧR��TC�� �>\KM�[w�\Nt�wρ�0�j����y����ۻ�j8�F?��b1�%�yu=�V�S♖�{�ui��-+&ڲ2���]�v��%�U��쿜h���5��jG� /��'�Cu�<O/�fց���d��*&گ�LO�8������$���JP}��	Ӏ���y�˳�6Rd�F$'�e���M���h��|���������ys��N'�t���&�O��4,7$���6���N"�)���N�.Z��!��S$t"�b�9�5n���v�rb��^�h7H���!}�����I)v�s]䂐��mR�-q��.5k�j��$:oF��H���F�УGe���$j�2�T�PY������Ϗ�����u���C��b15�����5����s�1hW9�G�y��7r�R��A�f�KT�J�p�I@���s�@@����e���5X.2�*s�ay�Iץ�h]���6l�F�u�e��\����	�:/5��^�>�Ƥ�OL������S���K{��VMVv���i�I�KA���Vg2���TLs�^D�x���>�*Y��y#{�6CaH)�<�E`�:J��1Z� w�~�qJi*^F�[�f��������*T��s8���f��$Q(B��Px�$7�.���Q�%��f�n���9��KL���T�ٙTB!+���{k��t�V�+k���������Hg`D%��?�ts��6�̑�Ct2݅[�B��wB�ʐ�Y�����ghx�m4W�`,�0�h`{��%�G�e�<]db�=d�ɔ���54�i�Ѵ�騍3}hSU5B\9cF�`��s�\��&�es6�;C��Y�b|a�%L�s�~:uwR8�j�F�X���ìS��3���ׇ� <��9Xb�m&�p�ɲ� A�J�x=e����D�*��$f�+SgZ�)��9��oL����x� �V��D���k��(\�3a��Imyw�A-� ����*�l�$���c�u��x؆��i��ȠƔ�P��$����]˒�7�g#�m"X���a�	d)Ea�Cًu��v�����zAe���R���L��K���H�jɺ�N�N�T{�H�F�d���IT�Sj��1�n�Q�?�<��d��_�p��X-�a}� ~�_��V�(F6���VOi'Z���[�!T�v@�+�\�7�g����4U�1�.�E�N[�EY��޼y�� n���      v   &   x�3�420��52��J�I��L���425 �=... |�%      |   6   x�3��HMLQ0�2�0L�L!S.CN�Ĥ��"�Ģ�T.#N����=... }�      ~   i   x�U�1�0���á1�g,���H���p��� qC,��X8�#�z��dKRI�$AR��H�$ �I��L2�H��y����r?c���ʄD'Sz�ѻ����9�      �   �   x����
�0��s����I۵=��@elz��*��W)XX'4���{�Je=,�1�<M$���q{ޡk�4���ξ2N *�z$�>gX�sæ����J�eTѐ�aE�a��é,�FC���2\4�����h������{I��v�=�}p��١������.5t0,�g�b�W!Fh��]��mC-�f)W���.��>��H      �   �   x�u�1
1E��^`���fLzO�Ղ�����GDa���̃�߯Z�/Z�˭�R�����:I�ZJY����-��$�Oj�����=9��{?�?Sֶ�@���A�#�1)F
���uuja,�ڄ���6j�&X@�	��s���M-�M,�	�P�7���-��)��|,0߀����b>�;U�gl����.Ղ|t��cK��^�A�J-�|�Yx��9���-�      �   �   x����
�`�����������$�J�мD��,���I'I!:��c�a$1	"FD�(�� ���!*�A6˃�	��q��u��&�Iތ�O���%�i��M��չ6x��l����kcː���E�	,�����MU�W��l��K��ncO�~�u:�u�����7�M@��a/P�}i      �   �   x���ˊ�@Eו����[I&]�	4C��E�4�!��?�0�ѵ�[��Uah*L���~���p:���vj� ̬��?�T g��ml$�r�_���\��~|����SF
�@YRC��Ӕ\Ś[:�r�v�&��'��Y� ~
F��ۥ;ޯ�ˏ�_�rS��˪45�Y)���!K����P�      �   &	  x�]�Yn�:���Ud}ak��HG�Ek2(�������*���g�bMTYU�,n��kx���T�f�1.v�ݔPk�v��e�������e{a{1�]ݘ嫙�>n~X���D�u�7�f�� ���I*�9�+dPC�ٮ�IC��VYH��܇�e}���a�5��<B�g��4��ڣ}y;�ۜ��̛���ȣ
���P;*q�C�6&T�Wp+�Hmv�Is�c��v3G��4Ƞ��&-O���}�+�*/"g�^�\A��&�0�q{x�(͓��֨xz��ڬn����l!޲�7��<˭���F��7�A�A�^�]�j�AWx�aﺩ�i}4��� �r	T8�=�2�a�aM2��=�7��y8i�s�>��m:Ó-�i��M�XT������u��Gg	+�]J@ԅ_z��`_��� ����� �8�Gv3�h��FX�]�1e8��ˋ��[���2+G�/$#��	��=�'��!5�$�*��6��R��󺗂��	�ҟi�z>�V5P�QԙŎ���� �XF�(�Tz��ET, �?#��{�����5��	r�����ͪ �G��W9´Ct�h,�i�y@��ܭ ��� e��#�v�N���!7�$���.*�0̂|�.YqE{MX�{�;X��O&��C����B ��mW5En���&�ê�o܈���ecrI2����z�k5(,�'�a	��>e	�2<�꒶&d$� ���&��̧���2���co�v�n 7��%pe� ���w�����J$�$��<�Hp��j�F�Z#(�܀����w����0
%"�e�;\>L8���=���IP*_ی[��(��9�\"���H\�zp��9����0�mP3wT���jBo�kʍT�)�	�w,��ܚ��_�N�r�B��U3D/>d�ZT�1��{*���Eǌ��Dg¤#N'��ʼ�kC���_��g�����yfB����
%�i�'Y�K"���| S�ɩ�o���=�����_��)��ls,qJnfFaޠ���^-���P��"��E�|��B�����GQ���ڏ�(�a���3'ݭ��������m��_�P}��ym&�^���[���45�v�9�[v�����R2LL)�T�eI���-�6���%��Gۚ���}\LQ�ۑ�$�::�#B�}�a��@���d�G��)r%�����Ŗi9���
5�S��n���bEP���iUY+u�Wy�� �#���	���0��v3��O��S�Z��1����x�5QMI{�k������m�D����nD��%-��3FoI�>p����9��J�s�T�i2U`�AZsI**#5ZQ��0�Ìv����Fv,�܄ĈR�O!UZ@��^0�v	��V��|K-����l����X�6����c����担��~�1�\e�w��>F�Bh��HK�HS�"͙����9����܈G#EBQe�1�+���r��� �.�McNn%�&���;_��E�8�t�2l�>����-�vRr�OUC5�a���<*�#>�l#�B͓<4]b5�1Jߩ =�&�n�M�hx�KD�os��t�X�s`O���T��B�&ñnGR�Yc���=�۷<�BxYu���ۙ�r����xB�V���؞�gV��#�=�\_X�#��a�K2�ɛ�K�6��L޹F��fe�k���U�4�1�4���o�%h�N
���>�Y�H�S*M�|�q
��D��;7��2���B�t�l$���a�G
f��k���Ť��j|��F���!�'L��f�|�C�q�8`�� D����ȕ�=ҷSP���e�1ҹZ}�)���)w	i�� �G@�G�	��9�ɖ�	P��*F^�6��h��U+��P Y�a� �Hc��#>C!���(���<�c�D�b��=�"y7�=�Дm�jӣ@q�'�4R��{��_�?Z�D�;�V��Z ��;�<��n���{A�|���XdFԜ�PS�)�]�	��;�y^�v ߡziBUR��r�����Ө��5�J��,vl[�yD��{��<
�����*����J��TN��=�t�~`+���D��A��+A�����Q���g��@���yX�%�8����{����Ǵ��9>�PJ�v��gX�.F���N�����!�jE��2��	J�?�|	UYzsycV�`S�S�4}�]Pg���^o�Pg9DCF(��k���w�+�s<)�)C��~x�Y���v:J"k{�����������      �   �   x�-�K��0D��0#~	�,:�@�Ѩ���9�����r��h�ӻhZ##��y��a:�/2u�8#z�^F���X5���u�Ū��M��6�8?i��+L#3V�BK���3�s���H\i,K�Ww�zē9���P��$u[�`K	�2݁H��nL��TK�{�����Ӗ.�V���9��'E��+ъ����Nc;��}�M\�s�Ah����x;r�����ϼ��Z�]�G7r&uߏ��)����[�      �      x�t�۲�:�5z�~�y�}�*&g��
�Y�l�g`X_W���l���RtDE̊1!�R�<�U��E�dy^��w6̷a���>�e��[���Ev���s�s�Y29.����e����o��P��j��3��I�:�/�m�fg��S���;��WO|��0y��~'����PEv����mVSf7���7�c_��27?�;����o�<��g[�d��o�3|]F�����y�/�8�wws��>{���p�oμr��=�y[�>F�g�av���j���Y����e�l���6�������[2�:������0M��7�Oi3��|���<��3�����s��;����"�V�?�-3E6�,����mNX̅�v�Q�
C�]ߓ3���G`����#�]����)净�����˶:߸{Ҳ>�����=��Ĳ�|#Qf�v7S[��S�����k?��/&D�	��{����{��겟�1=*�鳟�꧵��f��7??���.�8��d/*<�3�NnWf�i���U��-j��ٺ��Ўц뗗�-E�mI�����e�p5,��69�,a�T��o�e\���\�E�[�]A�����)g�"��w�oBx��^���!���Q����[HL���H&Bl�^�1�G� ? 	|w_���l�0��^- 'ۛ&�kHz��yp=����w��lQ�Z�*�7���W���}��EC��|$�eH��A��6�8/���'FK/7,�^��g����R�UH�7��`]�5��z�Qqr���x�� ?��w�8��ί�4'O�=5��5y��;�n�-}P�ӰL�U���6|]������U�B\�!�T�zq��?�h���~�?�K
���>y*�e��ǩ1��t����׌��UxQ���넳���׫��u���w��������) 8��L�W�����y5p�ܴǫ��rS:���ǻŴ�k����}=�דQ�U����^� �Ά�ހ�ܿ�����(/8��"��(5*=������+�p��i�W�.n�觻6^[4��*�������:��:���3����&�sr����j=��H����i{�w�ӏ�c����q2��g���g��۟����1�'���ާ�����i�^��:ɏ��R=���ca�������b���[5��������K����'x����"�h�P^��_Ǘ��{&�%}Ff�HMn����uy�mL��L�[�������-1�z��1xt5pN
�<�g�^�#y�W"7[r܏s�eL�H����_�Y�|��M�%�n��u[�!{���X�˼@���z��?����<ƫt�GJ�L��|>�X�� �4��"8u���}d +L5j��E���Aʭ��V-�˦��@w����Y���퇻��x��}�oX�f�݆��{�$DAB"mtQ�R���0�^�����G=�o������m��5�\���u�p���jE_���x�i���IaI_S����~�¼�W��1\�O⵺�}w�Kh�ξF�������˼q�/R2���z���^���ͯ���ŰW�.hjl\	d��-\�re�r
[��.~s'�t������}I�x��h�H/��p�ۙ���y�7�~��L�|���y)�XꦑT:5��,h�u�-K�J�mC]��>�ƞIK���a���O������_���J-�5���>�s{�{)����-ݭli���[��j��;?ʮ���y~p|��1D��2�U�E���3[B���)��{�{�j��0����ǌWꄹX&����A^��J�v��I��ˀݔa0�׻1��"�[�4��[(�,bjf�Ӻk��°m�g���`(�4��Z�_���zm�����Vw�
/�.�7���(y+�w�����<��tv��s�uH��+}���d[L86����`���|B���5e`��ǐP9������;��b/)3���-(����:�|���><N���b�|٧x!�.b�׸�~}g{�ū��`��l���CȐ�y5��%{x����B@
L׻���̷w�i��`�Ddi������K��t�&�[콢^BL��^�`������4�W���U��ϡf��f_��^/��d��v"���+�`��;�y�E�sKƏW"A!M g��<��e[���5�����ڟ�����E^�[�fv<�e�v}/.��u9�Qp|��x��5W�Q!xCG,n�j���w�Q���a��&z�"^I�7�
�c��۔9�������/$-��jP,�?J�
\���3��W�}w���_�ǈV�:��7
��^��V=�9JPx����~!`ӹ;�^��x�B�!آ3N�w혫��xl�zo!�׹FH��	5��S���h��ͨc����~�i�x���I��U�+-b/�4���w��|��5^�*6�k
:ߴ��M����Ǩ��l�==�f���>(}Op?����M�E��uR:'�DO;!
:5�$��U?��l��f���럌��mW�*k?��=lгˊ�ւጁ�w���x�	����l�Ө����5�'Q�wAK��Ѭ�,���
^g�_}�!#�b�V��1�S��LB�����1�n����P�5��s�+RGS����5pu�g�w��K�Y}�@5X���~��0���1}��Ǥ��i��i�y��C��zuTN���ϱ8����H�D����4�@U�*����h1L����}���H����.���t��> ����e[����n�>���|#��4��*�Y5J'�fI��{���9?��H��ا4t�2��~���iww�e��禷�G3^m3Fp`�}i0�'�%��U6��fh�N��@a�����j�b�X��3pO��p�p���yiQ"&P��.���W�no����%$������c��6u�`;yn�0�*,��(F:c͚����W@G]��K��n]�*L��bI)l�<?���%��&`���x�	E��G�̴~�L������w��J�6)�E:x�܏c
�����EN�\As��#�]M��?.�d����>����k��B5$Ξ�'�_��`(�TǛq>����۰(^��5��������?�����
R����+oF�	��\�~�*10~����f_ǫn���^�i�'c�+n۴o<���>��pq�Lz�mX��8g��+�Os��I�2U�E�i�W�|��z����.��'X��z��%��?r~��^<�wa�����I`H=7�-o HsK{��n��(P9��&y�m��&��mC>,�����;#�>�)��|w��;8_���W�!y@�ef���j&�|�_Y`���^��2�E7����xa����c]��Ӂ9��>����.m�ט`zId����@�٤�H�k�21������zRe�g5d���"����VC�qO�
o��hAD����z���F���/���D�a�{�ф��.։��j7?b�R��e��,a`�{�j�	�]ڬwK����ݴ*�x�-gG�fgH|�w�,2��6{'���4���4��~��؝�vz�n����D�G8�u��ݞw����qP���Kx�ՠ|�l'��^���0el�	0��Z?[��&3j�d��ϣ;�h��x����:�n�adi���ٞwCy��c�9�jF����U�?w���^�(���+�.�O��y��\��&(�S^G{E';�Kp�0�>�p�k�B��%_e�a����0�mK�e������̀p��`���ɆX��hKz��A'P��P~��>�ycq������ܽ�K��W��]zi�G�)��?��!�����V�5����8M�т�-O��C�o?��o>��\���~=:�b��mLz��}w+�k��x�}���7l�·�gp�v��z��`�W�
��0O%�y����v�Vg�_��슃)�h�`9��k4����¯$�4����u����!y �=��h��Ξ��p���/䐢�.{Ct�����{w��P�p�HG��y77늰���J!�O��*��M����<���x����`Ymw���Gd��{    >P��+u��=߳�s�0J�-*�������;���Oh;(�U����I��^��HZӑ��%O�A�O���9Lq㺻�k&��qg
Z*_~�4�Ho�h��H'���}3hÊ�f�R������y���9��t
*��"�o��j"��m�xA�t����rʮqq�����}�]����g��3yC��y���w2,��sf�/�Vx���Qs�奾�0�/C�{
��I�*s�c�D�%06�~�����#/̏e�=wI�?�d����o�k��)M@����S}ga

$�����_����0{;2:�Q+�Nza��ִ�ȇ^l{��&[Z=�k�u��9y	��d���:|U7*F��094p��=��V�T!(<Խ
��}"q#LC�Kj�
����]OT���A	�fH�z�-Y�w�g�^&v� �]$�TS^U߂Ӟ�q|���`��j?�I����ޝ�:ۼ�������9� 6bHz�����Y��&��6\���r��;Ud�ׯ�����!(U^�w5!��L�s;����	�f�{ȷ�{J��4X���j����CG5��M`ǌ�)(��	�Ur�d��]�A1�|9to	�aPz��}Y��⤯���3��#���j���������(1����s�6�/`��c���P 
�5<�N�+9^9�J;/��K��kxD��+m4����۠^���6:�^��)����! �?���}W�SE��Z~%�顿��dpH��{�����I/���W�c���{p�fN�ya.r�;
�զ���o�H��C�Tg	̉�@K�(y(�+*;�'����o=-�l�sAM�bi�xGZ�;��B�a?����L�4�v(΂������[��,���8�mS�^r�s|bH��c�Z8r��XX��i����)�u�>�,�O�z�����0� :����'?����{�Z��!���v]��*(�SRP�g����dU.��7<�pb38|C�I(���mSZp��/�h�	CgNX�%6��ɢ��UMx�x����&��xZ;�!���*y�p��y�Z#��~�J�5�篟_$���2$�TA+���#j:\B�j���\&�D����M�ظ�8x�s�<������ߨ��1����d,fx�����ж���व0��p����a�μ���c�8�0�Z����"\X���zK~��L}L�曒��UZ�<ZB]��
+�K���/*��C25��٬w�`˸t��ɂ�S�F�l��s;d��d��3�bZ����8Ð����c#pU����]GjD���l�M/hD����D�vB��M��Wlcs��$�c���Oʐ���)hj��i�#A&�5r\����tMא��%��|���f�g��s=i�_�EOm�ٌ��򺟊��D�v���B��������
^g��5�����4�-�Q<�a����00�9k���*O&��.��;Tg�����Ƀ� �>�=�&�xw�a6�q���ipyvA�*۫�W��-މM�Y���F^��pVv��/2ئ8l�Xͮ�!�3��p�q<�c�Զ98t�E�[?�}sJ�+���C_��	���;A��&�%�P��z	^��L�!���&�)��E�������΃�{����n�TR8�m؃[4�S<�^	�s�ND[��s§˝�f��^0�k�x�=W{A�n��A<4�e"�XB<.�1약Ii�ɳe�-U/ؿo�x#M�ن	МQ/�^S��B����'ۅR5�U�m
�U�W\/�����r^�:{v�X��Fn��$��m�0�v�{��JS�d�w8�����nĚi8"��D��E�䚎�M���p�}-�|�����+h��P%����d�L]M`��������7�W��p���:yLG�T�HM����H��ҫdC�c�0<��	�!��e0�%8e��+�Z���關q��Q18o)��6.����ЗmF�Ņp�tt�<�I.g�X�Q��)��k���q�%jI'$M5QL�fZ�*��0��1 ��==v'=��lw�m��z�5.'?�^,D�#�d�P^�z'�G���d%㵊 �8���;��-�Ra8d�%~*��9Q�v��
Ǩ��$ͪ��'�KS}�C#��bp��.�������)Fݵ�4��S-9�l	�e�8'��-ο���mS;�j$�PT�բ~�������e	�������B4���j��Rf���9�F�M����d.(H徎'Wx��
��{C�����ru��[�o�:y������ɽ���c��0m��	�{�$��i/8��dbG�[H~�q�<7{Һ^�O�(���ZW͸�?�<E�'��|�oWK4�y��j�<���l`��ۏ���?/��y�G�P�'x��;q^��~�)���Q\5W��Ll��2(0bqdG��������U�a������)���-	A��t)�����I�_/-y&��s��L�ǅy�滐-G<��P�$���V:�0}*ƙi����)���C��=P��JF��\R�.��4GY5y�a����W��za���3�_f%f�ew0�L��,x�h�.mk[q��q���$N��!��T/F.�����u�rR�n7�j�!/�[�7`��N?�09������"w�e����5�
&\���Å��jy�d%ږq>k_K��rvYGU��5D���%HD���A���I99�:��`ؒ7�K���/��h�}��!��h���ٳ�?�z?y���H�v�w~û�-ڇ��+6 Y��'�ng88�M��B��^�d��^ſ]3�_|��?Gn�u�oZ
���5҂�iCZ<>�T��OgG�gPr�[�-���+~^��J�[��s^�q�&h7���&N�F:y3�gԠ��A!h��\!:��iy/DO�j�[%�A3^��3��dlUbP���eM����0��Dځ0t�0����lz��5��B(�b�"Y�$�N����: {G4GS��f�
��1��۾S8�n�|��;4Gyx{��5�`���R�(D�:��TI`U�C�
� 芣S{�@Ҿ~����E:E��=M*����W% �Hx�p��U�&�ױW��Pa/�s��(�?���(��d{����e[@�Ӑ���z���()��q��E�0{b�;^F�F2��*E����㱫��Q�-��G���(:m�(�#(h�|�)X�!��N��I"����N�(
x�9���^,00U����{�o`R�p��	)��{���@+���R�C�xE��N.`�����+ 㬔�����}'��-�V)u7�(3q,�2�|�S0jV�`6�p�C�a��^�0�
�ecq$&Zyc��zwC�h��d�x��&�YM�q������"��O��ߔ��c���/XI�+�g�{�L3e6^W�<����V4X�IuH��mw��D�*�����l�Mz]� |�,�
O�y����f���,)��^n?����U�hE����]Cs����ds�k&�tl��_'��S�X/�އ���9#� }1'�����	W�EK� �Y%B��q��9L���[��⺨���K��0�Ȭ�^ѳ� F�d��'{A�>do��Bi���G�ͮ�i���C��f���c/���$�o1�l�xee
����6�u3?�*�m��w+�\�pg^R���I4E����%��-�qM�:��%L#�k�p*��|�N�j�;��0F���c���dɎ�	�p`2�Q���Uy�u\1\Ir�h�	WGaX�i�Kl<Ĝ0-���")/9��$8)�I�j��/Ӧ��n��Ց���*xI+��rn�I�MԔ�v�0�I�ሦ�6M��b�,�r�?���7U�#�ܸjkv�aRo^3���m@H47Y��{T"a��U���,Ѣ�m64�L��	�!{2%=��d�ɚ+Tn�`4WP^�x�Ur��p�������	�U1hÑ��Ǽ���&�O�]�oIS��3Lw����������pF���u%�b��'    x�ìc<4�bm��!(;N�?l���|��w4n���l�z����/���p��r�;��l4'��c�J�d;���+,��+Q�8ņ��c��󑒤�m���������]J���/�TMI����4E�H���e�4�S���c���^׷A�X=y�qw���cj����u�?E��F�8��{y'�Ӛ&ԛ�pW�6{]�i�a�ԻG�K��d��d��Ķ�!�e������|t8'�W�d�>���pUy������6�ܩ���F�&����N���*�1�m%9���B!�j��j�q��83�/ڼ=��\��&�ǝ�$�4�PB��a*��B�T�0pCI^��`�'�Lܳ1h����)��&o�V��\�Bj���<�*Ře?mUq`����O�_R������vuɣZ�:vw��:�IA�8e��jT�rkzE.�n�r�z�LWa*:�-�5�z����b�p^Ӗ����;W��DK��e@	`�
����D��x}���l�4%�ӌ��+I��J��:Ĳ�5����>���������]�Dgh>�<o�Ym��T�?�mkK�F߃虈}74S���Cv7�!}f?��LK9��ك:ʘ�X�爚m6���.m[�V���_%�G%{��;�&+����'�QR���e�<kW��5�����w{��;�)ƫw�h���uY�G�'�iMq��Y�A5w�˔�L!@b�C�#�4,��+���"�5�&�`�o؞̖~����e�/:�����4E�֧��E����R2[����`��)ƶ�+�PM�+�;ݤQ[⃰���Xy)����[\����\�)�s2�݉s(9�F���k��$�S�P�>C��D��������PV�=�Ġ��[��G�*�9%�=v����
�,1�0I;5%e�v�͑��:P<���y��ދ�ZvI����sװ������FP�R<"��\���e��n4^f𑄷���IǗ��V��\�mp����
�8񾔲���ͳ<$"���dDj"8�qdBĐ,`m-�QO��J��,ɣC�1��O�:�EpC�î(q�&Oi%�u�.������J�#��{ߒ�U���Pz�ȅHDuư�%-���G�U1EuDP���lcި���h9	!j7}��Љ��ȫ��Sa$S�F���c(ŝ	2��"�Bu7�Ju���4�!��{�0�\�t�x�x����Q2	�E,}�e��^"�g	׳��"���PU�ҏO�!�E�!�\���@̄勤)Tb��z?��o���gX���h��2q�ʴd��5�،q��N�e&��'�Ù{!�����%�I���NR{rW�"�b:�n@��!��2�Es2݄�!��!���v�:��S튉��s��m ��!�WR��p�^�|m��qw�*�����P�:�v;@DQ����#��i���ӇC/;�P�����N;W1���M}@�)��5��P���SY�n�������z���*�2��z�L�������q�&�H�t9�&�r	ab�=�(�����%%�U?��[L;�Y&��ȸ�-�o��G����������<�*�9rV�b� 7ЛK~_�h4�((��3��.�~�'TC9�M��p�r�L����D����F���xK�.wqO�U�2\�/���	��-LE!;}M��d��`8��x�8[���j	� N�[-"���X��>��7*�ܬ�Ǿ�bh�B�g���rO2i��l �1���L�bᆾ���E�����2x�DLG�?o�p���������>J3oEa�a�h����LP�y�#�����S\�j��������1�����\���R"��q��5a�����!!B�fB��-L��[�5n�uFڥ��L�����-r� F�<���q3��>�R�i���+�Q�\-��ra�!&x)�_Ve��~��~�D�u0�]�
"\���>�J�qw"�'�쩫?"3�P����29�BL���*�793sĕُ_��K�
=��"�k
�_�O�3�������|0{F��0X�>�u�'��dث)�#T�g�2DA�v��{��� ��Ӿ!��˚X����^�J�n�w�o��r���E.��솔�����^dbp�В­z-����=-�[L~V�^�X�͚d�����3�V��%-E9+Z{�������4R��^xu���%y���-
\�T�w[Bx%�}}qʜ�h�=�ه���}���~s�d���=lJ��	��/�o�#*�(~ѠEb�
����_��L-����<�ԋ
��3N�~���q�����Y�=��Bɋ�r�N^�I�7p���E�^ (���Y�U��� S�혼�z{����+w�|�nJz�T�'i�1��nX��q2�^'��kt���S&�@���P��Y��I[�>�>iQé�m�U-ϭ���Y����z�����7� ٱMѾG>݈B�cȨr�J*�mQ���ks ��Ò��N��sX	���}Ԗ40��!K\D��|U�>��\x�r#���1pA1�J)D4�����s10|��)�^{w���4�M��q���ޫrl7K�i��6��d�i�[��\Z�ZaD)G��~Z�o`=Mp$o�y7p��v�őp�o�h��<�&�0�Hҧ2��a���S�<�t���U�;�m��w����J�	Zg�+_�xDo�~#��A�*�33�RM/!�jt!�&�p7�^ճ���b>P�;����v���*��N%Q�&% �C|�Mos�2��\b��:�}oL�����K<`Ðo�޸������.p�p^��3pE��i0
_��Ӥ<OD7�{Y-a?]mc��G5�Ɇ����&��/>n�������ͩ8����u�3G~�Ӳa3,�m�%����I�`�V��
���nJ�	�V�8��.��d
������ ��-��p>aʓ#����GO����> �H�ڸgˋ(Q��T�6���	���ɝ����Wp�{�� ��;�y���G+ɹ�joR�Q[���{�Ln>0-�@b���k�M�ݑn�Es�J�Ug[̠@(����oQ�U�g�J���<Q�rt���U����=�]�"O����<�cG;.�A-I����P!�/�z�}V+B��M9P���¯��bp�R�_Ȇ��h1#D+�G�uRn���?Ôޫ!��H�"?9�
�S�L�<B^"�[���ִ#�x'�K��6�~�[��	����������*C�Tׯ뛽u��ov/Kt {�G�����R�*�	Q'�"!q"��#T+����8��%rRM* ���z����T?�$DN�k*��E�q%W�{��y�(��1=�?XD���.���A�%�����2H4��aHj��P4t���Gr��F���Իq�������B3ҍ�>$���1�E�Gs���� ���_P���ɛt�_P(��1�%w}��1au\s5��������?�
E��{i�Rn�z2/�@���%^���I��!ئ���
rm��2_p�E�W��e�G���{˅��=�>���iI��SN��3��@4����^��V���p�0����w2T���^WCȊ���ԴWS�W�}B4r���(��d���pD�{�{]���=X?��c�y,����1xD
�[Ҡˎ�hD8tw�����[-�e�P���J���eC��f������*�.�6������HH_xC���|y�*������u6>�!�MCK�����n�ѿ��:|w��h(�����6��<���7�q�<���8��q«��K�y�"RB�e���J�&��.�Z^�w����iIU6?Mr*
���<����f��֢a�O!`L3)�,ӗ�V����*iwS���g����?;Ӛ1�T݃UMա��%�(@%� �Q�6��7|J���mt�-�1��KZ��&�����1�>>�+
�:fE���c�fb�V3�rI�,�?P�l��z��T��9ݷ��,�k*��&o��    s|7�Q�fAD3��f�L�[Q)����qMu�N�i�&��aW��q4R�	o[�mz�O}m��K.3l[ӋW��Owa9���%�o� ��h��4���i�I=�/K�,¾��;�F� ّL8��B�Lr!���ˡ�����f}?,W�j:Y�&��y���T��f[F�>ׁ�������KT]0�g{ ���o*թ��9opZ�c���K����N	a����U������%�B!���Ǩ0P�_B���D����0}�=�5���S$�[�H7�j�`d#I;�8Ӵ0Ů�c�x-j��E���Nd�X��0���W�Ory/������VsEI��7��!h�/U�yDp4�d���F~��˱|	�,pϧ�_�t�n�+r1L>	g\��҆(���AK�V|2�����DFp�0���lrT�)h8��z��P��܎Y%x���cF:���Ԥ�8�n�{X�4���ցW�T
c3-�%���:B4��2�}g��h[�	���67M�d���i����P\�5���+��Lɴ�%��z�g�� u�=ٹQ�h0��5�4�q򴣵�St"T٣˘i�%��zar(�iKl���.G�5["��6�0#�jYN������:�KG�<�f�v"��q������e�:�������Q]�m��A���,�I�皞���1�$WK�P|��x��a�~�|��p�!0�&}Ǜ�K�>��2��	5�	��E��`{5�ʎ�~Ԋ,L�#�̀ϝ���^&���wrf�mh`�wi�ې����f�+�G$�v~��5�58��5�r� /��T�4�5���02��\�e�zW"J���~Q�
k�?!'\'K��p>�tjE'�`���ph��F�j�0�g(����R�W7]�=���a���y�G���D�����6-�a�$S�%�f!zr���c�2Z�.8�'F"\�=��N�#���
�W,��A����"���R/K���ݎ{_M��F�hf��?�p��n��>gUr@`ʴJ�zW��]N�C%�Z�hå~�UK�-�mFKL(oq�x{s����%@�z[̑��n0� ������/*x�%�>ݷK�BP.���N~K�./~��K�(NQ��#�d����~"�>'m�Q�7�������;dϊ�"T���4[f�22B���OS~Ph��/C�엛q]�;�?��������.C���}�	a
�SE��7�]v2x.�����0�Ԥ���4�bQ,���E��1��oX�_������i$����*Z�l_ ��{q	L�U�j��<�,�T��R�S��W��΁c���&7���	��~�Խ�ْ_�@���Ȕ�����QJg(T����S�u�{���m�k��N�V�=��!I?�-�R��ԎEp.*���g����x�g������p�/�&dɇ���*����
D-�e�W@3M0�K���Z��<�ԇ	**�d_�qT@��f^�4�H"�y�;P�y�N4�X����v,���U쮢)�iK��:��
D�=�_C�EIM������v�{�*i��n�(���d�TG�%7+�L�gD\�Y��r�:{q�������L�-��W*V��4��e��R§��4>�)��G�r&)��v��
�K$mWr��3���zh.� S�c��qj�O*pK���D����kOkKS<��RHD��ƺli˨��+dx���N�O���5Z����:�X�B�n��0 ���7�cʝP�V�<hS��6�W��߯ǻZ	Wp>��(97�?�A�$g�F�p5�v�q����S�n�e�G\�T�"�����l쾫�0S#��w�E=F�<EB�~|;������'��/�Q�3�g:n%�Y�d����i�xs$��ih�+� pAYoI'��������ú%�GYW��:V���ih��i��ӗ���+wJd1���]iBr�p�؈�\+�0�5SHZ���!��K���
*���*�������A�M{Y|H�����c� n���oC
 �ݰni.6�s0�R��P�[�(�$q��PE��:n�#(��D�i���I�a�_R!h��t�q�U�Wg���
��W�*Z�f�?Yך�2�#&iMU2F�B�k0|�B�l@4��:�mv�G��8��^Y(l	�-�4Ӌ�[O$��͇�Z�h���ٜ�ѓf4ߜ_�5�W�fJ��.髆Bp�Nn�[�$�CXY 5_�ŋ��
�GT˔hݚ鲟;�y4J����YO^�+n`�����sv�H.)ȣ}��}���4����=�a��}D�'���,�i�/�C)�l+!�W{��Y�nD�T_�h�2T�<;BGb5�ډs1{'���\!H>8J�c����<��kI+N�0����������� U�H/� �h�m���[9	��}Ԓ'���,�N)����!��$���P"(��B=��?mi#z���g�a���J����r�����	�M�HY�4�s�i�F�0�pK	�<��Q.��,��N����k3pG�;�����?�=l�#d��s��<���u�%z�o�1W�}A��PU��<��0~�N�C�y�A#I�ԧ�����$��~���)���;�(������j�QL�؝4U��wƠ@��r^�ll��x-��;Ҵ`{ޓ�kH,�U�'!::�:y����Ǔ�)��&�A���lGr�g$�z&JX�?��ŏ��X8Þ_ʫD�$&��bh8
.Lo���mҳAN]p�6(�#́�gl�	�ҧq޾��H���hB*�\S��t���k��"��´���HzQ�k%Dj����)�-XP�C�h&���-ׁ)���s(]�؏�C(�&�G�� �Z��>�@4�`��'�I�1d���M'm�b�}�h/y�%=�M˻��8*��t�y,�>�pAeR7&����E������T����ڜ��"���{�T/���蠨��r\iU40da�ԧ������5���'�\�E6BC�� �
"����X�	9����N��g���T�AT��CE�l;V� �d2`�i��$%ڂ	$�x��d�ȿ��R��Hޥːް�%rI,��Kxs��o�����?&��+���kx��¡?��#I~ �z�Rޗ?_:�{���c&"wxͣ�9����OON�^�8��`�V8%��Bў��`�|���;��I�(����";z뇎��J����Dd���ܷۖ���?���jX(�u�v��@/���%]v�sO�R",��s��)D������D�NW��"�j��X�;��9{��2����Se���\�ɳ9��׹��p�w�3�(ԇ#c�s_�m����/H�������!Vi�8竡�`�Q#U�
q1Z�
Jc�*LC����hE/��C:
��Ľ0=BݔJ*x�"����[ڔ_�!8)Z�%9�&�����R�8?���^P�`#�8��EjV�ZR���^�*dM��" pO1�1��ٕ[Lwx�������`{����oX3]Jֱ��2r�mGc��� ��1�့a9����خ~%���a�L"_���lϥ4�	=0<
ȃ�0�'���X3����5S�̇���AP0��:P�����V���+! w\U�gMF��5E�������D�S�P>�r?,K�+3��3ߩ#-3�y�5��=�B5�>3%�a�5F��w��ǷΖ����}[�s>�����Pv%?��5��0���^�O�OE���LMgOo��0-��(�C��#ZD�����i�xz�S��EB|4�Q���[��֏@T|Pi_'�o?NZ��Ł�-s~8/D���Ţ�n��IL�/D�̱)�$���y;�A���-�J�g�0pmy��!aj����=�4,䉵� �Q�#���#��7/o�!䩺W��KqZog�������mTH
Ss�
���"�����e��S��(^���������%�U窆XD����;{�Q�'�c���J�
^c+O�������_3�n�4���:�V�{6n=ԩ�P0S���sJ�ܫ�7ʚy������iý�H�R����"�q��:��Q�A��dfUQ!Qd    (}N��XҖN���3���6��ݥPE���i_#� �;�;�W��-�p�G`>�J�f\��޾���bC��=��kҬ��L�F1ar
�P�J����H�
Ur��hd
�`�d�*\-g�z_)�k�g�l%27e:JHzu7ӫTun]�n��3��J���f�"6oI;��lg^38���vbON����5v��}3�/g�VZ������f�3�""~���u1�����]���)Yr��)����>�>���L5ZZ�r�o.�6[����io������^�g�_��2��,:��aK��R�t8U�{Gڪ\���r jɥ�~"�?����"�5懁;�����;.�ٻ#�ԁ˽6�/Q �ˡxt9�e@���>%S'g}��|���<��-f ����N
�S!���%e&{�)��ݽ/̻���c��_G�\�+��� 'Ԉ��=�_�A���he�[��46�V���ޭ�oK��$*�t�=*&�۪�
�@{}�&�HD��AB^��)0�5��Z��&P1(閊7Z[r;��h�����9%�B��y��D����W��D(�"�60%�a(*�,D����I��5G� T�-m-�)?��M0�&/��㴝RT�����B�R�:�K�U���P_U�Z�.��r �,9UT+I�S�O�]i���um_r�j}��v�W�ph�r$��d��h����!xB3��v�\�Y��Uo�ٲ�~�7�(�a�xo�B@�|o��27�s�f�"����
n��U��iq�JǬ�P5*GP}��a/��m��۫ J��%ד7���T�&��~�c���I˗�q�G�=������BC�G��쯑+P`B���B��+6�+�T�r�d�n��^��`:�(��Y�6�_Ȇ�2D���pG�Jh�<��'Ɖ�k��<�3W)��סV	�TST��j�L��J��L��Jtjn�����|#��Ӷ�RZߓ�$��xR	�7w�7�]�T�7��n�f����|�+$�$[�t��(�%�V�Ik*'jrE��VS��Ǥ;ShK�5� ��Dx	� ��a�f�M���n�V���9s}��z��fC(W�����<�P\��L:�,پ�t����Y�V�?�����bp�yz6 JJyz��e���I�h�JS��0�gT���/ �8����p�?4�4�ƕ�"M�bv�i���!�74��5�4*⬺k���AQKv��%���!z5GC�=ӻq��ˠ����	x�%/Q7\G0}��S5�4ދkKzI�x(TvK.j�BA�T�)�*����:yF��Mio45Z�0%����vM�ln���f8�����D��fډ^�C��1lZ�s:윯o����j���]��i6�0�	rq9�ƥ���P�X�y���A ,��xc��<�$0$�����R�e��ʇ��Br��m2o�Se���[su�^�쵔���R��$\'�t��C�]R�+|�s;��>�x���c����TS�Q��\�k�x)���l���

��J@�fɯb���Pc҉�]�T�H�)8ʓ���0'��x�ۼن�>	h��sOYv�zn� ��22ϳ�E5�����P������3TGī�O�Uri��ߪđ�sv�J����t�=EU����)AV���(�~�Α���)M�_$�u���G
����d�.����Q�t�A�۔C��r�S6����G&�u|̚,�$|�/.L�Y�&�E#1/j���IF��_Ѽ�IrO-���w�^I^�{_��cB�n&���"���磤�H���B7�T�K�F�_H�9� R��q=��r�d�����Kjf*9"Ipr�O�P�6��j��~\C�RMQ�)ިq9�b��U�ͬw4�,��Zz���C�����9���T��k�hXL��əA���o�x���?��)��	���>�9�\��މ*ik�2ع,C��c�l��a�[��R\��v6�z��xa��5Gy�C�隊�鲯�ɞ�٧P����DK�������@�UgH��S8�l?�+�/��	xNZ:����{`�3s�(�uh��#� ����6��.�
��r(F|��|�zJn{=�!���-y27�Z1,��f�b3g��̪�ڨ�GU���(�ڄ<?�
�[��&�m I�̅��G���d�q����`g��Y��Ѕ��U����W!���5��h7�Xd�d}^�U����P��Y��=XT"a�H��Yds��i��$�c��YQ���P��ā�b�Z"Z����[�T�ONbJf:*�~HJ�{���b���֣3�3��/n>����<�U�a_SQ�hM4;�Ͽ�f�"�6��v���OG���*uʐ�{��$DA���c����1{x}Vd����>e�Ȟu����m��mޚR\5�6\� ��6Jy�L�>4IjM�eA�2Z �)!��ᄜ6[	h�W��8���25Kim���6:����O�f�{'�����ŉ�M��i��Ti�� %���)s�H�W�g�Y�=��kY��k��+��CGs��[bB̆�}�g��C���^�\�y�0t��8һm����.E]5��[8N0pM�#Ñ�@����M��M�9$�TJ{�kȔ�حɚ��s�͎D2��K�%割��x%م����@���;i�RO�@ѧ�d7��lɐ���)o5����ސ��B%�Ѹ��c}MT�����gw�L��G߅�4���u�vRD��0��E��/�g��v7 LЬxk��R-N�U�ES5�E)/w�m� �$`H����~v��=�pfuG��"6�ɐyf��j� 7��^�Qs��S��xZ�r��H��p	k=A��ؾo'��(�f�\?��Ϗ������ ����A�0I���
[�h�2lV^��O�� 8�Ϗ]K�"V�t	܅��h�g{�W�ݵ���*>E.�;Ջ�*a TI�>XQ���/��������O4�����`��ܓ~�zR��Kh��,.8�*� ��!���~��5�����j���1-xMV���U9��s1e"Z&�p�"�n�0T��2�z���3����q�K�����3������g����I����,ZB��{�M�fk�;^^i����բm6b%�X���c��^���orF~�;Q`�?짹�,$�M4�e��M�lB��R�|$��=߻�&
V[���v/�r҆�\\K�F5N>�IC�Rǅ��@%��	��yOB�Z�\��Z��4.�R�K/�,��0��|���l,R0\C�c�iŲy��pȨ�
{y�	.��j~$�B���طiX",���F�qRД��:�wT�����-�i)����&�[�X�'�ò7�P���8��$�7�D�ל��-C4��m�d��;\8���ڟ�8��˱;ia�!#�d`���?��w�þ#w2L�������=�&�}4Siì&��@A3\:����	/���
!���q���A}5P��Z�.h�6��s�*9�D�Q	GuV�|�������P	�%Vk���4�y&��B��v�T ���S�ٜD�"��!g�#pQSTw�Ǣ��H�Z����Aɻ�؟S`��h"_Y�4�K����ɬ�o8���̭)����v�wݤD����>�%�C��0#�)�hB����$R�go�NuR.�b#S!
��g����r9���a�`�٥���7�M��A9Lq�jӴ�v���LKɖO_��e�Ⱦ�S���yʕp�\�s&�P���cZ���e��t
�E��ո�7�;N�HN�6���,������P:���t�d]}���˅�9pt�r$�k�֣m�c�w=���$N�Uk'�;��ԓ�T��o�9��|�S2o�h_�О�#P8Yn�g&��nޏ��� �h�<��a5\pJ�buI9<�q%T���8=,	��IStP�	7�� 5o>yHG$ϔ���7!�+{h8;���yݟ\0����t��(32U�'!�x)ێ�[M��W��T#��J�S�zI��^��EH8��}J���t����8����sR��ג?O-F;��.�M}z    ��3�%\c��5�f���&)��}��^��׉�;D]�|P��A�^�������X�	ﳥ_�����u���彭g�"�u8�ڌk��L����� �9?\�BK�R%���t�x�I���GҚ*%9��ً*��M]���f/�!z&��=�	����vWSD����WG}d�$PA3�^$Ѷ�f��34T��wB�{ڟ#����6�����.�b� {������y��~&a�6�S�U>"�p������T���(7�����\�e��=���(�C� ��o�EgP�����)�`I��U��/h���Lsy�w�/s'r�{qn��ȏ�%��e�����ޏ�5Aq�W{J/>H`Mt�>QV2f\R���j<d�`����,uW�2�����(���:�&����ԓK8dH(��5Y��Z���9{z�}B�h��t��#�=��
�(�r�����8��/D	?lw?�����W�75Ug\������6�ꆽ:��:
W�h���e#���������4��ǅ�r�J�G��r����RCJ�
�D�c��~{�\]z'(z�[Ȓ��V�!4щș����y�X=�l%�A�eLT!��}rA!����*L�o�2����C�5�7z��,����Є,҆#k�rr��y��&-\��_�.+��f�������Ə����dg����Է�5v#�fE����u(B�GsK���k��@-�U��`q����vO�58��֡��������d����ֻK��~����Kr���4�_-ڑ\8����yI��oIf`� @Fk�P���#:�=�%�@tw��7��͡���5E R^�4`��� ��Y����G��ѷ�5�OG��� ��5�g��O
^�I����
�X�����/�!����s.�j�A��F��Gݹ�U�8!��$��A9��*{8��Z`w���ج�"��YM7���݌S]�0�<����+��9��$߹�Y����3}���6��\��NIW������	H�╰�є	����@��f�q����e<y��B�������x܌g�\�;��&��q6h�n`��Y����`�G�9��<����^W�#Ւ4���ZǢ�c`�[�[ ��f�s5���2��Nğ�i��>TfQ*\�M���n�;e�L�����8���(����]�J9�j�FN�kP35�d(׮�-g��q�_}9���#��x(����l��8����+������e��S5\eT�tN�:�{O���&�[t'��$3��hoӑ������Ǵ�����,͚ʅ�D(�]^�n�2o��I�\br���Ly�$%��;iW���5�����9k/�'���s9��-�3x��70�d�{�H5M6kZ8�Esl��230�{z|LA����8R<.\KB�%D�ͷ�]�C���C!:$��)�ɣjL�)P��~������
�K�g5[I���5���U1�}TU�D���,��ftt�{|֒a����~Wfz/��9P9Wߢ�:Ca0�ǭ�
�?��e�����qZ�H�	��.�x�ٙ�>:r��\�Rj<k¬�u����_��a�������r�l���Z*\�a��%�\'���5�ٽ�pT�`�M���t䣃A���E8˛ҾA9��/��I�J퇟��N��x@%�k�<�byw�Դ4�M��z���J�Z����l4�siϤG:݁�;Dw�L.��3���RDYHS}�z.��Lo'\g~qW��'ӌ����)��9a���d�zFW&�ضh~
Sd,���xqaJ�*D+�P��1h�6�R`�D�`�x��c4ڑ���{ܟ)��Q��z�iz����Nw)�603eC��O�+�q�*Ǳ��h���m�u"��
��X
�6�nr��%V��4�!��u�LƝ�������5%4'��}���@
�R���«�T��/�B����ݬ�{2�N���k����N<H4�Kb��^R�����D$^��%���=�C��)��4��k�mՓ�e��	�R�L��k${����G|�f�jR�(�I�MhV�+"���f�t��Ν��xk<�����]$o�jٲ��%��y~Ԉ�6�ό{��>[���>�'��(D���G"��zLQA�+�B�Hr�s��P����٫Z/�^��u�v��ʱ�
_߷J5�	�}�=^��Ӱηh~�۲�NM�X��eB���0M�����Ɇ��"�^�ֺ�j���ٶ+z6t-J,A9�|=Vf!r��6�
d�X�d4���ؙ��M�X��I{l=�kض�~T���!IO!�lE"��q'�L��ע�q*�����kD<x��z]J����Mh??~-�6#�N�sh�sLZ�R��,a=�A���R�F����py���Pp۞F=/��Q�]�h#M�����7d���`��ŷ���z���+���K��@.ԒS_T��>��TΉ
N/CUț�-L��K[`��g&�a��$�s[M7��Г4�+"O���DX�V�y~���l�,��ȝT��@��q�<��'����q��|�A"Δ	x�Y&�#}����gwcmA T�@��BBw�.������i1�R{Ek����7��j����mq�;	���/�h�}N:iӏPp;i2H��\�'�#tO^�T��4G6~���C��`
f�?��>�`��	���fP\�l�Z+��
���k
idV�^B��n�LIg(Cz�x/���Ӕ�ȍ���Wr�^��h)�8}I�١���N��ΖL(m�QZ�֬�������_�� =z�t
}�\�\�FtZ4Nj���v�~��	�RJHj�a�#:��{d���4|���v��C�����·�f$	E5	;2�s�`�PM��C	�(�y|�ܬF��'�i�S-%�S3Ep��-�8�\�׶���6ᨨ�a�ih&���W���&)�F4��(�g�dM�D\��*$����w{����_�d�W�����^�i1�ߒ�`�i����ߊ" q1�5>�y��������>@���&v�$�f����D�&�7�8�I�Y�6����|�TQ/)\٨�w�Sx��c
vf�V��0SE�O}|La��39�6a*�u�'�0u��m���]�Q#*�����0�T�FZ���P�y�EL�<xc&L�A�F�e;���	��ȸ�2TW�g��	G���!!����
��bW����ԮH�2SQѥa�0��=���y�`$���!ur_f��O*Z�F��P�h��/�1��Y��<
#E��8���9Ƃ0����V��R!` Y���^|/�#'��l�����P�?�4T�p9��3ɣ`�F_[�`����S��[zM�K��*�4��
Wȶ6mH����}:�*x��]���*[��_�b-��qs!?�&�P�����X!c��H��y�s_ή�3~��f��-)�F��-� ;�U��b�O�6$���9z���f�U��F�(�9��y<�p�MA�	�sMզ��.�T
>�+��k�B6�>L��˱��3�cT�F���9��Q��!�i�A*��_B���������+&r��)?��5a���C����s5��A7�kGGL�S�ѕ�����.]ԣ�~���(�o.R'/q㷾�zFp�	��DMz��(B��w?A�s��c��o�H�%8JG/eI�{�^�I9-��C]
�v����A3�ʭ� >F�PTw�9�0��QJK�&�:`�����%C��$%!7�f
l)s��zgP�uy]\�7<�="*J��r'"j4!V]b�W�X�~����e��x�q����<J�Q�W"��n���I�Em��g��!�ѐ]ƀ-ˑPI:��9����u]4�>g�U�9䷎���Xڅ�
w/�����=���<��;DpK�˯�U�@�<�s�";h�.����ќ��,-B��-)4^���8�'���hD8m�.����ǐ����Bc��    �P"YG��5�|S
W������-���>�!C�X)�:�9�=L#g-�(����a��d��=��#5T�C�#���G5ͷ�QF���᫶�s\(��4�-MtlDb�O��h0�E�h#�R�����Ph���/���05�YT�uGb���~U2����Ow�p9%���BI�lW�����G��>�*�3P틈�uY��i8�Q�ݙ65υ����v�I14MS1��k��q9���ҫ8���E%)i����H��꾖)���3^,�d��n���m�.|�U=X�^�&U*cPj��y�c�\n%�DYW�$�~O�V��=����}��
�75��^~����� �����u���S��t�d�Ԙ?��1���EE��ɣ�ڽ�7BAė�iQD4��sj~�r2�����V�(Ρ��#��+���(�}D\�9>8���c��\�C��Ԣ�V�l��)��M�F2�ڟ���&b:>���Ո"G*4k�����4 ��P�&\�����y�͢X�)8�ƿ.oӅ��J(��(�FFx'��)�� �c[>�\Q}���~!��Q��d+>����������D�g�I��٭��ߠ-�lp��ww��	�qv��ef�g��kB�I���w�?���"�0��T|-*�F�%a���u5�k����zt�-��AO��=��{Z�i�4ȴ�?��^�P,r4��̃CL����7��9z�%����q���7�LD��.51�@��DDO:�p��P&�)�ϖO3>��ofH��l.9y�{e��$������א!�I[�\áK�s4;��G�~��	/ތ����,#n%�7��E��Y P��g�2���G�/���ΰ�=i^b���?!ޟ����^�G�l^�Lz����yH��L���8Z>�{�s^�{o���m�.�W��P"�ǐth�p����6��"��5��L����7i�O r.z���*g�χ�uS
q J�������~�kLU�(��{u���'}��9�!i���p��������XY^E*�2�/��:�6a�A ˪wn��F@k�������!����	-e��w�]�í7s���֒�Z����6�6��������������4inQqF;����L��/J�9���o����(���ۀ���\>3F�R�.�l���.�di�O������L�YB��/z8'��WF��a*	4|?�@;l��@J��>����>���/�B����m*TЊF��9�af���`�1g�SbӒ�P��f��ޞ$ �1����-�+���Ct�����>^�)�#���sRla	V�M�ݍF���'C|Dt<��#��,=��rD���ϰ�D\-	�Y�j�!����h�D�9��+:)�ƫ�f v�@���5A��w𼍨BU���TI�i����n�*DTLH91�2B4����B`-��U����8�8cg����}x�&�Q�啂�������V�!�ʏ�#��a^J�N�1���3pjƈh�0��XDp��Q�M %��c�}�t����c��Iy'��P߃��,3�5��RW�����g\�����Y3��i��]��#w��N")��5>�3�;��C�O��'�HK6MJ��)�4�_����T���~���j�Fv�μQ�rp��Bt4�%`��llr�ˠ���p��R)K��Y�d�-	D"��zǎy\S�P:��p��-���}�K��F�,����Z�,$+�%ؤH_e ������L�k�j���������	DxΪ��	 ��Gd<<H����a��@�4�t�V�M�5��oN��A�wvYS0�r��K(�������:�nc��b[69;������<��4R0��.�D���:xl�%�Ϯ6�R� �T�2�;�g?�Mo�ֿ�`]�n.�����Jo�1xbM����nﾺ(z�2r�zAߟ7�J�R~��8տ�#a��D�Å��������$��ad!F���&�Il_(�U�D����<�n!n�:���:���Ki�]�*��Ђ��|�<�	B��	��<�[ԥ-�� ��%d��RM��1�=^�R+��y<Q�	�ب����:�M�@��14@�^C̰J0���X���x���]�j*5� �`^��|�l��4d���n��L:I���2=���<S
n�a�Dbr��t!"Nhz�&"�F�R������,\��^s���� I��.���SW�A����|P�ua:t�{r%�uZ�5A�R�6�"��gF�>����ot~�j�Ji�r�I��vqG�{z���Vl�B��O�d#��X߭<c����<_	)o"��He�O�֪�`2�㝿=�rf%r�8^[��晔9c��=%�Z�R�A=<�w�BJ��g29-���ݶ�
���IC�rb�yX���O�`�`��oh 8���6���p��ׁ�=�P��It�ZFT������ ܵ�eU�ݜ<*���PwG/�$����B�x��F������]K��1��x1{��řT|i'W��k�`2�Q�sH����#D#��V�Re�x�q8�k6�G{DQ��2�&Q�a��x]�����uyE�zZ��B^(�YE"��a4�0U�oN�5�t�NF�)3�X㣝�X#,���p����?IPǓ�x������;sz�H��
�KK!���HL��h����=�[��G�����r�E�l��0��W�؏K�Ĝ@�?�N��w҂�yF������v���
1�7"n4l`^���o�Y+	�wV]�C�N�T�f3��C��ü{���X!QrC��5͞�J�z[�9�`���TH�����_��R����w�Tj%]��si���]��qR��8�9�9�.��>�V����~��������l��
�m�1�F9��S绸bFWg��"@O���\l�feW�R7̢��*��ţ	�7[Z�����x���f�v��w�_�s�3$ 5�Dh��;���j��GBre��0�bń"r)y���h?���~�icq?Y�Z�"���?�����v�fU<"�
]�2B �(9�\�d̩�E9��ى��;�ߗ��ǝ� l_+@O�.��U?��"�b���k񚟒�Y1�z�� vpP�`;W('q�x��BPvV�����b�I���V����zv	�|�!!��k���|#���JS���do��|ia�BG��i�v^� RqŪđS.�j���3{D���-A��ݶ�ٮ4�`8���m�q�8�3#�i:�l�HN�� y�*T��F�u�.��|:��杗��܋���gp�_�H��=��+J���	�E�LK},��'�4�vO1TA�8:- g ^� (�'M�5�q)��1Hf����'�7�;�E�O�%�� �S��� �N����ex��%p�=�ʢ����sU>���>b�]ܴY�(BB�mp��P���E�ζ80�.>W�OP�N��{[�Ԯ�K�F&�TH������U�8�_�%T	��YY����`��Δ�K8�P9����=�����;"q�d(�a��.� � �`��]�"2R��xĲ�CI$ض�[~�D�-�<�_7�^\2
o�(�V�@��8��,�oX�V�h�<�t��]B��
��pP�Qq}��i}�r�H#�����޴P�Z묈�dd��Do��	���U�mj����z"�4C~Mr��9�6��:�y�ҮSF���j&�N䵄Qm۝�N�+HRyCZ�Ct��{��
�Qz��aٌ�q��,���v:/Z��W���1��
u�M�_>��f@�|�(��b��<���n-CN�P��^J�y.�,����b5���\Ό�[�	���e�����͓T;��֬r0O�(^��uq�5+PۈQf�tjA����e���w7'/����k�*Xɞw�P 0\���� (�"�A_�u���� چn��[ C�f����q����}2"d+;N;B�P��������e/U��v��XK������V�    D��<���-��u��ZDr%£�="���=BK�&�,1	?��^/)*�n*W��<{q�o<PKL�t�Z�9�9�f���l�Y�U��^��&�'�f�d) $��_bA�"ew:�Fʇ��H�0�g�[��R���7���<���l��
����%��p?�,BZ��j4ʓ9���U^�t�8>�It=�����yq#�����Y���^�#ʵ��Y`�.���R�b�Q9Sh�`e�bj_l>�EK�Q.㤊FHxюR��a�%R�����h�NeA� ��Ћ,إSUZ��F�ྷ���s&q�.�=�=*�˻� �lR?��y��\��{������=Md$�� �N1R�%�BK�[��D4�q;��_�����k
��4���x���y�)P(�7M����kh���!�f����1��\#�R�	a�,�H�o�ºk@��Fd3gXYq�B͛��<ȝb���
1��;��KD�'�PZٻ[����d�T ����.��s�to�� �c��C�H �a��f_"�L��%�H���%�0��&�C�3S��,�e�%�c"o$-���B~1������v(
��6��M-�e���E��g���arMg���R�\��UF��{�h��������o9\w�4 ̋4F�F+�|:�Nl��E�b�@4�o���kl�:�Q����J��[���r�'H�l9�X���`�L�gFԌ�L��C���J�U;^�G�4l�?b���R$Wf������/�弼OEn��}X/�x�F��8�b9����!�� ����BdOZ�3͋xpE�:������ˣr�%�RY�s��?��P�v��Ư"/8�G����M
Tǒ�n+%���C�J�bT<WȲs
!�/�u!�k��O���2o'���h��𾿜�������O��ς%�F��E�㴺� 2I�~�P�0E ��V�t®?��[!Q	]Ԭ���� ���j��2��u����L7�.2>�&��PG�pH�����?�J���H���|g�3�^(����������KY	�jv�l$��G�{tf��u��Q���v\D���O:��`'�-�U��ۿt]k�Ό׈5�����P���Yӈ�����]!]t�W��� � "�_}!"L���-���-?xJ��i��z��(]�T��}<�	P���ψ���`;#&�nb����T��ym�չ��2ƺ,�!c�v�lxG�Ã����Y?�s��inD�䁡���� ]C1:��B��?��+{X��}�;�+.���Z]4Y�#�� ��SqP���l}{6n��L���� �ԃ�������dߋCAc)��[X�	R��1�J1�����DN�<zq$���
,�KpZ�^��o�I��<vT��nW1O��Ď[�d4E���Bm���&ʛ���8�{@e 0��`1+f�DͳE1����%��|k���{�4�9�����uٴJ�\T���@���_	θ��.����JfqUdM�B'ܠ
5蘝\���e��J��7�2&d`{�++A��⥕h��,���QE����T�Wi���˫J)�a&��7B�g��
:Ԕv`�\l��7Dd �ȓ�C�r5�>��r0�^_矗"�}�<ʹ�ͽ.R�v;��V���/ݐ��4D�$AF�s�u9��0d����)%Ag�N�e� f��uR� ��C�I������a=�3bk�|Myg����8�`O0uq�����7��,PL)�V�4�0�4��B�S~\3�g���r��<�K}��Z�I������A�l� ���d�q ���d�b�aE�+â��'3@��aE�A���hlH.�lX��g�'i���;����ɚ�"��|;/��*��;���o�������D[9?�a?O�#��a��uj�MK� ���I���	ד�J�{��f7�m���f�)��Ύ�scD����N���w�F��T:9k��^���k�C�q8����Ԗ�dR_�56(n�ҮRIݹ8i	o����T�b	ߘpym�{�o���L��59���W5 ���%��#>ル6�(�d%s�p)p����X�/�m�.�PA=�����7�|��\0��G7#��e?�We4
� �gL�	z�y<p���5Iއ���R���!w����u9�y,LaXwi��w{z�.��y/��V�?!7� �pPw�L��~FB��י[�CYC����xY0���Dz��Z�ϝ9W[0c AT�,w]�ŀ,��:�iZ�-�w�����~�Gl`���y�tsz�xH1�L�쀝��i�F0N��.���}�2N�����b�5��[�X�ڋ��ڐ���er��$ڹ���m�����Ηa����$Wc�f� av�U.�X�%YP��L�bl��"S"��v?O<i[%��E���v��:�������)�� ��1�B!P�wR���(�>�t/(@z3�H�5�
����������A�pX�R������/:h�P�\!UI�|fܳ��KaQ�s�m:��`ܿ�>io�K���0��u�'˪<��V����{��m�Ra���{{����҂Jx|���9�"�P+t���0���j�@�&̈l����Xk,E�@k���U�75 d(��  g�A�;;D����N�*|��IZ�41M[��Z�pq�*��\
G-V�0,���j4�hv�dq� �,�f�B����R�`6��4
Y٭}��	��u7'��(�j�KČ�yyP/��ۀ�v�9��i����Ĳi+.P�{��M�p�|9?��l�K������h��-4� e�	�}�0A����������W �ݵ�&0���?/��1����_Ur�E������iЌ�Eb�E��qa�X�}�3-��㻅��?w��I�f�L����r�m(š��S��K�fϑ����W�n+��nq��C����k��A
	��>��=�չ��H��KT�[	`���,��F -c�%�l�O�0����[Uk*��	亹��J/����RR`�=��-�|'�������ws�*�	��T(�Yy���	+A����ւ�m�zn����y�J��n�;���������7�.{Y\�M�$	��n�v�"����a
���+�Ex@<yiy+(lD(�;�6r�i���R�bb��^|lճn���t��\3��\V��yi��1���oV3F��\e���vo�l�&�h���K῅!<]��v���&�x#��Y��8.�(�]��ruw��6�Y� �.̀�����d�."H���!RT�@�ڶKD����w��f�#D��7f�\�MD=q#�0"%3϶�ݷ����9m��Z���	��(�f@(�~^i��bZЬ�;�6ͣ(ϴ\��3K^��:�W�U���
��x��G�2�E�9���#��M�*�t�޷z���� ��n)�
Aŋ�2�6�u�jf��k)��3��톥��e�~��x��(�J�f�`�*��0�!��w�%����f����Zj����#��v�/˕NωøQxxq���ƾ�J�1- g:I�A�f����W�6����M3Ji�N��=}���E�?Q�N��[�� 6�؂�	#��n��h��ŕpub&�s���"=Y���iV�V����@�A�s@Z�G�&*�A�9�r�܍������B\�,j�ι3���O6�5�:������侳�夶Dd��a�˅HɁ�7�!�긿�w��YHK��G9T����ZX���!y������?D)�u��&\�ِ>���a�P���W�8Y(7��VN������KI}�.R��-�W�Ӱ|0����]?Ko�SdD��%�M��WP#���'��<fx�&𡋙�*7�N���:oN\k��.ͪ盧��Y�[��V�p��&z�"d{]����'	CwP.����E�pN�.Z:�".�h>�b8���D�v������X�~�������|��_��hNvQd-ZE�)�hC�ࢌ��^, �.�    ��ע���?x��f��ŪUP����b�2�-��ЙTՀ���w���=�N
��e�)+J:���hSv+gf7�;VJ:l�.�����-R�io^	hh$J�������Z�=VW�9^���ݙ�� ����}��=��=�}�$PW5�Z��B�d�􂵗�x?,���j#Z�O���*_�y`8�Z�v1S �YyyAN�I]Rcs2�*�!zd��u9��7��S\�����_]��_�ы�칳�D88�J�iw1���.G���ԋ@'Es5��	+\�Q�i����*	*��ĄH�p<t�"�8��:.�xq���oO[�ey"�c#+GЇ���<�X���I�u�C;�	+��C���O��p���iPQ%��"��k�*%+� ҭn~����G%͚��?&�T@���p����
T�ö��	�ؙA�b*��g�v��NX=G[1|èi��g5I�
)w;�Q��f5��`�e# ��^9��7���V�"�c���톩��cD��,~��;��=�!D$腩�~ֺP�[�0�	�Rg�0����X,�H�B0�1�L��M������7�� >��=�&��{n�)rʂ�|:}|B7�����P�;"T/7�8( c`�mWG�ϰ�:�\��$etX祵P���	y�ʘ�{e��k� ���nl��\���r!Z���;D4G��
u��E��4g�	(5��l�M�Jk�y�P-u��B!P]�c��T��b��p��ƹ�M���#�1ި=�(� �6����%��bzX�R� ��h [c횀Zf�|R��~�0^��Q��2˒"뉋���O����$��_ȵ
��i��K��,c}�n�n&v ����0(����@� ��{��a��L�S��Bz�ǝG2-'��5���Q�h�K���%���S�zkV^3g��k�"MZ��@9�_7����ñ������X	�%�`�#�c��gqA�Z��L y������`Ax�O^ؐB��\0FvX�A����A�S��&� ������9k�`E@��߽�R�B3gjA���2^���P#)	�=�v��dƳz���L�b�I���A����v7�PA���+vp �@��q�,�mV�F���=�� ���d�W��;E�@��Oޓx洳���Н�M��O��?�-A:X����@�G/D��$���󤫗"���D^����j�	1 �^?����D����]�"�+%�˼F�~����R3;&&��,�f����/��a���2�S�����AkYR\Ī�=E$K�9�<&�W`�����WS�؈	���J�Q&���}�j��E��{��7DP���ACZ0�g<�atH8����4i�8���Z�Q6#RH�����B�����o0!��5c�q���ˤ�E�/OO��x+�p��"k�I���	ج+�$�b��3�	�u;qM@�&e�3�;��N�*K�9i�R�;g�,�L~Ьޡ]mX����!e��sp-&�n�C?i����|
��(8��C�+�p�&V3!�c!<�e̊2ʹ�gz�Oq��P��?���ۻo�IOA_�r�����^x���3�R9O��)m�E�R�a��V�IS�|�G7kV/��� 9�>w�qP\�X�����3�`%g�
eI��E���E�Lm=u�ץ��3���d�@݃g7�Ӱlo���*�1)���H�=�>!�x�: O�Qʱ;���-�F�~�����	�ڂv*�b�?a�C\��!%j^p��{d�%�Q�hg�W
�A6��̂)��B�ٶ��Tjm��e���U1�z�D��rV;|����8�K������_�_�x��89�T��.�
־�i��9Թ��R��k�O-V"�X�nV~� ��p���}(���~�m�F��â5�փ����_��0��vO�b�jx�.��M�p�����T�����B+�\��qq�x�f~����̈����n!���^����TE�"���n�
�>��B���<������ԘH�?C-rtC8� ��>�(����x�KeL��CW��<�=�刨ep��(��<̳Oť�'}��"A5yp�:����!c�����Ц�
13���Բ��>�<���k�|�)�Q6���%�����u���Z���N��4	��A6L���J�Ȉ0�Ji�'��kw1��t�ں�� ̗WiIb������,�XgM�J�c7b�r�=�{����g�$��4&A��Ќڹ���H���S
�w�r5�:�X��ہ5�O���xH�\:�Ӫ<�����k��Yjqb@����WΪ?;!���|���Q\���7gu��E��2O��נ��u.hdx�
�c��A��/^0�o�R��;-�l��Oy~�YJ�6����aZI"TF:Ș�hA���)�I�4���˻��١���|�{����Zx�a������§c��@��[.�VFr�ƭ��(��\m�z��F���<<M��Y�`��n1�\�����,g<_/����^�(�ˬ�Dy9�6��Q�����������T�0r��$�B�#�uu�@ݷ��]k	8��c
䫉Ċ�t}��4�1��"�� d�1-Nf��D�'�`����i�ut���B�b1S�Ǌ���XyaBQ��Ϊ.�e �f[�Z����hɁ��,�����~�)�el}��`��o$�n�E%��2�����F��������ߗ��o��\�<v($|�������+ج`�S���w@TV�I,�@m�w�}�unA�_�??�{b�{a��*i�����?�f�G9�{�aɡ�k�l�o��'ף������O
�F�W�/�ɥR��<[���e��y�++�l���>,��f2\"i�E���]�n��B��Zu�+V��~���t�*�1�д���;��S��"�c�R8��+BRfq�Z���[�%i�Gc�:@*���,y)��̢M��BZ�y3V��B�-[����5���~��2f�%�B���r��kʂ�� j����py����a	{�i���,�\�^��B�~�L(!Ʉ��_~�"�"#��UE��n���(�*���
T�Yu�nIn�!�����/z���L�[KZ�r�R|3�w�qAA��ul�������V��O��l-*��}t{'�^q&¡N����04��߷�P�q
(4 ʿ��r?.�$(�gd�-{��4�R�n��m'��;���d�PI�H�w�G�����_����`�Tu�ư�X��"��Ɓ�Ӡ@���m8zDB�wm$����[��(F���.>
 F$�����V�0���(�2�O�M�+G����"fю�!]Z�;9�f�`+���͘0�|6��n�RD���I�@�wu�;b2��1�T���e��(�a��h@݂C��-��Q�3�E�����*KV+/p	����J��u�.i�b�-�c�X�gy	J�ݲk����Ք�c!l���<z=��X�<砉Y)h9{q)�����J�]���t�x����.V"����taRd�E�.�X�	t���	Y��%��pF�v��H!Al����`��oǎi����_<��J����f! 5����%�|;��Qlxp���.vi�,H��m������+�j�*�,V�$E��L�`����{N�=����PIC��׬Xn�S`*�_M9e�g�b�@�8
5�+�
\VL_j��G��{����wfɏ{��zɐj�)R�T�d�t!�w��7��$8C��R@4��"9c��W�#��:�#bKI����-&��L�J֮:��f��ۡ<\w��a+F��n�5ʍT�tl�K�Xȿ=�Ne�`�ΈHD��� �@g����ʩ/wW�-.�ip��_S)솷������f��O��S[�TKg|��A,�~���:֜��g�Ҋ�H��|ۃ~+Ǧ��7��TH��ȃ2���{���@�L����rD�^����6���J��K֩TjL0?�:q�Y    2��7�r��f"����VyC-�������a4虸�D�/���ٶ?�Zk��� (��)V���m1F�O{�E��0��ӽ2�6�F�6�5�`���� s�\=�5}*�k"]��; GRs���"X�]���tH�^v�Z���R\��ւ�
�s�Z[�t�k��5�� �z1w�ʃ�/�:�X,����R��сV^�^�\~��zс/��׌���iH�%�k#�@�9��Vs���l6�o���҉s��Q�?�@I���C$�\1��rpA��tQ1m�a���Z�����G$#�Q?�cP1���7��|C�(�ra'��j���_%�@!� F�:�����aՊF���ʂ5�c��y����f��xvW�xY��_�K�ѭb1��/{�>��P\G�-����v���CK�g���A�$�>zU��DN-�Nސ�u�".����Y�r��:��B>��� ��?�V�8���ʋG�L1)��%��B�,�!��jXԮS؅�����+rdx�v�D�gw�r��(l�+���>�O[$�Q{K�����R��d�(VI6�˭�;��u�,����qr��b)w��Cx��/{��fK���a�&��bߵ:��h ��E�<h,R��Y�^g�59jz���&:.���WtwY�-���aqņ�ؒ�f��?���������ۊ�V^
s�t���t���a������*�	m�(���u	����D�[$n��~"��r([(H}�)d��v�TҜ�wZ�B0Z�����a��������,��q���PC��uwӄ����ڝ��E7�u[�߰���>xh$���Š�v�n����U��3�i�z,,5N4J�@-@�a����y~(�зs�yaO����ч@��	&�y3�Il�]��TD�����X�]�[�����	�W��SJ�WU46Nvի���]�Iy�1Yw!��U��|�	:N��P��V���8��1F�Z8G�J�������%i]#@)���%�Ŀݱo�L����`Ơ �ҠFϿ��.kaEH}�T��ǰX�q��Y��ZvM�-�6���V@��)����#G�����N�7��h2�0��q��y۫_$Ce�W'�VaO��F� �z����Ō D���?\
8��Bw�e�� q2�\B'�����謱�Z��x���g�k������[lk�,�b�����%��ƾ3C8b�k'�cnka�܍m��F�E��a�1J-H��� ��t��^6��+�xB~1c,"��Ȫi�4��D9g�r�����ؿ֒�Z������Md��[�\��N*���I�7:af»����^䑏\��A �{p'D|n?ZìEk��m�NY�Q,u1�_�2�������]kN�n��XƄ���8"���tRfA���K����/ �kͮ!X<�`��wo:��;�>̾v�A�T��[�x���1&�[H��^���`��u^�#/���J�ԈTbMض�����?�BM�@N�x?�k�S�0��^��Y�̜������ j;���Q���-�����)�������ySWqP�Z�:�:q��{�z������0�;J����w?wg+��\=��x��
(݋;�[�%
HD`���"bd�o��n�L���>�\�����˲qV|�Ծ�1�YDh>FAi2��R2���j٠n��$�fu���!������Q��pd������e����KH �찌Eo^[�Y9y.�I� 
���$�x�z5�o�\�F8�n�SfS��(��d.p��W���`��v!��';���� �nW�b�?+�$�*q[�f���9�H#�|(Pط?�
�J�p�.Y������/�(Ϸ��#��>�r��.�0����g�� �/�,1�Ii�����-@��O�}^�}1��?/S2�;/PRj?bOr��oX�Z��(���B�Q�.?�d=������;[uJ[�N�X�R��O#�Z=?Rz[Kt�UI�5l'/�d����.o�S����9*"ԗ����L.lR�Ao��8����59	(hJ�������o�o����]r��Ț>)3uT���'$������m����+d}^��9�i*�=�O^M����>}pa�7������Ս�������A�܍��%J7�q^�:��a뛢�,F7��,;I���=��8����(�|$��t��8���k���Z���A(9Ǩ�%Ĝ��<l�Wvh��*J���㡪?!�z=��Ʌ�2�JfH"���z	��q/�a��ɡ����>,*�ƨ�r�Ț̽'��x�b�	����K�����5�b�1y����@��DNo�d�%�5�F��H��0,A(,���ݿʆ�u�
���v�P�d�r��s��	�|�Z��;�*�,���|E�$m<�I��h���B%7��:0�twTv�ʗ@���'_� C��T���K0�F��V����6�x��o��j��$H��-�h��̃��8�G�w0iR�, ��O�!����9y��΍rf�I�VI���.ۛ����|�l+�	���h�t�(�����(�p�lH�{q-�V ��HT�>�}wR�<�1��A��ߤ��a���7�����K7�jM ��T�4��U,�q���4f�0�3���W�� A��'��͘�|oϾ�(�|6���4�8��G�)��P��{HE��C뻭�Л�!
���]��ɥ|��
q�:��fV��� ���k`Dj��l;S�f�����$��t;��oS�?����M��B�����_��sN�	�b��Kym}7]Q��'R֚�<B����"oJyػ7h֢��A���g"��	LtI�(̰��bڥ �Y�Ӽ*G9�i.n�U��J����}��O�I��X�&��ӡ�w;�bB&h6M`��ֿ����#0��n7[4|�s�H�,�m���?!� ��#;�5��;�)��8��ٰ ���Xel���c�V�O4�Y`� -����[�`�t�VNa���3�R|�	�o���ͳ�ۚ���:��H��v���)���lO�#��8j�R��.��%�R���p�K�x>����WȘ3�V9��3�D�=K���#=y1�ڬΈ3�a���z׬L�ѷ��Y��q|{i��joR
R���<��nA�1J�P�pь) /����d��E�{m��}��u�F�������^�����	]=�kJ���y\����c�k"Z��S��V"�@�'V��D�Gv���N(=��d]�����O��B�P�;��JηŃ
-a��"���sD�F�Q)2-����F���������A/�i�4	8[��U(�|+J�-Wř�P�T���(�I����`H��J*^����/@Q��裷iX��߮bMrk��ő��Za��8�a��&��׉.���C���Tȧ����Z�̦�F�ǳk�SCU ����z�S9\�,�+��֤��.�}����@��a�x�����v���x���5�F~&��?@���X ��L���o���ص�wؚ���ր�{tP�����F BY�t�B0��yy>u��,��H���=!
K��}�/@��P^a���et�ޒH%t�Ғ�l-ki??!Z���ě9�(�s��8���*8;��?}�������b��p�Z��ba��5>Y�I���]�\E�V�H�%�	� �����w�3�ȵo���"'O+���E
&���e�l����B���#�'lq��������N���N��%�Z�5}�'Eb�e�����D)�o��h��9]J�[�Ui�Ѿ�"�Vo4�3B5�RW������a���m�vy	�����=�,/���p;��'W�P��n�m������ Sy�tkr!���|��/�a��t�
B��z�tb�|M)���p��l�X�����
!����4z�~Q �?.f�b��?݄)�������7j�k+G��DK    �4��uF��pjBF�����8��&�8������[& 9��d�(RϹ4��s8��Q.@�L>qu�%rqO��p��ߖO�2a�v�|�Vj+�`��58	�1�#A�!����G*t�819��j�b��6_����@�D���v�vxvPE�{⽰8����&��Xvn��y�Mdk;�L��z
�|�o��i����v;p(4f�,-� %K��B���*��e4Z��OB�����^Tɳf�S)�z��Y��ã����2�dP���8��k,Y-=|���J���=zV�� �^�'�� �W
l���uN�4��+���p/�mw���mz��G�,;*U\R�_�AE�����<�ݬ��� .:.A����R�$U,ͬ�s�sҌ����el����"���X���v�S~�Q������udur:�eqж^`�.�59'uc� "I���ȳY��b�0�?/_0+���Ƀ��?��;g+�^\+Ǖi�(?R�2n�G���"�t6���E�<G�����_��ug�lu���I�0��XD"��X)u�c�"�e��P��p���M�ӖC�h��n��L�]
˃:��j�dd�6"�VЁ��s �ja��;���m�_�2�i����Ow2mV�&����v��E_�/`��e���}q/�2G�s,�FƼM�M�Đo�|E2�K8��!��#�o㩗�����/P
o@P֢bhA�"Fחpa�'��j-D!���c�6`�U�]��G�gs�nMs9��úOGl�H�����?B̤���6,R'���K�F
��+��J����_��� (#&����w>w��C��G��M�%"�{y���H��E^i�����T�3�k�X�G��6����٫{Jè���y�������D0m�!�Y2�p3� $�r���(/��.^��"�h��
�B1:F!�M�u)�%���:zٚ�-w�OFd�)�������7Je(3��dܿ��dJ�?�̺!���N
�~�2�
���f���A���(
a܃��?	�x���K�^g�6�(�����$H^��})Ltb�� �R���z���ɛ��X#�C�EB�A͛U��L�kN�Y�Fw���gJ��=�1P����܈-W�m�X+��,��xx�
J�K�Gi��q��&h
���lF�<�-VL#���3��\x�!C|�~j�Н���D
���+AJ�L��LĹ���Z�P�B�����ʙKwo�, ��C�z,��Q/ܬ�£n+G�������xd� �����2ԌE�s��_�O�PM��Yk_$P8ۍ�V}6x�+�;��w��CZ)Y�J&	sz/_N��;��E���QEP��r�/n�������S:������痬s�9�:V�2�]��B�#�;�b�w��8U$_��0ᢴ)i����uH)=l�EP���C����H�2U�-R=���5aOBgNf^mf�g�1��< ���GO���7�2�r5�Z1IC�t<I]�+�k98��pF��S�~^v�"Z3��
mX�OR� I���Ks�a<P��j�*�`�|� �Ş�
�@���ډ���X�֓͡T�A�5k�"nz׃�C��1�%��j޶���Y���g����&@����C�ŵTo�jj�H�(�d�CBRf�ѽaI����&���>W$�Okw-E�	ߝ��G��l��ip���1Y�C �e�`���cY��fg��/�0ͷv�P���+sK�lX�l<{9�[�^ʌ������t�* �<��T(
�h��f�TN#��НLw5^��Y�0Nv�[F9m�J�y4a89��瓗���f}D*��e�\�d|�^ �r�^�y��,V��|M��Ά�0��v��Ꞓ����B͏.��6�,�`�XL!AJ�g�F��T�3:fL��C��}k�X0gv���f��	��+�ܬ�K�.['&����6�X�����u'�vqE���
(�e�t�b�z������4���:6�nF�B�t㤛��2�gz�Z\��/П��K�JJ{��%.�������5�ވ�<?� �n�FQ���0�
*���-sΈ���K7��ʩ����(G
g8����!x&Ή2�B
M$}��0>��
hfS�Nl���q�=2y¿$�ʎbwqȚ�%a�09�c�||��;O/]�Mq�|PD2AD�M�BE� an����/��ȴ�E�T@4F�@$;������0�6d�M��"��ξQ�3���}�H)�BN��("�p��@T���Hp��7a׷�q�S}�x�s���䵝�(߈?tV�" �.�>Y��#��A��%]>�2׃C
I�S���Q�^����b�q16oP�4�v�T`�:�_���X`pB�]�q�h^���kmE�����Wϒ���Q�"�s�!��B����~R����>��+4���&��V���_T.1ák�dR5]��$׹�{ D
�;�B��oO��lv��W�O(��z�
*��n����Y |���%�ug$���V��ow*�6���B�7B�����A�K�v)�z�.�*F	�A���,c�q:�D1�v0L�UP���V�wE_�bx��Ld'/Zt����h�7X�RyOf��Xn��R+�.�9*_�x+	å덞� ���,�*����߾ ���6T1�^B�: �����"P�C�����u޺HR��x����r�n��j���f{�H��H�����x�K�u�h����M�ܯ튪�z��i#���Ak4S��#lM��)���ی��юtEp�_|;��*����_��-|�;�����jyzQ��~�ֿ�4�l�+9��()1�Q3�CA)�gf�ʥ�����ɒ�t��B�s7�J�_Ov���kצ{�",�m�(�3X?E�p�5#��u�.�� ���]vM������!dw�uzM��9/�{���U��"���+C��&L@Df��SX�g�"�V"��ÈK��c����@����'$AjA6ZG����u�.S��.�s�j���3�[��Ք׉�;�y>��_��������;�[Fl#d�/D�`н�D%L�	������������o��rD0q��~a1��Iy��u22,��o�}���׷�T�n��ߞ�/o|P,"i���U3g,�?k�p�?cD);be�\#F�#�aR���c��o��&����1-V�Da�޿�{���ߟ߾~�&�����lM�Z ����W/��}zwMh�>5l���/�Z�5"��p蕞@��fu�>뛻&3�� _	�2b'X���hA�u�yp�A�Ä�|�����߾|ywX�:|�����w��L�c.B*��LyI��>��v�t)H�>������f`�W(ae�ύVi�B G�Y	�3y�l�S&�����S��022$(��}��冊V��3����]�����?�o�
D����[^v��a�����WUkfZ���Z+�Y}��Yg������K(�޾���������_�����ׅ�����y�G ��o�~�xw@�:����/D@��޾�� ��uhާ�o�~y_L��!`��B㸻.,�o_���ۻC�A���ﶓ(Vm�C|�0F�\���?�S���o�HA3<�v�������#!o�wx�xQ��O,(}�9!s�y�������i^��'�ڳ�(|���j,5E1�C���J ����Kh�{@�z}�UZ�U�B=�j�Xy!x������&ث�!�X����}m�폿~��S	v��v��2�TV4�Ln�A��a������>�Y�K��y��ah|	��!�c��J���K��V����	��۷�o_�_�#��˷_�Nس`�������o���D7�O0V�'��R�9oX���tHPX��bo�.{�E�����?��m�%���s��j��I���7'�L��y�+�Ҩ������_���e*��߾��W�\���w׳��$e����t�@ش���L������F���kŪ$:/�s��>��.g��,��ICTX2�=pRu��hӛ!u����{��B��ԉf�Yg    �4�&U�����/_��Py�������>k�2�]�_�"z��5��!2�nEj�|~���^��	n�nz��ǘ����n��A%۽��0>c���6�����}���.��Zua�KOʷ��#�~��$I�K*^ǰq�ǹ�ez#6��vSD�~f�A57�&:9���h�p�ZA�9���̠���U7���累�V�S��,��o8�_I%`�V2h��u>��T� �O�����J4e/����i��mwYLv;;����[U4J�H��S�*�;u�ۑZ���x����T�?O94�9�6��OOa>	g�yHE����f��2-�����*����Aʁk@���JjI�p�׀��48g�wDf��L���J:GŚ�#F�mp��սi��3X��,\�Yv�0�_��߷o���1� A�4��>��c���ޔ�J�q/��.���0w�#���1�>��
zӉ߶�ˎ^A�F1|8��-q�ň4dUBAy{4H/L�a�ZsX�$�� S��/O1����=�?���܀�F0���T��c@~dR@�K��^��,�?��?#��*,�8�bf[�~V
d�������9�=�����6|`@��CԬ��?���d����	2V���a�*����հxd�U��Mv�DN���K�)�.s���� =[R<���o0�`����vHο�6�g�2ЌL�8&W�^�k�������r�� &�a�(/^�U�TB�@��%yG�A,%}Y��rZ%ж7̈́R�\�5S�p�j�'Wm�h�O�ɴ��/�!r��}t����0}by����4$�dM��{R�]+ja�<wN��1�j�gd:���B#��0r#Ubqr<��v��̳hk��K�^�kA6M��ya���.�˩�p"�V׽(���*�B���.;�{��mOJ�3�x�����F[ي�<���'�Mn�ˊ%�BraASr�0~'�2&O���oC�񋰇�֫]�e�{ߎ����QIR`=��*���O�y����?��3��a�P�ۋ���4��
�b���q�����DR�'WU������#�ݥY�Y8,��|���Z���V*��"�S�b�7+�A�1r'�]��cg�/���HHw:��dO۴�J����T	XJ��s��w�����K���t0]Fk.���b!sZ���v�/堁��Y7�]k�qd�A"1���Ϣ�,��J�d�V@}��uL�ju�g"�����Q#= ��~�~~��B ���IFo�ʵE�BoL�@�N��/o���ӻ�b���o_�����>/�E�ӧp~{���g���ۧ�?�~��ӛ�*@0�|{��]Ǫ;���I��Y"� Ξ�֝Ɨ��6�W�?�����A�d�Y�����>X+M����L���������q���v�]?��ݢ���C�2�T^�	zCx$��	$�������Q��8��߿����\"X��	���?a��r����t����oi���az=�w&f�\�� 驳���\[�D��a{�˧]4r��4�<�܎`���Q��=����t�,�L�XCA�%���,��:��5b�&k��f��=*ё�R3���LF@ d|��0ٲ~��*��BZ����b����t(&1��v�������F`�B�������uH&q�&܄b����9�C�kη6~D�R�b��I�*-p�fd�e?&�6	��:q���v�_ib�W�L ���=>�0>h�d{����p��/���2�r�)���U���eg��'sT"g��v�W����G��F���}K1 
Ӭ���o+^����Ky��Hc%�����	��m*���[�6hp� *�������o��*�@�w�E����_o��2c�����~6m�Q����o_��vU]|�&r2���x�'�c��<`�5Zb�l�^�>�>|~����k{Ppz]�����A�B�,��-�ߟiO��ɒF�u���bzA��6��Z^	���~��od�߬��{Ko���/o��o���^���_��J�a\����]\2�e������H�V/�������Y\zv�#���/a��nV��<�v���G8��_���P3�5_��������T7� 2��U���/�}A˱�D\�-+�h0�4R"��\u�	_��M&|���ęe��������Һ�:�(4��)/����o�����/�&Xͩ���z�^��C_���������Z����o"r�mP��u��cl[�u��Oji���K$e�U��GyNG�o���nZ BY�ً�"~��.�	j~�rS�t�%iXh���׌Ze���3w�/a͙��HÙ��oo�뎑N�g�g��<y\-rIr+x�>����/��z���	s�g��"�j��3{QVõ��'H�.��.h����@������%���<��۷7���{���tp��2�@$��%����E����9
��0�c�l�dD�ľu�J�l��Iw"pL�F��e�,�Z8�WQ��X�Aɶg��T�N�*�4�nֳMǢ<cX�ޱ�|�X��`��!V
V�^?Óe���������Ӈ��ueA�rx[�-�·��.�5'���A���Y�0k[���/8����x����o�@�ۅ��?���Ź�o��}�Ʀb����;d%��q>�G� ��'�+�jƙ6�j�7W9��A� A�!C|r �I�_�$���/*'3��a0���3?,BR�x7]!��|�{]����Q�8X��#��vb�b@�)�1c���O��Μ��\S�D�\/9n�*�H���>*��ʇ�<���E���Â������Bm�5����?���%B�A���N5�����ߜt��߾�����
Vj.� �ޠ��ct[(m�l�F!)�Do��3��Ӛ��Ж�U3|lr�%P��37z����v�;@؁���-�Y��=V@�@&9ׯ<Q3�Wγ�_C����)5g��jC��p��(B����q*Q$��@��<��1g-��4���r��E"��YSz���8��,E �ߣ�Kw�9^#������+���^:IXlXQ���Y�w7�<' z���J��S�.^Q
��c�WX4�����Ka�4��N�yY����'��l��QO1IZ���k�'�� �_�7D���{�to/��(���oʕ0�$�*rD,~^k¬z-����Z9����5��7�@���]\��@c�L-��~ޟY�,�h�~0�����>�E_�f�Ȉ�5`���|,�D#���E�ͪ��B)�=v��_[I�P��]^Hz%PǱ����"�_�͵ҕE>W�N�X�O����{��~�C+�+�v�

�Z%�?,�f�%;;���n�:qЃP=���!���J����7���.?�o���@8ϥ=�6#�� g"����w��I�w��\{��14��0A�:��3�[�=wI%�w�X�����|�*c����:�b�9�_[9'��n޶/v|�\�{������ &�^K���;���G`�E+�XɰMoX�A�!�C7]#��^��'L�����~���m���y�3I;��qE�,�F��k<�ǝ�WB
wt+F����k����������!�`�\�rF/%U����HP���!Bdg,m�ɥA�j�v�Py�;���C]�v*qˣ���V���
UOrMu]�Fҁ�]
���>��Iר��T��X2�Х�H�Y�ab�@4����L,��2Jp�F�)Q\����s`Ŭ�1�e�Y�pl>��4N�� �K���wZ#U�:/H&F�5a��X���Y.�:xkXB^.� ��xU�Z�¿(38�k����[���}+-WۑU��"ﰮt�6c2t��t�)k��c��L\�$�E
&%���w1c�='�an���~# 3�Nv-�� �T�]`��>jÃZK��e��mV�N��BT�`����s�x���{���X��������&2x��*2�)�6�-�a��g����A!=� �l~�|�,f�i�A�)}�T�Ђ�����"�;�5����\^   �^�@���Q"�Q�3��	R��A�Jk&�R��cT�ń8��i��!��wF���6�q�\��"}n��s�5���/.�|=�Y#$��LW��2��N]��wwI��r�|n�S�sk�z�n1�Y��^�D����a��\����3�Ξ��ik�����_N�0s���[�K��y�Ї��r�}�y\1<��(G���&-�`�sȐ1�3�g������%1$ϘsJ���v�B!���_}���9hJ�Ϗ����Q��l      �      x�ܽ�vǑ.<���s*g�%/�Qb���-�K����,�&	-���o�Gd��QY@���&x����% _dT旑q�����څ�]�r��;�)g������7_�����_�r�����ۯ������x������w�_%�\G�a|�g��Ӈ���77W��>^�r���M����� _8z��9��C�������S�O�]��s�!�h���q����w�7W��|xw������F��r !~�������Oo�����J�����C��O_�W����q����߳�o���J~��C��8u�`��EI/��\ȉ�kK5����hm��dߥ̐|#H�,&�@�|� �́�~���b�f˄�]Ǒ����_�Lx�#�.�W/���������r�U��ƻ_P�r�(���-p~��W���\C�`��銽��۷!p��rKʆ�C[�d���o������)��v��,0�p���)5�\�k`���!7��I��b��[Q�����F��.#�kly���:��U�x�[r?@1x1c
M���;L��aJX�;FS[��8��$��D��t��;`n�e���aᬶ�
� s�gN���ۮxLZQ������]S�H˻+׿YC�ܔ;�-��Ϣj��3�!p0��Ո(���7�������d��K:�H�V��'����\S`rX�Z1��\M�����~o���0�/(�"�a��s|-��J;$��m+�&̨FO 1���9`���©�!���5,0+U��m��瀣������߾�}�۫_�����_�v��w����뛛�����7��������>'��w��7Wn��G�'f�/f1F�����W��1w윏�����ݧ���|\u�٪.vVj��-0xnz�����]����u�\z�����	����ݽ	VHs�cOq#��ik`�)rz6����5B ׏�l��{�^�T����l�P)+��7��k`�F��s��h'Y!Q�r��>@洓0f=X��z�p�,�8�
7�+���2I���9,�7�����K��G��{��?7c7y+~������ʏ����͛��<�΅7��c�c�0���^�� ��/����	D�+'�	j����`����9����X�b@�M��<�[��26圐j`Y1{$?:��y���^��՟��<������h���r��B�ϳT7)������%�GF�GF��G����L�[�PLS�K�#6s��%�OH~58��c�D4"���]��z��tC50p�|�<����~���퓚y]~d�>
���T����ވ�\���Q����VDPϜ��5B�!�'�G���_C��wK����.��4P�%�!���49
z.�f�\��������޼�l����F+�\�������3vY���6�4�f��Ruc�b�-�,oj�u��ZrR�dY?xb�ns��[2`1'2��P�2� ˹r^L�4�p�}���7���E����;y����ʟ�C���N)�3ż:cpz�Y2C�Zu�Rƶ���&� �.j����^Y�x��Ǐ����:�Iȡ��� ��/k�T��rS�S����cƭ��9`�������t#U��}�FZ9)�?}�( �O��?��ݷ������Om�	H�Q2��)K�w�M��,��x@r.��&�6�]����n&���ي����oL���Y��Y.pr�=w�E+:��-���@N5���Ɓ�g��lEg��!�1;rFg�YdJ�����g�i�ٻ I-� �}S����E��f.��ԤW7���o��������/w��_���;��w�Zh������r��Jo/,&{��s�CꝽ4[SL������<�f/L�[���t[��A�5�����P�ӑ�Uj	�(���^ԇ���Ɇ�y4xg/���e�L��YNg��p�s@n�:6j����,g�Q��{{��/�9�9����~�{��۫��|���۷r���޺���l�r5��꛷���#��-����%��� ���J]��G��Jy����[y{�h�$w�_ž\���Oi��F�4w3��ZY��[dYb���ww>yo/�W]��ɷ�v�"T�K�(4X�e���l1t���~��P�X8t^��m����"u+���7[?n�k�ya�8>�Q�d`j���jd1�A�y�=n�oU��Ȗ���{��{+�
ћ\�m������$|�]�o�X�3b��i`K`����ō��-p�����v�a����_}w���<�|�����Ȼ?��w�ȿ�ꏯ��������ϋl�a)��G�M�b	V�C)���Kc�Us��Ǐ�V
�l*r�<��r��
BK���,4�(��2[���h7sϻ����&�IB�l'EK��:I�ܾy���|������W�4�Q�r��G�[`�[�#��� �o���������0�?�����/o��n��?]`�\Oé��~9�ϊ�XsMe�Wq�|�����,%���E.=K�-�s�R3y׺�~Z�������E�:ɴAS����g�	��,�s	�s5�F�ډ�r�f��˞�:���iwk�5��1??�OSd9��)��|�=�����/_}s�V3�u�~���ݾ����_���7�?�E~��܉�A��d_j+r�y�v|Ts�xww��7c=r��a�qɜ�De}ٸ�Bۤ?���Y/�s�_��E��9{��C~x�Mwm��.�5�D,
"��z�5�:� �1��z{4��Io�b��{�oU`���et����Ӛ��ۺ�̩n\G������m%����;����"��]�\���8.y둵jQ8'�6�wo>hb���ۻO�n�G���������y�Q�՚R���~�c�l������&�/~��z���m�bG�8����9��6�����,�k�[�|p�k�dK���9���G��s1��Cjuϙ����A�ɓu���?W�ի�Ī�(~x�n޽y��ww7o~����^�}����'�_}\��a�w���"=*��n� �HQ�l7F8��#a`�r��n����,hqK��M͚��h�:���t���&�s�I�T>I�Kƥ�`u��Y�D�� u�bv�Y�Ln���ܭ�*JFZ��|(g�V*����.�iCK�9�hYM��"�@\U�����u�A�5�R����}�j�N��q��&h`iӊr�$�5Y�G˜��PS�"9l�qˈZ:S�����F�v�X�3ɿ �Ħ(�A��r&���`��^]7�#�y̩ԟ�șc ��ҥ�(�k�1�#����wW	w_���r?���,��XZ���q��eyQ@�=%���2;x��� �Z7�I	5nG��d��Of�[��LN����J�d��Bɣʐc3�I�R�s@.���7o�MQ��埯g��WEK�e�7�w�U� �,�
��<h����k�]��G���˳ڰ>w�"R3�8Y�P-��N��pn'��T	���˩*O�R��N�ӟ�u[������eS.}[]���H�MK�@y�L���2E��c�SEb�O.O}�I�\}Z��9�8�r��5�K�C�V'[��1�@}�ᘯ��`\}��t?��I�_xp-޺#<���H	�`�'C�|�};�ğ�LM�+5S7�����u�����og�K⎠�kh�>�N/�a�J�Xh\5�b;"3tQN�����ZI�a�[/"jp�c��ld̵������DF������-�y���3��2jDX˞����gl�Ò����� ���h��>?�c�FX�Q�(�.RI=mS� �(�V[1���w�O &��;�Mc��b�,�v���6�d���L%JE���Q�6l��k�����f��T+:�L��8��?�wF$_��Uڕހ�ի#���P�Cn��;���Z���nVC*B?;��/��<���h�c�
w�/�p��U������^��v��]vF�52s��4{�s����h�m7��A7;J�`��|�"}�V^ �d9(���P\�Ĳ,    ��$j�&N�WyXvU8��Rl��0bؾtH����K��8Pc�=�F�_P�? ۅhv�l���D�PC�s�vF7����_�e�^iq�d���z��ӊ���v׃a�\i�z��)&�m�r-P���C��*�y0��*K�.���.Fntʇ�_'H�K����f���:lWz���0��:!jk����g����K�Q��DA���c�9Oy˴�G��&��i��Z�l�ї�^V�*��YPԜ����U yZr�}�����@`A��q9s�����?7ǜ[Z�Ȁj��; ��([P��:��w�G^Mp��n�р�f���*>�,(i�\�f�@����߲J�l��,hм<�ABͶ{
�gn���f�e��Q��o��5(h��v�ɀj?h/��1[���!��܍@-!�����|�e2�O���� [>Ҕq�t��o��l	K�[�n��V,#ay��`����H����k�H�2�R�衝),!	��*\L��Q��� ���YR"KH}z�fu5���wvb��n�ZB��ҦԮ�$KH4�3���Y���vL����Z%�A��������P_2%F95�@��R��3G+L4���v���BǄ��yU���>�"�` ��ܲ��1QiE�'��ZPA��Z��	Zv���,p��
�����'�lhv��&W{�a?j#>�h�|-���Zl����ׁ����+�֧�Vuq��dC�1���-���th������J�u��|�77W��>����^��[ؤΙ������7X�2wY�}}S�1��Rˈ3y:�4�M��ݲK�7[\V'X���!lv6�!}��!���\up�{c:�9��tf3L ���ԶK1d��X�:�`5
�e��i���v/��--��w)��G6���"A��Sh�kJ��7=;�����M�I{�7ĵ�C���<l�^t����?	%�|��i�k9Jp��+�Rk��RU�Q=E薸������@웮����0�츦����r�(�����uz���Rn	kX,%1Q�+]� Ԏ��Hm�N�.[d_Z�e��ٻ	�$�r��M�Nj���C�D�-�{�`p�:�^�C�k=Z�2@�yy�a�>^�Ҭ�d�L�Z��8��?��q:��.��e�	��͹�bc	��sl{���W۩�e�cÊ;�f�����-O�0���e*�T�-�<̡�Cɐ�7���v�����#�>�Cn�R���y,��\���.o�LY�X�R��ڎ	F`�\�����X�� ��W����F�5r��c��ל2_B��_n����kdF�g��v��,r����X��[��>��?��Do��"}b5�XjH�hB�3D˅�ʹ#�p�:
DK�}�X䡭��� ��LA��k�:
�1�>�tpG<��xQ#b�-u��^�W�dE+�R�pזB1�Ƞ�u1�gv�Md����
X3,y��^���Yx3q�/Dw`W����{���+@���W����2Q�$�ff�ų���F�1cl�2��(ɖ̨�_��Dյ����4n]�E����r_�]�T��D���ɚ0�ЅجL�^�*I���R˄��}�.�y�2ad{yhg%ץ2�ݷ��_�9u�="����lYޗ�����2c�Υ4RH��e�<	#[����2ql�8K�%c�s��{�c��-�2 �|�["�4�����;c2�% �C@�B��V�5���5O�a�0�ZF�8��a�0��\�
j�Gg���&TC�� jذ՝x4u�Xgh�~��P�iׄ쵁Iӳr���7��PH�W~�����p���򀸾7�pd��*���Ώw*�q�}>߼|���s57jƉ!�e���9���\�B/x�q��|mO1�ZF�G�j
�N�#���!G�f��bP�!��e�M�Ԋe�Z&��[Rz�<�Y�
Q(ȷ�ψ�j��+&�� ���
ђ�jQ}�nR^���v���"ج�<FK����u\I+LKa:mċrCJ-�^��%��!��s�<�d����8�O�ײ��H��ev^��fN;��pbjɊ�.��� Q;�BbZ�P����B-�Ɔ\۶�q��wbb�|��jd��R���ϥlE+�[ƅ�-�Z4pf1 l>�N[${Y&����[>��O �D!���XC���_�E��JD(M�\�ơ�a�L����Gp4�%�2��7������J��k�����.�Ұ"��7=0�p�s���U�z�?�Ǻ�z��Dò�#�60S_VnXLú�,����0Ħ��4,�9g��#�!p�;n�N���c=Ȥ����������,��	���q�������~)��)��luAk$���A�79�ՊH�J����
&giU�$Q��(7 gIU��N�,@�^��Ƭ�C����-+:�e��K"/�k��%�,l	�k'ߖOL����+3v.4-w#��ݢZڰ���R�O���Mq���2��y2����z���|pm����������c�ǉ�h��X�����,�>B:G�6�c�[�`��8��ڎ%�쩢'��v`kaȂ�MꯧD�y�О˜
�-u�Cx��T����lR&�&�Tl��e!��,#���2�"3����6�`p!��=Ĉ�I��j�נ��ki�A��A�jB<���2�\��a���zs�۟~������,t�Ã���#�q$�!�~}󯧳�.п�ޗ_�mY����;�^z+{R����셇Zx��0���5?�\(}�=v!�|�۰TC#v�|8t8B��
B��d�NS�P:2��N$��bR�V��E��E�>�5�u/U#L�X���Q]�{G���<�<d��<���9t�7~�����}jP��;�3��l��8�x��<��%�#�"䠙����学��R{E=��O�(;�V�죈��YLoGM�K�Z�&oK�8;���b�؎�*ZN�Ur���� ����@���v�P\q{*���u�WC' Wĭ��I����� \�y*I�j��ppE��������%G�s�L��j�ї�&9�*e祎�J��V`;��	�SY��5��8Zٹ�a����z��'#{� �36�Q!����G�t����v�5�$�g�궷�v�����K��p�@;`eL:�]�i�4�X�~|�M�QQ ��5q�1B�I�"���#Pj�!���fA.���=2��3�EK��7��m�S�J��A�s�
B
�?ٗ��a�=����^ t�e|`XK�W��_�Z(��eRð�����N ��M׋���5��4�4�&*�T�]䬣=Z��7h��Υ���4,*b���������hq˄Pھ�%n����W�0(4��7h	Sv�y�NO�aa�	0wb>M8��]k�:k�qda��������6P�m!�&�̄�Zz�c�Z.�j\_&�&P�'�J䔐�Z��8}�y�-ǧP��:FS{qQ���gP���e������ܒ�$���;���)�"g�M�;��S��L�-'q1SՃ�ZrR����3I�eU4�15%�;��!�&\��Ԟ�|j��-2(2BHU�ĽjHV�<zZ�R�7��\�(A��cvʇ���=RnkE�l����b��Ɖ�\�܅��-v���Sw���
s�傅.�81d�14h��c�CN���"c�r j�o��!vN6��V�+Ԙ:�,�@MUvqW~�!��;�X
(���t2g�{�݈�J#M��M��3ȐK7-��SS�,{o�Ŭ���E��������`�9jQ_������<�.�Y��]ۭ�� �]0@�V
�AFV���Q�-rPODhca�,pi͢=�rc�l�է�9K��7��Ȩ���W�Cw�(�O@j�DSÌ{���g)ȣ��$&��}�Gh9�a�Y���ԬMb]�(�e`E���T/�u��q����w�7W��|xw����
j`��S��D�f�'Z�2��s�Mk;�4�;�9WM7q6�>huZ�.AK3���2N,EO-�z1z���]�çm�7�(
 �bê|F4��_ോ:�1Z�B���ym/�l%w�F��ܠ!�    �ʓ���t��h�-n��Y��C'��T��Jd+�}&`6Ƞ]�;@ʮ�%gp�Jv7��0���kXM���.g�!j榎1�\:S3k�1��3��u�G�M���4O�ChZ��,na��kz#P�����H-����쌥�ڗA���I;s��~���GW��j��Y�7	C��2e�����1��U<"I��rk9EZ�7�k\"m�4}�,.�A��b���hpտOg��C����fM���|�}���̼��ٵd+�d�=��c�����CQ�O���dq���s�����t�;������I����*x�K�~.:�-���b��CH�)��a:-h/�h��u5̫�q�4�Bl���ä��I����7��aJ}�[&]�|ަ�a�|�[*_zGMכnl���[�<L�?���H,I�&��az|�4h��Ӗ��az|�4+r��1`S;r��tJ]�c5�凍hp���u�0sS=��-���Z��N��5�6�qv�|U8��Q�|�6W�=�>7c-;p���qN�s�=ղS���#=cٳ�ݫ%d��tC�����j	��-�o`J~R^�1�j���ҹ<�4�����ɲ�z@��i�{���dIKv+RhZh��R|_�)�yz�إZ�p��]�A� bR~iӑ9UT��0��&�7:�C��nܲ5��]Io�D)�	Ӝ+���~�A���ù"LV�#A��y�N�\�.�s����ߠ-�Pu^������u��\Q+�i,�e�ϱ�犔Y=�؅آ��kK�	�97���1-z�}Qj2Џs���1Ş]j��s6�PrX���T�V���J���>$���[h*�Sf��w�]��;y���5���.Cz1�@���c�Ӊ8��M�h�54�i)��~�����J)>vh��h������Զ�*�TCǄ�ӳ�d�
O�Ǳ����ǌ����Z�r�{$xo�K��Bu�WZn1��"�c˛v�h�˼kGp̖xd��v}�����y����q�����v���� ���d�AjD�ж.x6Ț�����46?|��I�� s�m-4�V�!�����.�"j\\|6�XBPbSck}��E���t�o���ǰ�$�}M�﬇�7�{:�+�K
0k�<M���0��c�c �)S}�,p�C�broJe�f\ʦ=0mj�5j`,�x��G�<��Go�N<��h�,�h�2#mj@;�0����'㖼�Y�A������v�m��'`�2&mc�)tj`�D���8jN�e�B��qSN�<0Y�E'.��)u}����TJ{#ȼ���<p�s���]恣F����6]�'��-O9d���m�}�*����ic��Œ�К����-t8�-4��L��M�C��.-�!T����F�zt�{���jh�:(�a�U����O���J�yhK`�%{��|�?mm)Ln��W�͡�$�����c�d;�\C��Q�%�&�{1�8���5�4F�����r�!'h�G΍w��B���1%�z�XC�@���E@���B'�_���n�B���f%� �>2���B�����1(���r�sژ@:�,tI�v�Ø�.]J<^���%I(��ڂ��IK"�ܘ�Ø�l���yo������0�랒{C��.�A䍔�O�׍h��i��XYt:�R�����<��8Z��UƝ<_k�M���{>8��5[d2�@zt0冘��ԙ-ɧ��ry5:�Z~I�Sj����&�`yx�B��Qd�L��D��%�����:ye�-)C44��EKG��Ц�y`�H��y��{l�V��������[�'�M}suX��P-;�oJ�*��O��wq���P�Cڸ���,7a,ӑ#k'�)��Ȗ���2t��݌�%�>�gKN��;�Y۰l��_��)m��4MUs��"[�"�k�ey:f��2���4�&?ے�����R�7�WͯԒ�f�f�Y�76ᜇ�LEeD�wpf��e-�e���P����1]����ԇ�����j�t���'-ÿ�.�<b,�#�J�uv�]�*YT���,�{j���#5)R���B�Aߕ��Sɳ�z��a:�гs����?���y�˿_}w�9��t�@}2����.Z�HkO�ee��.]��-,稾�v_lDy:`�dA�ܦ�9s��9L
��q�����x*A��ƚ���	�է5��+�J��b�iS�]��72�,4��������#􁦩��!N��-F��Zy��K`u�C��F�d�8��-��Y�XO����\�9M k3m;�m�㣲�Y�Oٵ�����G�ĩR`�UH1�b��?��5��+ �_��qZ��+��Zd��L񍏝G�ZH-�{�i#�F��'��4���[oϢZ�Ԟ.�����]<�j9R�Jq��Gg�1�w���E@�>�}��z��뛛Ï�<�i<a��C~�UT�mq]3֭7�fdYIPu .j/�~��}���]������,��l=������������� ���8��'��M]����1�>D&�h���~���V�9M�X���E��$��-\[��˛�����O�_�����˷��-�X�Ҧ��]�Rjǒ`�
�+d�On��p2,�A�rY����:��}�3��>�.�T��%VZ�^|�x�/Mw�D���Xݜ�YTP� ����G���i���ufj�(iQ��|c%�Vᔚ�v������F] D.�r�:^�6�l�z�8�=C��N�F^Z.�^����R~n1+�".[q�Ģ28G��1���dpj�LS�i<Ѻ��'����y}3>��J�;;1�c;vJ���o�"{hg��ebm�*��R�iF$K�Tw&#kS���,k@���m�fUN�a�d�����`-�2��'�.PCXˌK
�؅�%�e8.�*Y��;7+�2׭0Ҙ���rWt�"o-řUI���L�>��o�߿�}{j��@�Y��ˏ��Ms$����n�n����Z�d�*/j��\�ϝ�G���ׂ]R�j�8k|����都�.c0��
����P�Zr^<����bVXCt�CNG����{^�m?����P�	��\�ܽ���] �4L���`Vwl��k1��^zu���~o��^��Q`����������?|�����R��?��~GTK�l�Zc�:�+r�x [��Tƕd�����5
��*��ڗ��|�������ݧW�������� ����7�&�n�3c6��%�5�,��Q_���#X��ǭ�Dn<j�����n���G1�/(�B	����ʳ���ٍs��n�=6���Z!�?]��k�����?�0�ٯ�P���@��V6(ى����Z�M��2�0R˫7��嶔Tɿ?����������ݱ@i/߾=�^�e�S���ۉ<��2�Y�����"��踩��77W?_��o���o�ߪ��D�ߛ��'Q~t)Q�މ=s�}��]Aq'��e��.�X�����3ݢ�oX?���h5Z��E��dč����\�KzJ���U o����h�������G����B���p�N_���m�`����n9���>ʲ?��QD���A� >0<�&BC�L�X&��$� ����j7���a���\5�8�39	�������GoLg���lA�2�OQ[z�`��g2���.��=����-�dx%�	is�I�)<?i�H������/��={�%�1�2�;��D��'���/-�;�lA���3i?��}��.�#�#yN�o�Z
��a$:�m�I�
8�N�����S��A���}[�3�uh�DLK�\���j��Q^�)�Ay�T+Z�z*Om e����/z?fo�Au�ybMG�'*~�G<�V$*#��%7爜���)"�PP�t{
��f�M��,(i�:�Q�,7uJ�����F�~X����~��`�ʜ��u�;���Y9kf����_\��99d(-:uT	�z���<�R(�2!v�_�]�\��E.�~�W�r��_x͒H4����om*<�Ʒ6)� X���y�����    ��������j;_Sh�K��f��z!��qB&GV��FB�'˺һ��Y�s�M��㥃&�|?3I.�UDm�/OMi8�X#�����~O�$}#��.��|dKÔ�ի��[dy�E����x���m]+T�����eT.m�5������ȖQYk����>�T�ٗ�(�+:,��TK��ƕc�w�x�^��%��:��e+����P�W\&�����&�T�)k��8��f�-2�ҠH�R38�\���5M��Ȭ�D�#C�����R�R�v�Z�5���1����K52c��J���b�B��.��b�E���2��Dܻ9�yހ�a�ʮO��>�/Ǽˡ�;�J��g�K���Y��i:Mf[є\3YD	-E����k1��{���)Oe����c�T�s��Ҽ/c|H����yu9eM������Mzhz��NK�]*���tCB{蜾ԅ��ȃ2�R��~(}�9rm�7���~/���ks�ݔHOe�%�lLZ�ܥ�H�̮����ꄖ��L\��l�j�J��=����9%M���P}F�$K�"#�P�d�;�\�<}1��hŚd�ZP����~6�$K��K�F��>�h�ĲdN�A,����ɜ,�+�fL��`lI�dɜ�P}�a�6�<�SE�H�!�2�� ZE�YK�Ag��/���Ҵ�O�ON�k۷��w�����,��(�-��=TS�-�rߪ*����i	UPY�ֳ�����~�{+O���|���۷7W��tW]��2�k6&��:���ds���|�5	Eم��!�,�2��.��ZX�l	Y���S^W�r�����c�H��~<F�aq��zVmeb��:	���nl�&��RU�KkI���BŜ�n�w�ؕ-�HΊvf�*�R�Ї�M�g�R�ط|�X�+�H���*��r_����M$�����)T^Jl9k��U-$�MŮQ��<h�Lc�E��ه�f h���3�!��M!�%x��a�.Y�4��3��RHv���
.W�6�?��-�l@X�eR��3fMt5�|wy8�*Ҵ�ԦA(M�X{r�#�@�,r(����	�iPFv@N%�C�Y���\(*�m�?2���q�u�԰�� ��Sbi��9ZdҐB&yO5^s�Ȭ�Ҥ-�����
�#2�J�6�<,+Ȭ��N�7ΑK�����y"Z�3��0.~%��6"�#8,^i�B�m=,n�}>耾ҕ�WB�r�"�����(�f�Yk&wO�Oâ�#��n���}��8��J:��E��H�����UGD�]ȁ׵ 9��"'��8DO�f�3�5�Se��$��(�g�D���2��.�mʩӰ��Y�y�T�w#��zT�$y�����l!�LF,y�yׁG��3��b���5
���3�N�DḆ���-�zW�r00}�pO���/�,��8�⹦d�ݾxϵ�8�ī��d��(���e�[��d_���}��8e���[��W����An����������/�6D)~9�U�U�V��c��::��#5��Е9��bȮmd-*�ȥ	!`HUN�>�i����q�`�H�6o�<�>;�Rh	.��Y=��l�B�G&F�o��ͧb��=����i����X�f��I�0�f)���1��^ ꔅ�xz�$��:�F%1<ȕ���O9~���������l�	����N�2c.'J����|�(��T���2^`2�!��(�cre��6F��q����k���M5�&İ��jz���)Xz��x^�O�j�\ ��j���{,5�N{�ɖ�A�"&v�6VPhЉn��Ⱥ���gk]	��z>֘!KR~�&S����ub�>dLi0(h��'S�ʹ>�Ǫ����m��8ԇ�J=lAICf�(���h��uP5c	�5��/䜂o��R
���5��z��/�s6(:���#RKm��1�����\�g��
5(����H���h@5��w��EK[�:��\�g�b�f��V�5(j�Δ��̅�<�Ҥv��������1�P��!��E�7VS�<j��X^|bӅ՟s5[T.� 8:Z: �|Tr�϶�����;��-�NY��	k����;~ؼ5�y���7�H��Pz#x�Z��,h�s����T�Q)t��*8XT��H�)�؁,'��a-�G�{�4��fԾ1�e,m
�E��[�C)�Lw�4�/-���V�?��+��}%ky~�F�h.k�K';ىٻt�=w�L���liJC��w[,�GX�-?B�'�^xl	��nj�	�K'�/@���ɚRӎ��c��2����yTK�:��kX�S��m	P'p���B8���=2�W�j�\��"-�vb�J�;f�?��cm�T[�8t�?�����M.P\�=}�A�Ǌ�!�2�x�L��O?���ۿ4X(h�J)��)�E�-��q����w�%t�����_� 9m7���&�\�P��45�|M�ـmT-�/�=�t�H�T�~C-wl�gy�tn^�ɵhʹx�R��l�]��5 - -�hщ\ɩ#��e"-�qZ���PD�3T.ǐ�G`��g�)t�Iq@�3�9��Ǩ#�[ Z�a(�Mj�� �<��')��f�y�v^cnez�<s���x(F�����p�ӎ�G���fv,W�mz,�x��ꊲB�6+�X������� ���;}�E2���iw*��X#�\�� �1��2��%*;�!�#f��e�.�xL>lf�&�����D�1�e%��8�q&�z�B����ܡ�Ӱ�my�B��&_����}�%fKL�2�]b�Kk�_�%'p�U l�㊬��EZfR�؁0�_���eZ^���E�=�U-��j���x�~E%��+���)`$����Rͭ�2���ēv�^ގ���ZR/"wrlub���sK�,T\���3����9�A��v @̍ �D䋟�Lr���΁��i�ŀCŮ�h!K�
�a�gvj�!���2ÕJ���)v���`RT,=>�NX6����ڳ<\V��N#�Ή��	<1�!녳"co�Z������>̴*go~�ɂ��(rm�-v�T��m��>q܀�΋���
�_���7?�Faa�z%4lC4#��}�Df�2�����Ǖw��'B�Yr;�Ok.�%���\ɰ�X�B��Z��P�~cqiPq�RGT��XIS���:P��8�����WN�X����K�5/90���[���C�E�ªyU?�g�u�V�j�n?��$����\a��%tFh�3Xc"��1�y%-Y.Y�Pkpp�Ci~�\c�H���t��Z��[W�o'�+���5�&= ��4�E��%KM#d*�$�h�SK���.|�C����jt��O'57���[�R) !k��n���%�>.�=�Е�r�'�b����B%���k&�R���!����wZe��V��%���d��(jɪ��A��mޒG����W�UQ�~N�A~GL�U�oK|�3�+Wj�dw9�~؄���Y�5Ο�P˕���L~,v	��K�	�TZ��txFw��kd��!Pvy�G|^�t����i��z���!����'���.+�X��a�̫�:�=\j���4����l�:�jQp\S\1��d���
�^���`�GV�}���P\���)�x,����_�H���1y";��>ɇ�!o�����2���0����Ƞ�B�4��bz�Z;�&쏆�`-�.zϗS�2p��Q���^)��<�w����4�0�H.��heȚiL.�KɐF2���(:�tfq�"�����h!!��D�A�����:JQ�.%��B�O�<?�p�� YM�D`B�5�Q��=����d!�}�wZ���f_/T��n
��S�"��ԓ�Q|>B���8S�vП��_&�� ����B�r.pv�����$�s- `\��Z�K�\&��`����`�V��y�}�H��F�\����bO��{W�hY�ݡ�a��n�h�V�!1�*`�J�i���v�+��|]��3'RUEK�"�撇��gG���&�2�N �eo.
���$�6�p it����˙:2 kT��/�<��z=<0    &�����`@����c�E��}�p̀x\�J�ڊ1�q��&m�/b�S�w�ףI�X����z^��?���}6���'$IR�O�I��;m$�`�%�E Mn�0�b���,8ğ�����ُ�p7A�%>բ0k��c��m����D)��B$L� �=�Y���"���Յ�Ӄ]�ϜT	�L>��`/��-d+FTw9��M��3SC��3����?4�h��lYS�`�T���VȖ0I4u.x��Sq�
,Yj�j�'��v?��1��Gx?�t�3�Qَ��C���K<[6շ0i��x�����R��t>u,���W�T*����i�Ώ�G�a�T�4�d�Ù]�wф�Ӿk���.q�<�e�R*g�sZ2dh�&�a�W��;7�;�<АU̦gpC��\%����y�_ʔ#�����C)@=N.zm[rN����N`g�0�TX�2�@�����Lle u*dK6�,'����剴�Ts�ɻXヺ��ql>�>Ϭ)?�w�C�/`<;�w�O��$A��&�.��]�U��^(-�����]N��6Q����qzT�2Q{�w�qA��.���)���0F��z!�ň7�v���Z2$� �6X��$���*����%9b)a�*f�̂8jL*9�4�"���Z��3r(:����y����9se�3"w��Z3�qAʷ:���i���`���G&�/.|8��șj9�8��LT�s˙���|�#-V�-KD� 8#h搘O)�)��e�d�V�2OM#��Y^���,b� �z�ş��D�3H`�T�M{�0�Kրv�YÅ���vZ�5��N�.b\V����q-r'�q�R��:l�J�v4x�E6{CA��\����a�9�+�4?�{�W�Һ:&mڹ������LB�����@q�+p�C{ŉ�ŕ�e^�O��}Y�u��a6�O���b���\���Y-�����~�{+'��7�������;�OWw��{�����l���,��v�r���us���3$ӥ�N��Q��I`��d����cC����t�mj�)��?%�0�7�F8/��"��ǐ������x���X�)�d�X�ŋ�� �c�o&����{LSQ���q�\�R�c�/�W�d;a�����p=�Z#Pc2���_�z�ޏ�=��F�S۩�����A�@{�r��	������Od�`.ùA�Y~�r����6|��h�� {;�zH	,�d_�z����E���/���r������M^/i���q�5�F��=/���eʥ��i[���D��$�|2��|V���ER�@�\zf�VwY����I�q�K����e�;�θȳ�����r�jҞe��F��2m���q�>��Р�W���n��s5��G�3���~��#G+Mi��r��%�
���zJ�J"2}��6��a�1-�:���ă���4��!�6xf��AU�A�R4���y��q���Q��g�ى����� ��~C~^qɊ��l)8J�9n��
L��$O����k�J�KQ;�S��TOO��oi��e������ױ/����T���6W���6��L�!,L��lrE{�i_Sꀓv�_�c�R%�^c>�IRb��˫�^R"�~���;۾4[M7�6�����������w�����=�_�|yIFBd���w�V	��)-L������K�f�W����o�����>VRV�b�������խ��B3Q&-ː��]-����E G����*�һVAB�C�¥�,�C������B�%w(�+���K+�r;@�)M-Ϣ_�K�TjdC�.]ޱ������0U��Ɖ�iLˠ��.��[���O��AnKr�y��v�ĘTQ��9�-"�97�~�)M�g��{7j"ע��P{�\(_���&dgC��ʁ�@��4��ע�>���~�V�,ÄQ'f ����M��"h�hB���Z���` \^J�MlD�2�����ꍂ+H��s�O�zܿ����f�BTΣl	��4�EHt�B�<buߏMq:_Z��}�&�vX�-��l�(Yz�0����8b���)�9#�.��)�f�,g�h��Y��R�1>!��@����T�VJ��ƚݰ�n�s
�,�a�0;K:$l<�ถC���N�|��9��±�N:�<���r��5����B?�����yss����ǚ�\�������=+e�C�L��^%X�a��O#��wZ)�c������vp9�l�:�:Ν����,`"��.�����nwoԤ�E_]1YS�P凮�}��p�E �>�}��Q��z��X�J��T��v�١�Z"�FC=x}������N�I=�b����+���=YQ���d�%�7��k�����>Û�0X&�e-�Z�m|�@����*Y�����{Ξ�r�i�'�2��C�q�+����/��˅T��8LeC@^2Gk��c���O�y�!�(t��8�%�k�u`�<	aM����A[�R
/��	 �ş�t���l���L�/ Mș�$91�ڷ��__j��.�V�܏^��_�U	'dȝK�E�۽cf�:T���à������;F�{!�-��RD�� �<l!�J	�kx�HC�SOÕ�uI��V�ꇗ�}����i�U)�t�)qܜ8h��2JN�J��9߲<G���!+G��eJh��Z؊#OzҮ�����2��2OK�m��S|�k���I�k��<I���O��r�HC�$#���CX�k���Ήb;���l��pb^��"а��(�!�S@X�u��@Y�f�<��F ����vK֪ͼD��n>����?<dQ.Ff��H�;Bw��z\d��IX�M�ٝ)ڼ�}�����e�<t,���*�R���~�P K��F�伞#��'��@��:h�cC�kSDt�|e���s�=�Q� �Q�,��*�$i]������瞤�*N��	��s�)�ɼ<_�Jف��r+�h�&��
���R&�nmA�@h��e.�2��EfU@5���E��wa^��O�2�4��H'��I�Or%�5��	QR���ƿk3�ϐf�]�H�\�.�t�P��,�
Z^�����=����\Z�?ת�E95�\�#eF�ϕ'ͦ��(k�
Xi�������G:s�������6t�J�똫$�S��iI��/¡���$�K��p>ev�]>,)��P^�j<h��O��>�s���lu+8���!��#��y9�|�7�F�����v/`Q�N��y���|�n)�^��g��r�H�k�T{9$t$r,�)nVH�r���G�̯��/UD��;>RBX���Z�Y9J��si��^�� wA�qslVXy�z9s������ZЫP��n�b�gab�.�d�,�� I^��C/I��ФK�0�1+a��KW���>)�Cultc?]��X.e��#�%�[�,��<V�s.kˊQb�8woP�S2ƎY��3O�e�!�C�Χ)h�20�/S�R�Ӏ�}�d)���E��>���,�r,�9�.����^D�R����a�B,kS2/Fc�g��-c��>tA���Y��VJe ��X��mK����q�q��b�t�=ŞHJ��<גC�0i����]����;í�<n=��[y@�!��\���&�qg��2Xɱ4ߠ��u����XB�s��o�r�/JV�R�"vc�d��.���fs"N$ϴ�K��M�a�xx6�J��(/Έ���6*���/���k:��]ګ��_����:��t�2x�~ H3U���ȝ��.�BgU�?�)a���nĤ�bF��uIï-���ŉH��x�Q ��J�E���C'���ϟ��9Xy�$l%�zTr���X����G�L0"@�]��r�\L�ȡ��t�0a�$��^��hJ[���??�=+r�?}3�������W��UuS��Vҷ��:.�
�e�N�8�������ר������P{�ȳY�yq��q�[��kQ��x���,i�_�F2�q!����#D5q�O	09G�V��af�f 6�}�
梱�]LԲ_�p'�}��Z�Vp^;�r�IV��j�    �na�=�ϑt��>�Bc�8c��Y*�sp�:\��4��������D����C
���%o����/��a���b1�v����PD�Zt���y�˿#N��:p����k2�Q���=u�ֽX�~�\���m����2���vk���~D{9�+1)��|�oh�]$�\<yTՇ���o�?��{��8�o*gr�-�9�p�	z���Ci��j6İ>+s���OetȊ�e�?(Z��\ᇪ�gCu`��e2=�BC�2,_k�:<�½�$�����?_�9���9�-�����kw�%qA�����ۿ�ˋTP�=6�a��*�D��\�%b��@�������B�$j=O���K�8��s���5/t�����F'WK��^V�틒�B$�qL��d�>�������+��4�T��}��/-�Y��p��/}��� �+?p�؆�		�\�5'ب������Ƨ��<lۻ6�������"����\�(����f}U��l��7:W�Y�W$��1J�p�S�Cg5/u|�� ö��g�hkc���];+�|ҳ����Q��V�FV}�	��|rK\�Z���c��ͳ�Sg��S>�|��y�!]� Z�V	ԣ�>���}I����͝�R�9o[��}���`�\+�K���`9]��sG�T�%sm�#���F�lԂ%f_J���:��*��,�� \�?ڬ���AK�5.����(�e��R��fUTL���Z�����XTo�_T��YOR�K�֩ Z��OGL�Lh��!�vU��"	-��#�����`��?���[�ˑ���I���,E�b�8k@7S�%H�݌�2.Q��F,��p)'�X�%E,����vA����81<<]����>iÂ��@�fPwx�J�A�Ԑ�<��ePGxC����xؠ�°f�b?y�b*�Z�����py�.�H!F����Z�EG-b���Z�ҿA	a(��/8�N_�����o!�4,oq�f���O��k�}Y��T3��)��.M6Ґ�E����������j�d�(�?�-hp���b��ԹU2�+e����C�L�K*S&��%"��w�/&Uӕ���E��m�ܷD�E�<w�}z����{G��p�k4�%�8���Ԯ���{��cw�P��V79��u'IY,v8{���$���������ҠH�����Pl[o~��	��>�Ҕ������gB�e��<;��"�f��%z'YX�_��|Q&O$�� kOd_h9,�c=�@]��@��^��aW��-��K1�\c�<׸�v٪�`D�bu؆*���gK:ݦA)�+WZj˟֐�������,�E���iΥz6�����2��j�$�^@�'�ٴ��8��t�2�ȹ%�!V�A��A�2�<k��am����m�N������͘�ՠ����*�A�ݚW�֏E#Q���P37���;���G����ی���O}3ɪO}8���H�Wr�Ho:��ҿ�J����%m*�5�>���aԂ��2�yYd�|)�� Y����.��lD�Ҁ�����7ˍ�Q&m�S��@u����J9��%m ߇H��׊v�Q'��UB�"iN�j�y��z������4�z�4�|�J�T�w�%k�����~�����>��,��&�Z�?���І�0Z�����+s���3�$D�v}�J��ʝ��^�zd�mw|�e�w��j8�|������E�A����ϑu�݇��Y�3���\��В8�v�nI��/hɜKp��N��U`�[[�.�E���:�����M.�꽵X	����>�~y3�:���쌸p$�JT�Z��9�N��թ��9�_�����a�2�֏t��Z���+�,�&'�Uk7W5�2tHՅtK�����9�nm�ާ9����6�
?�ޫ��������`��,�������%�y>�
�;.��e�x>����ދSc �]TݓQ�;��Z�T]�I���BT�e�I�$xA���k2k�zzpi7�\�0Y] �nA�5xt?h�Ғ���|ٔ�@�$:5d�,�5�jp6�+߹~����
�`���^�2�hJ��ϛe�,�zqԅ5#�6��,�
��mF6��X�!�?W=+�m�4�_h�a�1X�\�Qr-�6Ϫ���c�g,a�hάJ������0+�����Z�*&̵E1�s��`S�� u������{2��t�79�[+�WJ�T�;�%�G[
�R�W~H�e`a�������
Q�Z%X��Z��X��x\��۬��PB�'�'��,�K���EJ�~e��+�N����L���+V,\zF8��ݱ>�!����c��;;�idk�"�n�i����|�8 ���DKW�!۶O�Ҳ��	p���/9Tte�yɨ̵+�#l*��u+/k^�;l�����b[=9+��GT{�i'��g����UP�"�]B�H;k'��ey���j��[B�3����.�md�5$T^��Z�d�Q�JaZQۺv�c���$�����k�w�����e_ l�Zot<����F'r����o��^���r-�VH�n{|�,UdWK���ܪ��uZ�c�TC]#����#�5+L�F@��<��{:����ʈ�C�<��
���rHW�:(���A�5������a���F뾵S�t�h��ja�%�����B�ɼ�kY��]��\"�#�)i���9X�h�-��3v\�v=I�x��l�.�(�]v�^��8��k�9��^�;-]0�a���BY�F�ڼ|g���v�JF!x��፳@��;�rcB��;,��+;�bP���ˣ �y�]��,8�7�Zҧb�b-=ى�t�4Y)X�,���/�A�&����\[�xW���E�������/M����e�4"`���}��#�~.K��痸ϲ��%jy��WU��0�1������ӥd���5�,�zM��b w�1ZT3\�����qB�X-�?������n΂9���X}y�����ڻC�2��)UkO���(�������|�������՟����r�?_�ܹ���-|ҷ��~�?{�3���R�]d��-|�ɫAѶ��<_��������S
yX�ɥ �tA����E�Z����Y�/��*ϓإXg��VF�%�*u_;�)c@��J{
fEBX;qZ3x�k2�N��;U[o�@�����v��/��x|9q�'�(�1�a.�v����2,���� �������~^%P�©Kp�*��0�N�j�Øy�H�{�QB�R�:S�5��P�#�^�8��x1��&��U[��8Y#&�Wf�,�hxL�P_�jڦ�3<%0�<��4��he`52B^ٻl^���Oe
\R��PL{G˪^�)`X#�5�/�'�3��<�mv�ú�^��13���_�ǖ��~n��[ՀV��CiI�c�������z�~1I�z
�ת�-��%1�0,B�[I�F���nC�Z��������1ZIJǺ@�Q��"1�t�k��t ���c�E`*ClV$����l�����i�|��37�Kf���Q�b��K7_���?����Hp�ǲ�گ��*�u�d�9�v!��;�bAܳ���؊��S�n}��%F���e��7�G"�2)K�~�s��y)R-���ㅽ=�2<���C飔���QƠ�� M�ļ�b�N��')�u��cP@x��L��~qyoy��ق�\#
ZQ�fo��-*4���D2��c嵛vM\�1��/�okǞl� c
�:��?=�7[r�|��%9�Z�{���9T��4�L��k����f�F.����S��O?���ۿ,�X�]V�#:+K,�V�����#�I5��D��>�Or�V=�{Ln��$:��0�����Ě�k!�UB��?��9'|Igiŕ��KVg���L�s$#�����Da�p��!h�.���v����}��sq��RѢ��qZ�77�!YI�Fͩ���2�A]��%���j�:҈Au\�v����o���ڟ#kB�VE��2�R�"��5Ηb�-X쬮�(���ߓT�owO6�ؤ    v�S��.�x��j`�C�A�F�����`�&`#�1���E�V
�ݲ�\V;|�����R�]�
<��g����픒���8H9�8KKD*"��xc�K��Y���q��;���t�,���c~�c��K\j1H��3�ѫOMGO��|�cq��kPQ�K�ŕ�{a;�o�A�����ZroWB0R�P!��%�A��I�.�xa9R-S��r.C���� e��| @�$������0(�;�!�����#��D���s�{�0�D�CWY�-��![�v�5�,�3C9�V��Ef5ɪD�]��B�'N�9�t=�d&�]�/�Gr��de�B�z�Z�HG�*ʻ5�ݍ��k�"i�Φj� ԭ:�멦�t£*x���O7<7���e���Y݂mJ�W��&"e�i����u(H�Vy�WENӌ�����a���\On�(f�(9E3�pe_�JEe�||�;�+�e�AP�P'��f�Wb��
�ۅ�����j��������w�nٖ=:�\BZ��%��>��OQ��,�� ���E�%
6s��̍�1ѡ�l;��!5<{�%[��<��k7��`no������'�-a!�=��̇]J�	Xj �d+�"�l��r�c��N�B��ް�|6��lS��A�-
��X79����(�Y��Cn������\�2����5�ʸj��[\M�#i"Y��6���
�|T�*��R��׿����o���������~\�K�L8s��@B���p����Yvy�c.�����u(Ys� �0F��rp�.$T��N?*�"�M��i��|�͗Z�/�$d�08���+v~m�BC��1�j����$J
�4��1F*1h���X��r̯�Q�� b�	��k�L6�Q��@���ژ�Q���᜙ƙ>E �����po�p��z�McMM9��������F��� <�zU����%��i�)�6�!��g�ZB�{Ԃ�f�j*���I�AĦ

mIA���	돂�ى:5UJ8U��[w���nIDAaxz��+�WnI���*�kz� (@S��A�ZD�tC�1`k{�l�E�4����缟j�t�H�f�M⍠�b�|>�,��]%ޖ����G�C	As�I���|<9R5m���b�9ɣ��R%�������o������F0$��6���|��F*gYz�r����*>
5�I,{;>�g�\��g�����#�(�DsÇ��o�u��S(��ȧj��p��c��!pO!�T'p쐓W�^�hm�4 g�];`�t��ݻ��[v��FO���ՠ�	
&(ܽJmnss��H�м�j���s�UHpl���_����5�r\~�����&��ps����o>]�����a(��g)s��ج��"=�YΠ�0�)��/[��g\�G�J�w�LP�k��N����'���!>����??����x�_�����_?��.��k9kk.��+��;@C�Fi�*�s��ټd�I��������Ϸy��}#�����������{�$qpj�$1	�=z<�Gz�QW��֊<����� �~�W=@Ps��������qQ��̧�1<*��Ē��҅።|M���WV��e��3Cs+Q]]eٜ$	5Pκ�(�D��2�%
ǭ5��(^�8G*�Ɓ4G	cCq1��Z�����7T9�i�P�#o�n�C��7���4Q�\�H>}�kJp�:�
Vø9�Q�do槻ÿ�?>_���^����oE�0.�z��o�UM��&>+����so�߷�9�����(�6�4�pоi��/{t���iC���t�ˏ�>>]5�C��d�Mix^�e��3"V\?u@�5Ѡ0.��Rb�jW�����¸8�cR4�nMN�� Lׄȇi�`��]�w��ۛ���9����?���K�~�m�s?%c�����=w��2�z:�r_�J��]�V�[m[G�"�!qᄽ�:r,�a�T�.�I2(,W�=��^H2^b9.�k�
L���>�M%#jW6Jf���Z�'�l��3�}{��z{Ϣ��;��sW���JBL�z�АAۭ<5���0Ѧ`u��Wy4#�"G�9|��hV�q+Vj�"�z1����SE>d�yEW��<�����������𾏓�5�+VH�I@:L)����������e5[IP��y7�}S�zIᇪ~{�Fc�j"$��P��c� F����4�]�=)�$)�UG�J:�LJ��K��DOA� %>tˤ�1��������h���}�������?�>E.���j`%T����VX�@�/<�w?��:	C�,9	_�I?������*��Z�|���g���3T�)�j�\���6��=��Z&���47�M����.rR�D'��so�
������B���?R	a�^ۜ��%Rp�|:��L��}���$I����=��0�z(>IM4��nU5�5C�d��	��<�:��n���⪞"�K�^���!mͳE�����VS}�
�*��q��#I⼰�$A��	;���Z�DAB�c�2�*[7k�$ G�]ZW��b\�(E=h��������n�uX�aRT��8�;������2.f`h����Ɂu�׋'TXI@3���fM{���  	�)��r���r/C��N����۰�I2fMjN��
��-{I(_B�2���F�5�$��8S3`��<��=�v�@�gHD�=��>���_�i�WG7�?)�K�TC����3U3�q	�jv�V�i-'i�q��ã��F�Z���%s$���q��	JtCym��Ji8��z��xw�z{�����0.�{�P��=��/�O����Z��R���r����0_�z�T�`��6�R��}ǩ�F��o�
ZPP
'M�wK�� �C0�������7�J��I��Kɂ��H)�!����A�T�`̨���;����!`	�/���K��Cn����,"�{��\�Q���󝺂M�r�3Iz��Z�F��f�E#�FM:��ug�x�����[���V��1G�.E��,�(= �[q�)늒j�"`mߐ�%���<\��x�rz�$�R�#7������Q�t4�"�io���:p;�8�?���OZ��#Xc��*KӽmVV���������U�?��c'���F!�-���.�}��:�P��� `KX'a)�1o�Y�&"R���Nx\|�l	�%,_����)V����]FR���A���M�B��V�W�Z�aLj��!���I
{�����EE�������W�S�E���3�	���e��������i�դ�	K!���IE�3t*�1(u��TJ�B�Qw]�Rq}d�"2#�NEx�ZӴM	��J�D���HRW,�+�2-�F#m��M���y��n����:�|��R�JUF�>�M��<|�A�F�$	K����ux���B���e`����V���-YQ�Х� a�ӯ���v�
�:�x��v]�b	K�%��_�~eX�Q��[i�ܐSڣ���|�!({\�G�e�����N��Q˂4_��S��X��r��ԣ�i���|&����oi�����We����47����2�dt<:B����ʠ�E�@4f耂1F��sPz#eL������K2:-a(Ր��E�dty����V0:� &E���hđ�n����d���������E����G�y7=0J+���6���E�����<�_�QZ���"�xIF�Z:-�:��h$#WVy��(����b0�Id����*�b/���%�k0��n�,��'Ct��+��!����$5T�e_H�����@��/��tAl`Z�N��������K�5JRO����� ������Ӫw3��
V��;f3g���\KO�߇Iک�>�b�jZO����>�2� 0���FZ��?q�.�iE=�q����C�谢��o���K8�#g����櫦�؞]�����H��5�    �'Bj��Ct:��I�qT;Yۋ����,����>��%h����8���P�
h�'rBiA��9�����6I�d��A8���<⛚��;u�:˭�y�$�.;���ദ��x��I��J�E	GEW
�}��m�t��7�>�Z�#��{��u�4N�P��S}�Eᬄs�����~Q8p�9;o�{�s.p���4��9��b�I[Ay6����I[�E@Q�.T����D>u�Y��p��+Y�x93���@J���^��@K9�,���!��<�|^{f�W�%����Hu˱�<m��<ɍ2��s�����H�HO8����*��;���yCI�]�(��/H%!��}�i1?��I�^>p�V�a����)	]�g�^�H���a��`-��/H%������'?)��#Kkb� �w���5�;}�l7����5���Q��JkB���O�� J�§�(�r�FZ���S�!����,ߏ�A1�+��5iPh@��M�.�u%#m	�	*t$>iL,� <�I�]�!�G'#M�O�Q�����4�#T�Q��%9@�?�SP2�&X�x�z͘�m@�H�oI)(x�Χه�R�g.�Ml(+չ�����v��Z��.c�L+;W-Z+�П���Ň�z��hA�����vFj_�|����R�\8P�M`(Y��!R���d�B(�6� ��J�>4@���@�w��vg*u>�T�.�9T����
d@��^niHSAI�Vu�n�@��>�Ђ���	�]�	�!;�+��U�qxz�5O^�����>�3��s)�I�q���M���.K��j��k]��%,�=�:gU,�%���U��rʍ��
����v3pɝ�k<�M3Ӹn�!//�� ��4	bn�Af?@��Mj�5@R�x!��yy�V����i�"l�u���9�j���q=�@謭�y�����K�HI4�\�̴A�&n�%k�ȭ���Mi��@�3˛ܷ�EiL�Q�[��)��;ȍ.P�wB+W��<#��M+r��Y>O�)�ԒqNz��coJ�����&�z*�%�3��=)��,HZ�-d>L'�Q�"%�G���I�6��m�}�c�Z�Z�;��h~�JX#`��W��b�
Z�	G�T�t�\	%,`>د�鬡Eu��7�M<m����]�{iO�|nGӐ+&�WEZ���N�9�ۅ!-���?脛��q��˛/��}v_0,li:�O�QQ��W�/mI�wF%9ظS� �jK�+��'�#��y%�����-�z�/lR�)
Y=�n>�~���W�����Çç�b�拊��X�}�Úm(,V"��d߫l�hek�Q��?5��{*�_����Ƌ���Kc6pB�Fcl�6J6ó7ec�^?{���\j0�U�G]��9e"D��F�� E���+�����E,�W|(������;���x-kK|�>ss�gN��0w�'�g�5>����*P�ʝ�ca�%�S���D���l��sc�S,'2Ҝ聥��I��	�h[�f�ϓ
ki։��k6I�o����=�"���t׊TM�1�����O#�H}ly�iJ��0�N���h����撤j�ԧ+2�ْT����T�+s�k��T��s��4�l �L�qiP<f��^�ZK5
\#�ԅ��02�T�F>�R 05X��V>�/1����� Ac��	u�l�2�F]G�

*}��l�2|�xC��3���0BICY���[��(1x���o��QC����x�F�4S%A��{�<vh򉌖�=�Z�0�K=�����a�4R��#�SKw�j3է�r|��3��x8|8���c�2���:��X�<���ĳ4c'x(�b�͛�Ï���\zs}��y���v��W�ѼD�;��<Z(�TXS����E	���dZ�s�6�|<�G�����iI�t��T7TF֔�kX����D1S!��ͦ��A,�	��7�SP��,'iUL�����PP`�H��t��re���h���B���mp9��X�P	��	H�)�$0l$5qM��fa��E���̾B S>ޥ�K�+�[�d
�G���S�6���OC�����
���������T~"�?l"�P>>{Z!\fsDAc8�:ĶuZhKu
\��ۮ�i��@�0�ļ��M�xag.p?�i�����O�m�W�r�a�5��ŉ�I�JP��/}�uR�f4�J�xy��
�d�!*(Nqw���?�n>_��q%�E�U3���s?��������\S-���O�V����򧥞$D����}.�(�#=0�[�ǐ����ۯ�5�ô&5�Xn��yC�e�Xؖa,�'�l�[����F�⚸ıՉQ^��Q�葁K�1ԵX[�1�+�W"�Zo(�
%�S�gܹ��K̶:����*�0a@��ԨPΟ�,.���+-˨�DT��<�}�T>���k���lTkyd��C�VM�2�� �[�aH����<�^��8_,������&�w�g�O�i.#e)��T\�$Rz��M�\�3^GXR�l�U�8�E1���4/��n��T)�P>=�&T�w�UK��Geh�R$IRp;�dlE�%��!����ZCށMԌ�i�����"�O��V�r~�[>� !���ʯ��b��x6]�Q3�&ъQ�ݑ��p����hG��q\����tu{W��|^�J������7?�qdx���Z���3J��ed�3	N�v��ƾ8G5qGN�f�Q8���T��/���E�����N�.��R�g�lۦ�D�ˑ��Є�B�Q*y�+L���'�E����bMj���b�ʙ�P�*vϙ?����8��X�V�����4i�@Ar�V��ָvɔ�οU:r����@C
�̝���,���v%*5��KNb��ߚ��va���ԃᩴ��͜��t�GC�����$�pt�mzU���FΨ�-;^e
�a�ݴtd�����Q���6����k�;*>��R�"R��=�R������c�;���r�@g']���t�WW���X>>�3��jo]�����p4�V$7B�s3it,)��C��Z�IpZ�WJ�$�`�����L˲;cLI�v��ޖG��ެ���,w�J�����%:�j���}wi ���SZ�������3'�r&Ή*~�j�Uڑ����#�{=&�0�b��&��G4)Y4V�z<��K��+�E�qԁ�i���Sc�#^v�0�c;�M�J�l|>i\86m,J4�mM������m��B�x�uD��}��Q� �5�Ƣ�J�\��6W10ն�>��k�&�*���H�J�X0Q�Ǣd�'���)@`�n�4�9Nm���$50P�%����/:�7����Zg����5`4������!��o>]���o,��-��?o������g�p��/Tk2Fͨҏ�C$��|S�6*�(���K���� �fT��O��ϳ�����h���Ѩ��Z��5:�����s�9gA�i'!�����=��4��(��������,��@�����CI��\�>�8���GZP�Z^='6FR�k�j��P��a�F�4ي>�n>���������VX�e0���V���]�E��~��C>Y�??���}1N5���)�(Å����b�U7���l�sky�l����1����X鋜&1J�s�HC;�I` ��.�S��\����\Frq�}�sY.+�(R���&�R[.g�g��bIEl9b#���K7z��i �玹�L���x,O�+��U�/u�P����>����9���6��j��"55�aֶi�n�z8�>f�>갼n��F9�����W�]�g��O�jz���������F9MU5�y~��h����d�k͚�`��$���.T:FU�@�`8���t��-��A9�
Z8ZX�Q�=���X�e7���b�n���1��
*h�������w���Ћyju�sl�֟�.Y��(̳�������h�Ǭ�c��f��Y�3�<q����MnZ�Uu۲� (y�;��e�{���Et%�3
��N<�PQ�ҷ�f�uP;T_�*��M�j�S��    .p.�{�}
���ǵ�K�*q������N$]"P]6X��gs�_��m��K}<4�M�~�����W���*='	�F N@��K����,� �����i~���V��� _���7�=E$�%��U����#J�0L���h�PR���Zn�':���ܒ�O�������2��!��Z�V\�Ym$	Ǎ̱yJ�(g�3B���|\�CH�o��_���������woW�~���׏ן>�=������������rwu}������R%K�ŷw�����W��2��k������;r��t���y#��#o�q|��І�qiS,��;t�zxڠVc�@5;�4��z��$�)1��J畍����j�,�0����$_�����J������|�i�;����#�ֻ�Hk�Il��g��i���M�zk�<��<T��	�c�i��3 �:t�G�Ͱ�:����.�հ$>i�|�ͫ��<6<��o_)�B�SI>z��!w��m��}>�+g_��ܝ�P��Y|�e/�T��0Dl͆+䭫�J�O}���1/C-�1����$�F�ވ//�e$'����T��8}E?����o>������H�_}t8�y��C�j�����Sn��y�N��� �\�HqY�ȁ�Ê�*�����@�

���<~�?}����8��9S�2��K_Qj|ǩ�<����}�qY����!ԯ��ۚ�i�ՉLA=�\V��o�ڕ�q�� �1Ф�Ȏ�ݱL??�s�;.^|��y��*��"Ɓ&pIݴa�W1>`Pbx����	�jh`�W󦜲Z!E�sL�^P�����@���ϑ�Z)-'���a~6�s$un������}d��<y��b���� [j8�Ai�uR���ɝ+��VlR�[F�.\Tg�T��z���Z��OtV�QT$Z���U�s��0�'�ԣ$T	#J��g��w�t�.&�%	j���ښ�mbA-phZ�n�gt�콢�5,�Lm�٘JP;�x�h��q@���Բ��k��dA��qA����k�O��Ip�7�iCҚ��(95'H��ϰ>����͸P�J(1h���A"�K%
d� �*�*�$�ty���En�ru0�x-�h�S]>��S��^�~������CŁf۷��  7��5�c�!/�>�@�|�t'%��r�Rw���pjt�Ɨ[!��å�E.���ҳ�ײ��4_%�����ظ��Z�@�`�� F�ʑ��:kx
�ج�?Y��#彀�KP?Uц���s�h��@A�TJ5S�K%�ci��L�]�bK�w��mw���V��m�F���������$����'��'ؖ(!���^��d�̐���Y�g�D�H9���u�C,1T�Ko�S
�깷kq������/�1��_9�1s�{3�9�|��"�X(b���qýL������`/zt��>�,��Rz��%}��M)��n���T��#�j�܌���ۄ!�FF�^Kh-JS@w�����CkQ�R�����g�a��t�.��ȏJ�m�L$���H��`ņR�Ml�LR���{���ВT���cl|@KR��4%;Rl!���ړ��7��T�;�Pq�%Mo���R�&�^��&�`)i�Ɨݦ}o��T��+�{!�v��b�R�!���r�-U�T�k{SZ�b��bb�=��.��ASF��AAK}L��A���AAK%L�	�
�r�4��\�R�Jv��Ը4�Y+Գ��]e!�-�k7*�:o�JR�f�Y�����ۅ%}�a�Ju�O)�C�R�8�Jc&B�7�T����Y'W�Hi�5p���$R��HW��V�l70FjT�m��;Π*;9����-����o�����u��χhq��g|���0�����Z��H]�8�^
<���S�l�2'���R�k��VGN0�I3�A9�Btqϯku�C�6^$�֔8J?�OVQŴ
��B&�V�:
'@�A���?�����&c����s~��<�Pxs������/������������È���@������c�@0\�@����t����x�(�\������pw5��W:�}���^	FpzC,�0?(ض��`}ɑ����g����q٩�s�I�$�������_�;��_����/��l����'&~i�(��UH�9f�o,����͗�����u���2��z���s��ϟ�F@�R/�����rin������>�g��X�t�:iKPBcy��s��T��Aյ��T7~���yOC�� ����)JW�U{(����F����S�� ���Wѝ����SW� �LP�.*�1R-���4�x�K#AWc�!qk{GmW�N	���!�-}#'�u���c�lT���聓�d���:e�6�ع~r}������:��������*{?�~�����u�3�i� 8(s��O�EP����]Re��!ta@C���j�2�縉��F�
(���T�գ��s���ė����sH���x��k�"��N�uw�{Eph�˱!���q?H*q���,�y�e�"J��]�[7]b2��|H�١ؠ@�t��o(�N�p�cgm��3l7id�۹D�Kbc,�vq(FԶ:���|��i�v�������\U��7�D���iW�m$I�$	e�4K���HC�pBz�jQW��[��lؼN�3���X�\�bZJ�O	7�PZ�3�( !��Bj9M��E�#�cﳎ�������ߞx�[4j�q������$�%z���Z���Z����D�����ÍV�}�&,�K(o)�
���~�7Ua��p}G��������O����
ׇ7��Ǔ�kx#���sg^š��7���Sba�}�o�N�^��7p��6����kN���W(�����izն<�}�8y��|!�J=��Ja�J8y�BI����ϭ����%�j�����V&=0{���#*���j��$�Ѳ\cn��5M=�(����|òe�ڈҒd��f�h�^W�I�Ż�(m�D�g*$��V��
�0L	�_�l�=k?��",�F �a]��wg��#9d4*���O�_�ʼ�w?���S ޤ�v��V�ttI�rO�Q�ta����sL�=�18J���:[ hr
NR�;?���!8I}�ǎ@5Y=k!IuOCm�u0[��i��,�T1-�Ur�°o+�kb�	%]��d��2����|ɖD�6�՜��9reT���.{�-�nAG	����4I�pb@��u��i-ah!��m`��I�+��nc���T����kp���9��W~(�ky�r�I�S�١�F�/��N�,=��[m��%�3J�"�N%(MC����Z����ajm���m�9�2 �'��y�k�F��H�@4~��>�;�H〘U����ՙ�UH씆��"AC�i��C�_�}�F$�$����F$���hQ���,%��'H���y�釛���p��O�!��+��l���W@�
��&���|�
��V�m[A��=4_�Q�D��5��N�Τ���"x�Q�l|�Y]�B�6hqNG;TS��SA������̓�r���J{ \��x��8u�謴*���*,������&�q8��h��ב��9��YO��}��r��,�"�����{�x�(����>Ҋ�D1�Z�HS����ڢ�����������ADځ4��Tkc>?.���8�{I�ʉz,Ҷ#_g���_�b����J(�e-��� M4]�avX�{�Xi_)�:�H_��XWj]��`��U{G�>��P(�]<
R	au>�V�,m\�NKK���ڈÙ�{�J�Y�>@�}�IՁ�sd��~��9�>��WN�z-��}���-��}�|�4�Fy��#-"7�V���tNZD���*���ƕKA�y����z5�*2��4<e!���}�Ҩ�[���g��y���,��k`���������(}	�L2*EY�ܗJ/������p}sKo"s���E�Yo��k0���Q�[:�S��w�x.�0�s����[�[��]�t.�w�E���;�����;p�_���2|I��3��<    �&y��]��H�Ɗ{�ްS���vf���]��`a+#O�����VFR'�w�KcI���aZbE�M�Ə��Z�k�Poʱ	ҢQ�S�d�F���A�5�����u�\Ɠf`�����c�V��cܶ,�)�88Zi]]gE��Ҝ��3��1��HZ	�z[�|�����}��ŝ���l��O��i�.H�?�-�����mI"59r
�a���R]F2�R�h���x��԰��M{=pg=�:,�v�^D�J���=҂�����IZޤ��%-7d���i��MtS��,Z;��3}�FI;̧~���'�ya���Pm��x� �JP�k��7؅H�4M�e�Kŕ�	�N���:��^�/�:�YIZ/���{ף=��:Ͼ7f��a{k|��}]\�F4������������N�}����F�rpԾ`D/��9P]�TP���ق~�p��͖�'�W����X?�=ѧ�l&겸n��5��DR��Bpo>~<|:\�|�;�����oo�	ua��T��2�����
�GU��I�mf��I�'L���dX���*-҈/��K�J#���I��42��2�v�@- ����C-�3�l����H{���i8'���e���ė���SʥH�Q!��t[��i�xd)���0b�;'�.������%4���&��_fjm�2�?�������e"��d�_�LW�ˠO��N��Д`nRĭ�Z޲��	�+f�����d��X3��D �ٵ�Ŵ�	�Dj�c�"����yW`�t��'���ŉm��N2�E2�Fu4�9�i{B�T/C�q�G�A9�B���fN{��� o�w�&R�[t�������Y�J=n�P^�?��u���i����WdNlZTRc[G=Y(�֡,�V��>S�9�	�J�o=���g��U� ��W_���TAZ���p���y�Z�HɃ�㾂²$���Lя� i}(��*��D��g�@Z$p�A����Eϝ��L�+�Fn��tWu^ة}r<9 (��u�$l$/*��ȗ��5e�e�Z�%��.��~�����Z���%�W�&+��Â��5/�|\�IX��4g^��E	):��(�vj��Y�aHq�6HX3�ڞ�78l����Μ+�I�R�J�p�=�
���7�&�ivo��W��'����<Ï;D0
 y�fP���Z@3������˃S[� %�ֺ{���w���;	p�̨���3IQ#��_ߗ϶QQ���a�H-��&��!;c�0�l]�t�c7�e͖����$V����0ԝ%�D��<?������o�}��+���K�Ő��?ߕ�����U������pC��?߾}�������y������ow���|�����79��]y�(�Ȋ7r<�#�1#떣	ai�����c�rt%
��3��vJ.[����[��%ҭ��+���a�襎G��q������e��}Aa>C�5���r�#?��T�����'$3W�>�46o](��YC3/����+wl���Gf~���	F2�![�l�}R*c[rd)������w}��@���q��d�,��]�Qflp%	F�]hN��Ĳ�|��-uJ��.U�-�M�|�����_�����y� ,%T<��5�.R��t�[��X��@k��/����@����|�Ɉ�ٜ�����{�d��I���^��ցB:`��^�V,Tu��;����;�[���C�%+�ϳ�a��]:�c����t�F߶P󉆞�X�!m��R�S	s���ܱ{7�HEoyθI8�G�`��ר㈄�K)�O�	5)��������ww�w�����Oz�$�s~J�����ܫ�#y�`[��78�D��&�45I�X�͎;,IԺ]�a�s���K(6�X)�������̉yWyH<¡�a�=�~1��$�$5v���%S�]�ny�pV�83|�(���xE���|���-��|����` �nh^�Z�|���t�����R�ׁc1eeŹkq'���
-�(�6������k��������Sݖh�Sݼ���n���=m厐f�:��g.A�^�R�g��ta.浴
��j4����z�Иټ�l��7R�g�|H3${I�H�>\`�0��-����T�^�}�7�,8�i@���0���ϸ�{�B���~�]�ǛB}��zp��goy��_rp�F|��Zo
��$jk����.>R�V��lo��� :|}�Zo�(2��L�^��#����u�o;U����(t<wY�����<��A��zzU�*�^{�%C>6�ַ��(/H����_n�~���/$����&q��
�*2 ��#J��Q�"1y+I�$t��p.Gz�e
S���7J*��]{L�Q�dj$FР��M�r"�B��Ŗ��j��[	l�D��@�@eZ۪��Bp��L�j�2P���b���B��q�-�m��=�C�0�r?�o�+�C���k�oʻ���\�R�04K^�:�tLi��YIkI��Ĝi����X�c;^�\t�T(xfZ���nDZL;����C��ΰ^�r#��E`gE3�`�[M�E����'z� �Q�d��&J�x��c�;�-�SI~\��/����%���Xuq4�_T�ť�����P�^�A=}c4�u�=�r�]�u�m%6w��鹩Y�`�����="��v��|�v���$�b��^b��¨�����<�|X
�o�(���4��;Il�*b�^�^�H<֣�饍��K[������C��l�p��K��`���p㊴�5�/g^xi�(T�
���n�׼̲�u/��ty�rA4�:�^P/ݞzi9]"�h]�d�m^D
%������w�����2����ؗ������˻o~�H���Q̟*,܈�!7���hEޓP��� ������n�>��O�!��+K5�������
AB껕O]/�P�4o踷7���l��V+ӠS����a'�4k��f�ۉ �rתX��7�k��(���� `��)o��Li]h�U����k@S���K��}�Z�y(N�F�pj��aao"����A�a,,G�{|x�^E,l��ٮ,FX�cas���ڷ��9I���^�o�(c�';�{6�#Q���8	ĩ���� Àm9:�� )���fevH�mX���iچ���.�$h�1$!��sn}�#;�dZfr�vTi��o��ߚ��-�-M40�E�Ӄum�6!@��F�`�!8�@��t^�+�hM^_B�l��:�u����O��p4hej�
��F2qwn��}��mS����:���rz�]���c,�T><��q�z�V	"�+y�V�4֥dW	$�JyA?t���v3ӪN�m���%]��n�F��K>�{(Y�*=�%6fq��;&�P�Fq�)Hm�k�Mè�v��B墩I�]�1^��|:и�y����a�s��ɳ�O�ߗ%J�{�|}���%�$й(�M	�k�ʨ��HYś�G]겣Y��cJ~�*�c, +�tM�,\@�(Yh�tJ`�j鈦��l�"�)ş�Bs�o$u+z�3�p�[3ZEU}�Y�n�h�V1\b�JՊ���c9vg+�k&!=�s�M�f�j���^�p��k�� pm�u#�;p8�4f)�n��/�^
���$�%;�T0o5c�V�b6��X먌jP��k��uuK@F�ʨ����R>W��@I�P"�:����[)�Q��#u �q�E2�>=��e���al	��djJ��@IC����~{;�4�� J���@T�Oh����
��Q�].��%�%�r)�Re��H�����欻y�,�k�
njSWqkY)���E�@��-KS�Ӓ��G�x`������b��B���7չ���=��R�0��o@�\����[����6�@I�CBum��V(�Ā�m�%�fh�c��fB�%�=s��$E"�f�l��WC��T��S��+�
Y<V��Ҭ>m�	
t]@���^v9��b�=�=�t�XP���J�X@� 5�0Ck��,�dAT�2H��h���B'�X|���j/������W�+����     ��z��z~/�	�Л�q�Z{y$�BJ.����,���R�y�<V2��	����ƾ��u�6�jC� �dW���9c,��oKN�BK�f�<~v�x���S�� 9�=t������w˖����j�D�GArLts
m�M3Ѯ&o_n�E�"ۭ� ���co��k$J�[��q�×�oͺ:3�&�T���=F_�+-_!R9����xJ�w���|K.�pI�:� ���(��j^�ͼ�	��y�`��������
��R� �%X.<��xu�#M/r�
V�ڮ^Gp����b:G�g��6�c�����ī5��+<��Di;!Rg���s� �4{���*������	�p��:�z���Y�E��{�]��4�H}�T8��������fn���͒�m���w��\�fpٌ{��5�ס!N*�姱�^'�ס��I�^�u.���$_���|=����+ �86���)_Q��s�LV�P'��� ��J	f ����UJN<}�8s�����Hu���t$i����[n���"M����1ʯM�'i¨��D�:-r��0�<>��ηI�mh
����!�Z��!o��<{Em��P�V�M|-V.j+^�F��M�J�#3g���rt�Ex����2�&?7j'a<���C5W����uHI<�����/!�i\��d4�p?��ө	���N�� �(X�'��c�/<�����������>�֛���n?��!o�+�H��7	��Vt�8�0/�K���]�\�1ZƔ�:7	�BV�x.݂P�:�1՛�Tgv�v�ܒ��4]VԄ�afg4(1(�Ҫ�9ۅ�%u�V!�l�P+���F}�mB͜ڙKr^]ha>�HUWQ �l�+���٨�i�VO����=����
�� ���[<�'~��?|�?M�`��4h���ĭkт��q��,�N-E��Ï܏zzu���N����hqB½����d�ˊ�;���V�8�K�n��;2k�e�/�2G�Kiۨ��i�0�hg�ԟ�l�9U����0a�,7����d����U�&�7����%�}Gl[�`ʧJ�;�0���%%w����	H�H�B?DA^�
'ޅ�tR/� 5�~�\�~,_hX�|�G��ͧ��^a��ۨ���I�Kj�c�kYK�xUK@}�l��mMHCi�u�填�?��'��y��7�q���f啠C�r��b�3�44���r\�_�9����:*���t����{}��������&��}��;iV\"��^���.p��8��g�����IC��N�`u��H��@*�Q��}�݅$U>r��ÅW�T�G�]F]�������ۅ�|��dO%C�iT�D�S5��pc�.>�D�SZ7�V�G��f��Gc"���WV��!hD=��\|
�n�%��	�3�3\�v�^T$�U�oq\���	�y��4�ܡ}\/���������J����|���>�ǽ�{�?��	�D�a�{����^b�����OM\�ێ|Bq��k��)�ֽ���@E�I�7�>�ys����/�w�~{w}u��»8݅�Eeh �~Ѹ�U�G?1�T#�mN��+AД����P�gx,�:ue�j������x�J�B��l��<P��&w�:��N/ɪ���Е�&�oVy�[��>���7������X��>u�D�EX�"I�;#[�uq�6.���Gu�21�Z+i������Ce�A�����'��֕��TL�nz�Œ��T�.a}	���}]�A�r�E(�G�A[h~j\93�Zi��~C#�S��ˢ!�1JBi��^ڻ��N2U&�&�ܱ�靤����Y�׼���E�-w�kz'i�)�������w���J*|���N^�H#G���S��d)���tY_�;E�Nȭŋ��青|'OIW�/���+���@�5������:y-wӐ2s����ۻ�4x����|��SI]?���f�j�	���GÖA��ξ!꒠d�\���w�}�mh�=M��H���o���_�0NQ��}�y�	����|���������qπKU�-"z�F�+n&�tI4�T�q��������Y�ݟ�i����ǲ�5!֙����u��{ʢ3P�����H�D)��dY�2��ϒ�5�Ա�z�MP��aNT��a���&��mz���x����~]n�F�LT(�GM�eTO�,�^+ŗ(���֍�M(I(�_�E;
#JGu���k��^%�΁0-n�����dtɐ�T���yK�HG!ힻ@|�u��K��p���
,�5Bx��b\�urפ?0P�'<W�{�Q����x��<Kέqs6�q��@@e�y_��{�����}�s�i�ƕ���Xc�4.?Ǻc�w3N�~�H3�|�R�|\�� d�¼o���sJg\��U��*��&[!�=m��kO��8��R��D�6�L�IV�Qjx�i=�h$+u)���"3�5Y]�d'��ZXx귓���=�R���+@>�b�J�=J�j��<|}#���O6	����Z�j��;����q��`�u =i��7^隃��OV�Dr�\e���2ґ��1N�ck�&{:�t�Ǻj�cZz����l�L����8�$I�[�G����\!�( ��B=�Jg����$Dm��	a\.)����������
a&��r��#��<uYD����T��`�{ܵt>�+!l>�Fn�C�|Zm��/!Ъ䟻�:��J4�F��+6�X"d��ߗ!��稂��Z@- \���~ǉO����4��7�]�W|y���[�섫���3�)Y�_ �[�8U�)[~nZ�b�E�P2p�DKW2�| lȀ��r�9�t������FQy�(R/��-�Q�%���")'����V�o��Z�8����K�3ś�#�X�Z�oKZmօ�hJ�j�v����v8	���¤R59t�>�nݕѱ��1�F^0 ������/����E��ME��`l�HW��;�46lX��%��� �%ĸ���%�� p�1n���G�T��Pv�ɑ�.��o�f45$ I�SQv]x]3�"�D������M�7�%G�.7�憏�	 ��WŻ��߬�Wu��sƎs2�$�I#� $�&5�#S�I�$<y�M����P�[Т��b�^�0O#S����]�p�o�Q�ԣ��2�������1�m��dĩ�L,�R٤���$��Kl+���%�OJ����_��cnnM�^pP�p��[$� Y���$JCibLk�T�PϬc�p;�4ќ�M��G���rC#@(�/ps�&*,�����P]��]���Z���W �I�l�]�+Ԅ��C7a�j(���=�St�²��4��ǚ�|������}����i�ْ�b��kD%
r�D'�%��
��8҄�~a8ǻ��k�<@�ʈ��,8[�p�'�i�6KT���40	i:o��� �M6y��vÛ3g(G	��M����&��.P��g,	�:n}
��l��p?����P�Y^T&	�������*;3Ē�vh;k�Rɐ���*k�e1*z�H�HP&2���ы���*+a"��N�w����M��j���H�Y�#�ID	����Y��x�v��L4��i�LW<?�?ݱ8�e�@�]�稠葁��Z~�4a�|Uy̾n�T�J�Ó;�]�*�
��x��u*�n'+(h�~v�E ��
=Ѵ2g7��yeٝ�M�~,�U�n�|����؆ٲ"��whxΰQ2 �������H�k-+�~�h�x�	���E?��x��_}�R'+��_�R ����l�3�@*E�E�}���i��Rt\���>�������_��|��Xf
_]}��\�o��+���=���DJ�T�@��D\��������qt�uA�0����^�.I: �g3��I�pC.9�}ũ�g��y�Ȍ�*:Q�!]N?��N�4��<�}���I��j*;g$�ÅU]������Qn��󋿡t&:�����ݕ>h��P�gp^o-�r��    ��2��6y�%�]"s���n
Q��u�&���X� ELfO5�A�.�7k 6��F�JG�@'�8v�wՍj�n�k������$���\��~��do�ڰ�8\I�?L89a�������zC��"�CS熅�"�%���JQP�@���?�R,��I���t��c7�Z>"z-9�F�;�7��ʚ�0��:+�"���DvS���&��������Xzh1�zd��t0��sM��G�B�և���^t�����#p��%�q�����2��(���^�8��;6�h�.������{��F����ϷyaŖNL�%M.��

Q��%��TՆ��_z	��-Q�\�v~���}��\f�aKl�lZ)H�>�BՏ����/�:�׈*<�Z:@�����3�;@�Zy��["�g[�q��#9�$�Eq��yp���m�9=�������m���O0q���y}W>��`V�m{}�\{���l���;���.���cRv,FAG��([�wA7U��-�U��x҂��Q�/k��^$#貇�}|�0\�J:K{6v�e8Gާr���wK����#)n��>Ǒ"a	F����]C0/��U��eib h<���=m�dS����=-�$=)���K����iҮ ?���s�5S|6�
�L�l�f�w�DS��Mbh��`�+��hW�e4J7�o�P`�4�(���%�=U���t�n֧T.Ǒ.��ّ�����q�?N���ÁÌ+����K>D��и�n`�̓`w�>�����t��6���E"3����pL2�I�R�����[� ����rnx���zFf\l7 r]?�k�1`oR�����V
��s���N�(ՙ�����AƋ5����jׅ!7��j�@mq����ψ�����~=_i�iX��O2V��';�� 	�M�m��9�z��i�``yx����5�,+�j���X_>�GM7]6R�Bz�9��
��"��Pf�ő$X��B��� ]>��t��F@�Ł����C���X�4��4�����ׁ��F�M��T�F:t�qX|;����It����|	F���#`�W���d�WuA8V&�z�g\</#D��)��n��/Ez��$�ŝG!���_,��wq�J!+N�5Mܷ}g$	5�Saf`��(�!p�O��!�
qej%�eb0�������w��p}���������������fQx�(m�Տd1���Kc�fz�f�����j�A���J����7��d�ʹ��Qk�eoF0dn����t*�K��;8c���0�����/m{�v�PdN��g��qR8�B����MA���f\]Ǐ�@�fO�a/�m@�%Jo�g���`\�|+f�s��j���˾��`�T�(��]0�S(⦓J����|>O�3����D^����ג`����ɟ�ޔ��/��F�J���o�C�p�x����|���w��!3�oo�^(`O�7+{>�8|�`�`�e'�vÛ�$D�ȍ6��.�(#]����'��]����.Q+hP	���B�p��ҿD+���,]�΄%":��� :�������Y��������Di>�w�U��ĩqI4r!KQNv��Ɔ(	<�b<k��g������&=݃�0�Q�4�sO�|F��秡@����faXc)Gs��-cvJnw�V����$P3�Fǁ���1�@��/a8��Z��Q�K�ro���tuJ�	|��s6�;-�<3��i&ӞBHRo:��I�r�&�<�@jf@�Ԙ�x�s��#H=��N�oϘPZ5IFMqP�3�r��%��U=Է-/	�y��M�e
��Z8���2��Qg:ŝS*��}*Wөp�,�ւ�&�E%+������|��|��W�[���o�����3_e|����y��5��w���{{}ww{ǀf0)�娵"Z�8��B[�o5H�4���n�M�\�G�rY-խ����S�O/j�f�)�Q4/���1VKLm�Pi�M,�j����U��!@��aȈ۳/�
:�ݩ4+)��ז���p4t!;#�=��S���n^g���y��sq�q/K�(M��-��G�$�>�7]����Q��w�K:�y
��Ag���ٱ��
�(���>�lt T} �W���yeM7W)���x�nz&C��7��j �z�߳Q�
:i5�ӏ��}t�jP��L���-vj5,Gs�i�eἄ�\��`���86Ӱ�JY�����%��Y�q?��#��Q5Li���?F ͩ��3��,���cҸ,p�󤴱�¸h��h1�>�!�b��Q�	�g/�t(鸥0���K��.��h��e邤�|}l�8��|�U�]�
�$�9~���1�ӂ�����q�tFұ!w��]ᬤ�!
���Ag�; �.�F�I:��.�C	�(T껰Ηp�*\�^�i�Tܬ[�X���s�l'�}~�3Y�UC1� uzF@j]���U% �:;;�Y��U}�,���	[��0�|�����e3}�Q�ggy���%g����yj���p�Q�g�����=GR���
��]x(Uw��Iy��3�T������u�b�t�"�1�o�����x�|w������?>n>����$^�}���.���������m7��KX�%M��p�24F�P)i�E���VґۤR!'�.�=Z|���5�t������.DyE����G�h�a��y/��̚F���>��Ռm��m�T�Tz�OMc1�u�R7�ý���3�O�!H�LS�u�L������8R���q�V�QVH��,H:��\A��$�5����(�h�6��7������O����c����Z��Pl�)+���W�82&o�CH�9�$x	F�Tz��lk�A�� �����.J:n(c�e�$�\e�e��Cn��IW��	��ͲK��]��K�9h�8�Gtt�}�k��s�.�X��
�l&򺋾��6z�ȹ�a��+$]��~���%"� b�再I R�CPz}�d]�T���-�_��Iڀ��~Hݴ��Ig�C�$��1�Om�.K'%�BV���y�6 ���>�&�?f�(��3_�n���bZ���G�5EAGs��L煔$]����� -�Z�e�N��c~h#�x���"��t4���"p��Գ���h'��G�0�%\`_��c*h/�*���"�4��J����T� ��"� t�t�k���b�-��~r�Cf�����7�� ���x��g�w����7��?��U�JH�s���$��c��M�B�N@w�t�M�:08�|j%>3�a�4/a��O�껿J��Awl*`���`�nw|-C�6u`��v<�[_�KX���o<}�頽�L�����6ꆉ`�֥��ٝ�s��r�k�֥9�B�/X�s����]��N�P#���"��t@m#!�	�¸H6qUP�=��:G-L����!ȧ�c(�{��;��������4cq�1��0��Ⱦl����$@w�Ɲ�be�;�q�Y�^yD0��}��^�f]�-b I�EV^7��qE�����([��/$��23@m?i��!�,��7�F(I��M�%��6N�Ԫ�'�Ԛ�$#(4�=��wRQf/.�XQ��M
N*�a*�i��T��%�A����*L��H�}n�9Hݎ���bqL''iTXS��Q(H�����M�t\p�����b��_��x��;���0��H�u������W߾�㾢��ڄj�a8	�/�M9���2L v����?/���w���Fb.ߴA`�'[PIUs5� A,��Gl�&PjM:{����ǯ����wd!U�E.M5^`�'�/-T��� �ԥ�-c�JӺ�=�*è"�i�\�i0*| ��J
���m�����#��1�σu��Q����y��FYè��`�{K^�ж�8�
1�@ ⛯�D���\�e.�FՊ�(�Ϩ��6���:(Y{}
�]�������k�7�"H����]�(�?�ؚ��fa$C���
a�jjO�]r    �%k���4k8���-���
FJ"pV%N�����î�� ���-����^���x�xK��V\�^<�P��v H;0��'�}A(i (m7���������|�4 �- ��"�4H��q�"Ϲ:io���1���BT��X�@'-rs��E�	��2 �5����e�D�BpS1���t�)P�q�¨���P�/i��㹢�,�$$O�}�%�n�3�B�I@ZC"�}l�%Plʙ!��_���o���e��c�J�5m� �h��>f��X��~}�?�����Q<\���O�_?^��� ����/wW�w����f��F���#�7�����7�6y8��@�h:+�.ZC�F�*�͐\�\�Oл���{Y/0����맗㷑F
)n�<}��#��JE�^i]��b��@aP�>i��du1%�4M@�x�m/�sZ��a�D�^����h5U����6�N`Zu1�iin��"�������D��A
z�;|����ba>)���0����4D	���%]>�S۟肠#?B+�ŘV�����I��t!�$�&@GBg������C�#�-;�E�3V�9��}H$��}m���	�fͨ��t(�*#(�=��񂎒��"�Lp�a�2��gg����D���L�t��]�>O�]��)�����I��N't�9�ى���IԴC�>DΒ��:'�RTu�آ�t�]̽t�:�7���lg����.��M\�����9%��zL�:�0��<зD�[�}x�%]��tn	AG��lZ=*�*�́ϧ�f��m���`��N^�J�o�T2Ԗ1�@����S]O�j<�5����[��%
���2�v9�x�xAA�f���o�D�dA*a���"u"�3^��.�$P(�՚9�	j*�	�ILIbi�Aò&7����kX�Ҙ�0�׍�b�,	Ȏk� ݨ^�H�w���8nTC{�.��"΍�k�t�<D�"�֍Jn���SS�>�W�j�#��r�.�g�Q�RWU袳�C-�"��C!�Qi� g���}\��t�;Bw";�t�x>�[\<�ҡ+�kQ"ơ��ї��~�Bi=7���M3:�҄��J͇� Q������K�1��p��m��ACA����?/���]��w^�k)�����4�QF��b���jd:��3��4���y��݌��²���8�yi'(9^�/Ш�yil$���
�FPEmV�3]q���il�X��#.����U]�� U=p�	�����C�4uт���Yz��>4HU��1t�!����|Ph]��̩��pӃt�vw�E���]�E��OL�]��w��v1��EiP���W�5��Vu1��EiR5]��(���y{}��(m���qRn����5��CGi)�� A��]����(�2]̟rij)(���|�6�u\2���ȧ��G�d�)l;A�%(1(�����fY8	a8YO7r���G��}��:.y4H���ڮ� 8(��(�9��G͕��rc�����$JDE�#>]}|����W?�|��oﮯn~�amVن�.���2/L�Zj[��l���c�o���>-"�S��f�9�c˖|�
���x9��?=�	),�O?������Ç��3���
�����:��Tf�c��eE�N��Xđ��+
VH���K��X�`�H:]�5V�v��ubD��*euZUﬡR��1��p
mG ��T����ҝ��o��e{>5k��J��{Z	���Gnad}K!�������W���x>M�H*���}���P�֮����_�oxTC#5eB���l��Ծ_Eg
�N����tU���h�|��E�p.Z�S�B�nڷ���X��T8�@(eG���||�TS˰�<�Y> 䵈-��㸦�!���Y� ����NJ�F&r\!9<?�bӓ���ǻ
��L�R)�����j9ǵ���[�s���.���[�.1R[�Ѱ�A�M ��5D���"H�����bŨ�L5&7���i��R�|�牪�孻�ic=e|��e����`�Cή��ْ�`ブ��J�à�s%+��|�Ċ�������Ηϧ���nޫ������?���xs�i}w�M?H6�<@��g����m���vެR�S�mV8��bC���5�e���Ec�7
b��#EpuZ;wr� �J'�+;�P7��RRW�PkT�M��D	S���GK�#��^�:�Q���P>��L6� �( �od%-!N����|��y1��������Õ�Ug��}󗟮�oB$�y��)��̂q����r���Z�qU���L�/���y��s�}4.�cVjo����^�W�=<�b>m^�5��c��QQC����qe�5&v-u˸ �>rR�\ף�C�r;8���h�H����TSռ��$		��m�=�t�A��4v��S�Q�|��������Zڧ0չ�gY��]W>������
?ݔ?���B�@�7� a��2��tsQpP.�.n�w�h�4�`T��懛Oן�?�m}���>*�]���o�w7ohj�:�%uIBE�.5�'q�HIQp�C�Z^`Ɖ֤���14��P>l��-�����-����׍9�J��}l�����R�=Dv��ޮ9�I�ֿ��Z �ć���<�gƲC�����h����t��g}~��̪&�Ů�.t��س����tx2��|R���z��ϗ_�c�]�A�롪v×����aEl�?�;�)����ߟ�Ν���ⲍ
��ʙ�+��ުA�����G��-�t�[Saђ�v�m�q]��`a}�+ݵy���`sEtk�� �*��>�~ʽ���o� @�p��l���{��U���N�����*�YFK0<���+���8e$ùh,X�P���+rW5�Ϳ�����7rJ�+/UPe��NI¬��|����ʜ�l
<~Ɣ�j4I�����s�d[4_�X-	n���)@��[��L��Xe��'D(��xʃ,�<!D��	�%�i�	;!D��	"�8�� l��y�j��'������cyCK�S7���'\B�Dk+�բ��tY,��x�i�X�P�,��@���2����	!f^����#�� �̫���;R2�7��r$�d�T�X=1����c�|�	�,sP�b%V�:��q�뺁�K�raI�{���<u���V�L��3.��t�!���k��9�%V�8g~���p3=��#_���{ ��1��fP�aC�(h	Q�	4���H��B���%@�Rg���h{ �
Ԇ�"J�@m�[:-N"�T�3qB�^B�y��Eǃ_��X!�TaV��/��@MN(S�d$�������[��S=���۹V�<AL�Rm��y�ۉ9��y�K�ʗ-�v�~EO��e*�8�R�)�H�gb��u�eq!q�VSJIGCx������J�&�.������ߞ,`�������qS*ÖAhw�f8�I��Kf����ѫ�n$�?� �)�� ��F���{���e�	@�!��oM<�~��\7+p��d�	�Ƭ۲�(���;���ճ��&�0�M�2���w��9�r(Ԋ��R���K�(�fKb�Y/�%]ߨB�|Έ�3_��9-�N���Qu�=��8ץ]��'�/3�T}ٶuVB�C,�J(Hu��<��g蹞��g�����?��/~��Jg����K/�?���:�*C����9�
�8��U�6Hh$�_��$%f,�lr�s�h�}�H���r�w91R�I>�`8�;�H!���P�f�A|;��\�19eQ��|Nh筄�y~Y<��2�G�O�s�<�rn��xS����((�ͫ�ߗ]J/��\��H.�������{�%̫�ZԫO����zE�{��2�u�{Z�o�_�|4C9tKs>uf�W2J�Ne�#��.\ڠ4�S�a�B���5�����u�*p��>�����ɝ	���-}\Z�ǻ�v���p�7(���m��=����sm�t,������qK/D#�\���>)    p�����;�PHyj�J��	����$fql�>�j�u��4�.��B�հz�D&758\�-�6@��[��)���"���)R��A�+��<���/@h	��"�Xa�HZ+�n��쵢O9���c� C�P����l�(6�������&�:ũt���$.��n=��	�G�[�U+��n�����M��(��D�|��uN9e���_�T���3�WZ��(H�����?է�ǻ���[w�S�WFb��8)|�ؼ�t9s����) -�#�?NX'+A���ՑDN�W�?��g�iE���]�`J���YS}�(�%e����x��$����ǖ>4J�q$�%��k%AD�C�ɋ�����+��Kv��5�P�2��:���� �)6P/�)c�nX�<�87�ë���<�����4ű��Ln����d�|�916�1UU��}�����S̼Y>obt��n1�1�,3T�k|'"��g�XE��{3�ߟnJ��	�1ڽ�������:����Qڽ���������'�t@x�H�����
�J=& ��%ޙ,H7F{:�IZ�4�}d�5@	"��
I�o������)j.����i	�X�K��_��Z57F��?�#���7]��������0�ۄ:���j�#�yB ��%�����kE�t��	 � A���qM��Ax��j��b�`%9�
Ñ$���R����!�yNrEou���UܦG�em���*aP�cx���� �T�U�X��*(� %J(\Y��V������ø4u��?y���.p��tCX-0��̼p)��xj����OT��׷Ww�=CN�Okr�:W��W���9�p�$����G�����?����*��!����u�M�t$	eS�޿z���_wW7v�����wU0&HT��V��M�����Ҝ����?W���sm$�0_s��m�2����a�'
V�tψx�A@\�d4�<�v�6b��W*�l#�hV���f�L�2�j��-�(�"Rp,Y-��rO (
l�e
�u�-rm�X��ȣdSp,o~��Ѓ[Rr(��ӱ�5k�1$���,�#ς2���p�$]2#�$s"��
{�z+�${֣i����9ɥX�����N�inB&�����IZ����,��N�*�ɲR�ץT~Ϡ���?n�}������on�nv�J��]�����R)�8��#"%�}�������!y%!E�1�9�����u�|�7M�	�I=�Y@ �\~���c%�ݛ�]�s<J���� ėWieӸ����Ӫ�2��*{ԑLr04@�'�Z�&Q°��sCMS%L���[q'..
Z¢�-�	F��@Sۨ���W_^���(�=��ӒkY�cruS���I��b��҅����&���������������7�Q����&��z�����_���U4��D�y��½8��a�&���'.�KVj� @4�)P0�b��Ҁ��I��$�[d'�7-�%���ggP�� :�Yw4jS׫�ѡM>���cMP���J�Oѻ�J�(�|�ͻ�{ɡf!S�8_M?ZW�8R9�q�� N AK�T7i�' #3'�Ѵ��`����l��	�r�#JH�	��A���M��s�vGP���VjU>��y��%S��p�aL���\�|���m���(ac8웼�jz8(�#Ig�_�J��_�pR��238� �EEC[3������?_���X��[1�ϑ�t�D�9����P(*�_����Z}ki�#��w��J�C��:A�fY�����t����"茏]�U�K�o߽}}Y�$;>0�t�g��A1�C]�b�yВ��籩ǚ-?hɰֳ�C�r�q���H`0E2�`�A�Q`�����m���`T���-���wA�e2F�H�]�S&��ߟ\��G�Zn�.�rޞ��d�+�.��/�����j�{�)&`p9���ɻd<��&�=_�v۩�w�� �T��/�7D� ɆX��-���ﹽrG:��.�o�*�K�09��%� ���X(@+����]�%(��s�IB�/�:<�)��G;�8�H�W銢͜D!x	��u͢�����F	���8Y0p�1� aX7Κ�:��Ź�w.��t��H?d��R)\-�<3�t�q�*���=���� �[��X)��*Y	�S��I���v�yO�\�|�|�0'���� z���X8�C���jB_�oes�$��c�4
�_2H쁑����x�&A%� O�3aAFv�IP��@��:��o�Fb��E�Ӌ�� ������G,r�A�W�x��<fL?�ß48��%���B� � ���N����~ORm�h��C��hI*C�e��-
\H�h�2_zq�M�5-��4⦸"��[��8�,�d��:�H[�H(��jL_��(����6�(ҧ�?戒�����Cy�\x�	�9	Cx��$:yu����s�h�ԏ<+a�b;������%��RMY����߿}�┨�gGDaL���b���7}�)�Vؓ3Y7�o7���n�*��JƯ�F�z$'���{���7�	=B��h���`�;���N���R���<�m^�n6���+������าpΐ΅!I���R?q��[��1Q��zz��K��J1�Y%��L$�HŐ!�¦��jYH j��zv���$�&&q;N6�RV�Uiv��H�p���� HN���\`��3�ٜA�*:*�7"5�&�I��`@/�%}^�r�'	�m����	�>v�^M��$��;����0G�K�T�U����S���ز��Bè�R��%��.f̡�����9:硙�!���=f\q1��(x���cTr,\�h6����jW����$x��uu�����Nm<G�@�[`'rx{���&�_w��=����}���������3��?������g]��0�:_�u���ra����~��,M�к�˾,����{��P�) Vꈽ��{��I�q�&i�2��T�����y~]�Qi��������/��8蝩@����@b�i#�8�f��$*�c0�t��aC��*{��K����oH�p��act���v) ���]&H0��/l �U���sd�+�1����n�H��g��[���=�JaD������)F >EDm�o0u(���7���@]��83�����5��@�B}y���$�Q�@�y����c�lV��4�5!X�Ҋ:H�zϜ-�H2�;� G��
�g�;��l`(:�����7H��uUE[�;��h�v����u+J�f-�p�9�� ��9�8�g�vh]4��\6��֘��k^�ڝ���2Xw_�,k���L��NO<��-�M���4��ޛS$Wڽ��QA֮�qv���m�����0$���k�p�}!T�o���`� c90�K0	HO�f�N~x#,�%���b%>RF�=R��� ��+CpVq����r�3m3���������
��℄�5Œ]$+�XI�ԷAc#�����t���ѽJ,��_vwwi5��6}R�Ѫ���v}�Lg���~]�Ρ���ũ�
Kw�5���J�YrF����$�������受��a%껮|Sق��A0G*m[�E��P��]�h`���x5x��>�9&}��%Iц��k�=�z��ϗ_Zߌ��#���<�3�Gj�i�9����b��\fn�>�{���w߼+Di�1<�:��Y��fU�d4謹KE��t&[-s��pnN?'���ʬo�,���X�6�UW6s�d����l�$"���&K��囿_~_fm3G�1<6��3�UW7s<|'6��/�g��}��D��$���:)���P$��3:�HƞǞw�K�Zo�>��˿�J�8�&�A�i��3�5����N}Ѿ�1�����%�	N��frg�3�v�Qh~�M�G۬+o2I�n�.�U�����4pUŢ\&>A!I��t�>s��0M��?�~��x?^�-~��O�z���H���L�f��3��.��tu������ss;�_    ���Ӯ1��6�&�;zަFr��?���yyV=�>czO����.�d$h�ؒBj�g�/d�iQ�	'I�'�BH�s�?G:Cc�*+&q�<^�F[ԃ(�K�?�b�����ʄ0H'@��ȽUE*���}ÉdmD���a~*���_���	��{j$PU�\W��(I�T�
�j���e
�� �+�3r�TI���s�!y�p?�^d�����tƒ�'��K@���ѐ���_bSf.���|�ᎱFm�f��#zu��^����!���-Z/f���+��R��|���㽜�ƭ���E";���}��3WD�����|�<�l|�x
���l��3oE3�+��h48:���yj�C�)�Æ���!f�/��#���/�U*s����8Pg  N 2�x�g�m�If�3R=�:���~K�G������&,�[�^������U*s~�.�l��-�M=��5Gܙ��wx��@�����5�	�tH�\f+�4�t�M��bU����zd3:�1H5Z:�5�#�	�FK�CX�g�B�XK� �p��2#;� x���A����W��)G�`H�'�RYP[d[Hz�W�ʥ[�|pg�+O
>�A|I�ocH��Y���������f���_����������.�0�����Ϙ�P���m�lu��ɤ:����y �C�ӫ��l�~&�m˵�Fw0��Ɲ��h2Ʒ�Kn�/f7��T�,�Ղd�IG��@z�p|3�h2���k��y�@��X	�7�E���Z��<Ri�	|�KP27�m��Ee��j΃�+��/N�7W�b��9,���M�Y�,d�/��4ݵ[%Jk*6��l�1����ir�gBY���H��)w�����0�����#��^�]\qh�3�)�m�����3��܌]m���t�AQ㿪hMϭ��>v�[��ҿN&z��W����*>�>5>��_�<�x�c��@o�|җ��,n�~Y/{��Ao����!ef|VǬ9���
Ίγ�z��2us�F�/Y׽�.o61�G����v��V}[�ߦ���~w���������2Y��z��Yǽ�N7�e��4UH=�d6�����)!��tDֿo�م�pѳ6|���6��z֦�@ZS9�2sA��ߔ!3����~���G���{߲�[Ɯ� N=�`6�9sJHE�+�����:NK��WB�ܵ�-��#GO�q��3Q��O�	W?�H�ҮvÇ=H�M��7�8s]��Y%�vʥ�|�^>)�lӐ�o�q��ɶ�9�M��ۣ���^)P&C`�����U��$h�����f�1�0Y�dY�U����T(`;���Dkӭf;��L� ���cAF�e�~�N��(x��) љ��6���7$��VXW)d�4�E���۱��H*��෭@��"AD� ���� J_A]��.���L� y�E�R����r��g�`%J&{������dBKI+�hT��(�jd2-.�g�?��*�ߢ��z��D��[Խ���t��n��dZ	"�3���L--����gxp2eY���&�	,$���T�Ȟ�d�dsK3o�4^9���LN!A�a���V&���.c y:e��N�����B�|N&s�4�_��o=3����<�h�G�V�@�R@G�<^lZ��.�Z@�c�����B�-�M=�P�@g�	�S�=��ċ�C�P��Զ�DjȡÄ����@����2�f��B�AE4���΍b
4�&5jw~9-T�¡:g���]��`��2��qoPu�[)濅��ܴ��R���㻻��@����#^}�}���n�w�9Z�s���T���,�Wg35�1�k�������ȍ��=����>�(̻_n>^�=؋;�{$��� �����Pi�y��&7�QӚ�ggŴ�x�Q��n��#�Ɯ�H��SK-�θ��$.�}Y�:~�6����߲i�W6��5�QM����>PuGp��~����������;��:�����������,�|�ӋM2�� L�*YR�*K:h�e-��d�"��)+>����;��pp�����jcg�L�&sU<��4�1��&����~�RTZ,J61�8�J��t>�)�(����t=��%�L���G���Cl3�'GS�����f#�*ā�����.��%DJ�֙���,��!�OK��۷/2[��>&2��K	ҳ��Y�h�\���	��?I $���Lp�]@����r����!c��������9���PḧՐy��џYP�;aQ~s~�2?Ľ#�qT�R���JZ��Jim3��0��^��� ̜KeӰ΂*]�f�(��\<�������+��]���V���I����K����*���<�9;�_�4�;��W|��6�1�|<U���݀c�#v^�OxD,|UE�U���_P�N�t�G?�]��?�(]D�Ŝ�CJ7�~�U|b��Ak�~�h�4�˒������(=�����V��i*@9Aeh�i��3<_���¦��|nj(�����>���<�9l��e͐�&�Ϡ]���2Qߖc$�y/ֹ2MS���s�]�*z�X�)3���Xo\���en��wN12F��k���^��Wq��#KY}�}��+��.�'\7ϱd�e.)m��S>s)��ZQ���k_�9�V!���N�gN���
�?;K�̵0x��9��|��� P�א�}�<ՈC��~�g����+�6�hmT�����3oX;�r�'>�B��:�q{eN��s�f���ʹ��O�!s!�6��3���h�`�b������w��������.v���ݯ�3I���Gt�u����ǟ��_>κst��su��a"�����3�	X�����'!�J&� �a={0Zw~�� �a�-�I�`��|�� �b=W�aW�nղ� ="hJ��p��� =+��X)쎍Y��c���� }&�m�K���(�)ԺI�2󓆒>���1�j��L�4L�|��뤍��01�)�h���s)1s)��Itg�Q��7��h߮��jw���cs]�G��������Ω���憷��- ـ�-}kh3���X8���:f.̒�C�&�ƌ�z�3�2������>n}�Q�Cs_`����֞6*�l���\J��67�d�	8t����O�X���j��f(̨*��_z]��D�^E�����L� �C��U���d��$Y�b�qV����Ǜ�[ʔdG��S�/j;k���4O���7�\P�N9����Y��'$�*��,W|g2B������]�)/@�
t5<wd�ӕ	2X�S�������y��P��������kMT��'}����{�v�JwG�=����m2�	k�N�:�Ϥ&�G�J�Δ�-��3�:͓�iև�5����d�4��R�4M�&S��፺RX>g2a	�ƈ6�;�j�6�r����W�4�p�eM,���6OK��D�U�U���L3���Kў?�d��5����W�ܫ�wW�vw���&�˯�p��_�2߾�3��m��lJ&)2݋#:�#��)�H��_�Ȧ�X܃e�����w_*��e��.!ӾH �V�۔2���h�j<��I���9������;b��N���.��E�&��y�2�t��%�Ռ��<B$0�`�/�T#n"8�6	7S�@~Ԣ^a3p%�#�8�Q�f~ ��̦<?�J�T_R3�
O��4u�B�����͜͡�����6�fn�R��z�p3�e�%�	6�o��X4�h�p3�f)QdT_��z�LÂ`�
��!3�B�=z�k��a$�FU��x�gAX }�6�2S�HpAW�nt�{�P��F�Q�Jw�ј$��@�I���%�� �T��M�=��
�`�ĐITܐ�ln汐�����͐�]$��mC&sAp]��2��@ئ��/.V�mn�Ԑt��u����95���x�M��SC�CÍ�ͼ������
�2	t$�b�6=t��Ap��	ݛ���<GZ�mn�L~���b#��s�|@d{|��o,�ɴ4�S��|�}x����s4��3S� �.�aW��>SϠ��)�����E�0.��    6�V^��^�F�V�*��@.����A3�!m�h8�)b`�mC��t�ˌPǈ4*��S�Dٓ�i-�P���FLw�PhI��D����"%���B"Ґ��X�d�v�'���Ias풓���)!�i �I'�9/x��E�=D�F��?�{�����`��'��N��,~B�?���g���Gi#��ք��*T3�0J��)���h�?[����>*ူ�D8�%��MG.n9�])�")�?�Ϟ�/�N�h*%ݷş�O�n�v����O�n� 啢+<w���t��Q�5��k�_^��w	�%��r={��>dIP������YJz:�,"�'���(S��AI��0�kk�Z��q�I%�c�-h��6�B��BO�n�E?�2�j-�M>��ʜ\-k7�&	*sh��Z�m�$�ʜV�z���}�&�r�x��7g��w�ҩ��
�f]h�	.Vz�����#�i��&-@K��Z���&�i���R"FR���޽�����%��3���K���|�Cg*�QC�h}r��9�)�Ŀ�ʧy��������:c��_���(����ڜ��6�RAK�S����|zNi����̗���m�R/8�x'h2��\�m��t��&�\����J��/vW��Q�11��Y	}o�`2��5�Mb� �s�4������������q���M����5�@x�����u�����d���Re�
�5s��H���й[���0ƃ5`2�)�l\��fEd2F���s7F29ɛ�N�v�$�[�~�Нa�_ 96:��c@[ӡ�=Á�1a�5�t���Q��P�OHPl|zʛ>4k����-�����c�W�s��N�N�e<N�Ar����w����cؕO���5r��n�BN�����P`�'M���9�@T�*�V�6�"9"Zk��f�XT
L����8��\zV .�ڌ�I�,�����Û��^،�I����F^�:k3ng�N,�[:�x��� ���Zé�:���+`�hp��3O�GÙ��[�C27)'�o�m��Q�1v�5�JRG����k��D���pP�{������7�է]�u��ws��R&(�y�V��؆���Pz +�Ob}JFG�G�N�ќ0�������d���ӑ�24����ݿw�K��Ү���VT���y�:/�ѳ{��S<i�&�S�n'}����~s��/��1��
$B5�\+��nK|f�q����L���8#�u�E��"Ÿ�V�6�7`(���鯿��M��궱k�l$��:���[�X��Wr4v+�-�p�3ܭ7Ao���='(���I:�����ܝ&���:�1R�\�p�sӥ[M�L+L��&�Ǜ?���|�����J�!����$2�<U�>9�(��cn��DNo5@5���-�	�q��	��Gj��r|:�ۭ��[�M�f^=���gX�H��#�/�(�i�A��:A@C���Y]�su��k*OE�{kF\��hm��M���������j�D��¿��h�ʞ����H�q�ĺ)��`�*�Ι���H���c��|S.?{uL�q��0��4I�An��� G���'�vul�I��ʉ����c1�f�v#�<��1ޡ��ڠ�~�?�;eE���g�){��F1t�,N��z07������ �b/���'�0L��p
�iwY3���{�o]�x�xv[�k����[� �ޤh
5�Uf?����H�`X��{�!J�`hvN����HA���
���E�W�Jʥ�/���7T�������pq��_�>\?��3���pu���4����o�\A,0ѯ��jjf�GISM �Vs���R����4���4����f�׭��C��R!`��L����6��|=�zx����u�Ucld�o/� y״�N��y�g 	 ���DKއ[�5�4f��!0���ۀ�+i�D��;�K�m��>ᰪB���|���[��mS���ވl���	mSs+�M���WzO��x�������3��ts�LJ�.�����-6�})�ϭ�$�(j���ҭ t9B�*>��6 �K�@rcHE�[�(Y���B-ɶ��Ӂh�Rv;{QK�������(� �X|�ہ(�C��B�����{ ��U�n��u�[���B��ҷP�@�׸��"��5\ݹ��(�K����Ym��(��A�J��E�\,O0 ��
D#�K���ݎ�t.�~ۉ�9.F:z�N�1��BK�b=�5l�t.u#�ߐ3�y|▶�t.T��@m�t.�)�Uq;.�H��
��F:���^���ҹ��!+���ҹ�l_Y��ҹ '�����sA�N�Z:�ܤ�6Qz��o;��œƾ��$��@�9D~)��%���I��o��QB4�@�cE�$D��"ݮ7Q�ɊJ�X#!2�8�Z�  j*Bכ�h%DC�`�s�-����7t��w�׍ސ�w�,r�\�C/RB�4�V��F�P���J�4]����A�jF*n�t	���� ����(�	JQ��\������4(ش
�6 Q���]2Q���o���{@.�6z�Ů�t?R�Z����"�$V��iq*��"1�Yh�%DC�L����	�Y�ǂ��	�gDE���fD��7�>���`C���<�(A��g�������8h��1�+&]��[u:~6VgM�W1�����.�Yj5K��U%폽\�,����:G��
��&t�G���c��P��Q�9
�Vr +;_�~ƺX����o��?�}�v�|���@	��5Ħ�ɪ�pek���#MP�^l��֝�T�ɪ�9��C,���Q���H�� ��k�x��[rUe�N�hF�J�I�I��V�r%��3����0G7��Vc�tRʌ=�AS�L�0ekϷZ��P`�!��s�.�H4�J�{j����y0�V�VO�tj�[�K���AP�����}���+��o�n��-]X/�3Z�臡��0����n�S+cE���f]q�c��B�l�6JW���ܽ��[2b4ƃ�!l��B.�7X�p[}��q������vF8N�D�#���V��� s��h�ư���Re����~���'�1$�GfFG�n�=xj���j]3�n��qP��������&{:jD1����ݦ�O�t�B�yˉ���PdCzx�Ê����e��钘��+���#0ԟZQ[�qB��K.�u`S��
���� CYV���n���(F��$�`-7dh�J>�e��|��x�C�����Z����f������ ������:H�Z�g�(���X
u�J�0�(�Q:0��-[	z������Ȭ�[��	��6R�?��B�Uߞ^w3���CS6���so���D6Ԗ�󆄖�����bRu��o��$-���)�_�[_����{��y^�����P�,4�Hn���,'��q�`ȳ�Y^�,f���V%ޮ�
\��8����?է�ǻ��Y���x�~�븩Z��>����(�.U �ƭ��Yc��ht�s�v�Ѝ�N�����#�y�/*��C�z�]���  �Q�3g��?�N ��!=?�1o*�C94>G����.����A�`!J�����o��G���4ґ�PL�����n��s{3s�\D ���<�9ţ�g� ���^T_����o��)AI �Gצ�P��&���×�~P��I�֦��^�q{u_fW�$j �O������<IN�漫2��������æYו�$�J#ϋ<�I�dI��N	J68Z?��c�#c@�����<�՘C�Zӹڌ�#kbƬ�t��m%M[CWs��ڪ��LduU�	Ͻ�DM�Q��pȯ�j&I���Tm^8����QSt�e���5�i٨U˧S�b����E�V�.!2\��y׋�V����v�y�@o}�:Ul��>������pk,��:�ٓ��=���l�*H���=!�j�m�D��`li ��qs�yJ{�H-?aLq N�+*�PZ_u��C�8�7\z�9����b�QT�]1�(���-ޮ�N�PPղz    �5,]�%Ҿ�E�P�\grD�^�7�.�,Ӵ��K���Cx�؅�f�!:+����~�VQ�������CYu���u��-�م�$�#x�r�]����tv���˷?���])�D��8�i׃fM�x��)
�:
H!�wE��A�=�8m�cUS�wB��^+����s�X�(�V�/5�	��5D���J*�P%��j�.���H�hj5y�bsx�D���K$��#� �E(�I�>J �C���!Y�A�LH��8ܯߤ���˷e<L�M=(��4���H �JUk��O?����M"@c�Өܥ&X	Yq����7_?3ɺHP Cgؤ�����[ �Ꜥ
���z`�*o�
��j6��=��2K���͚��e�9vy<Ҹ�tS�A|c,��-7��Q)��X�h8Td���jk>j�Q�=`��ك��(� ��n`�Q���O�� c,�/�$�˫���>?$�1Qʍ�%��_|�x�XZ~��%-���)H�A�8�A@��[��t--����U�GV8Y�;�r�4V7��Ni	��j����씑`�ާh&�,$���ނ�sJz�$��	2]NIoB�.�H��-4�:�u7�s��#��,���4�u�,�T�`"����ټ_v*��b%vT���<�n���i%�Ћ��<�+{�9}N�<U'�%��_.䴑0��+��+r/'H(TIU��ߋ*r���p���uZN?S�k�rb#]��R�(���aX~w��T���/��K���t��#���.��.	�I�u\!�^b��#�`2W�f3V���@hx��V|p��(�L�M���C�8cU���"]3C� �+@1d�t-�a-K����׌��H��9F�I�E4f���s�j�l��~�E	f��	�hi0��Y����+��I>����TVV�]�����t��DC�y�Q���g����oX� �A��z���	X� W���7��}�����ĸ
l��
��@�T>�<�k�y ��ļ�"YLa� f0�j��2]�ū(� 4'�
X@�ox8	���9�6��-�st��:7���ĕ�S����^��M)]D���~ba����d�b����P�J7��P���t#�ű���I��IO+��%�V�S�]�qX�*��F�������c�x���U�JG�n)VU���6�S��BC��x���]���Y���W�%_�������d$���Ub-h�h��c0��8[�r�5P	$$�dy"�
jS#N��H�D���C�Fy���h$N������!B\j`���(�V��A�*�M��c���B��(���>��q��4���|3��-1�$ujF�,�F�������f����{�+Ǡ����]ԟ����AK/�Iw�
.l��w�Y!�1Й�H.פ�{vY��W�Ϫ�I�[����WP�X�8]�q]���B�>k�_��S�{���3���N#lt�."il4%Oa�S���<���<{�E��r]�ٲ��J����q}�5�:�j?EL����\�v2\�_��6��|��z
�6�!P���ZL}��$�h��9�vW3��Ѧ��U�6�%ju2�E�M�v5���j���a)j�A���#V^�|��<�:�A`������~�p.�݉�Kn`�`�-�{������,{�f�`�KZ	�2n��c���:��"�M��u�U�H���֊��0(�|�Z�%4�����D�$i�FA�$�Ioȝ����2�q za��5��Гf^��#����]?O�u�Ɖ�K@���r��إ�H�@��Л���3��v�7^(�2C����������*����h]�{�q �j;�uq�AbI�$��Bs�md�Qłk%����$8��:�����r]�q�	��T��X<w/jT�R1��~�
|����q9��"`t&��u荣"�i�J�r�J�#�P"-}f6{�%�^��)��[�rV�.�T=�s,я]�g��JR=�`]�`�Ak��^I_�-uS�k�,��8�������P�d�Z}��ϷW~�t�w���1M���RK� 4	�z�;�h�a�% �-M��{+�Kz-� x�����$�C�w�1�dlR@�^VW���m�%0�Eiap�%�R����a�]���k-�kyW�pH����Ow���^w���ʎ%��mR�rt�����c���io��5|���G�����uEq�Y��ϡ�S8�0ol}�a_�~J<��x[\��'���$�3P#��K�8ʕT#�&�0^��D���� �@j�J���"H�DZ�*,#k.9HcX�Z�������iơ
���&� =ͫ4U�2�x}�1����ǻ��M[?�Ͽ_�oj���w�v��w�����S��h���t,T��U����q5t�� �������S�^ր����9��t�SY�d����Lo�;C���ˢZa�*	��4T�����[-�Q�W���D�&��59zJm��j�yҝ��Sdv�`%Ӎi�Za�JBz���}�N�.����J�KfEl�D�j4��B�y�qZ��X�)�(�"���a�YߤQ�8����܎Z�K95�3wzH7�9HZ<��}Zsw,���m�n_N+����,:L��`�$�ݤJ������!�O��ȃ~�˿���v�Z�	k�%8nM�/��&H0���\3[�74�q4�@����o7�׿��߫�"�!Q���娌o?Wk�0+�,a�)R$rx�����{u�X%@�	�����|u��x,���$ג�hڶ�4Q{��?�Cۥu���YY��)�;u��b��D�+)���P,xZ�$W�ʗZ�.�r?��:����݇�������UO2�� 8�nJ���NƷ�o^O�:��m� ����U�3�m��wQ`�Bwř������̘�5�1���y�$ �"e���:%^K<��V9$��_��S�y!���M�i���F���S�ɿE#� a#�o59���Х��Z	�rG��8�*|�6c
mx螩/�_��ǿ�{����W��$�~����A �H��= Q�@���&ov�~��`Ekm��=_�!,A�X���N������o.�N�;Pk��o�D<E=��0k��L���sü�2kc�(h�@�~v=�T3X	�ԭ�y��Z�Pb`�T�{1��N���'kכ27�N���]\���[3�B��>,�1O�MH%1a���)Q�������w��~������GZ����է����_�3��?.5O�������%�["]p�?�=�|�{������<�W��VA���(�X{���%L1����������)W=��7cCE��T��?��zJ��upSK\v7�z:�z�C )\���n�/�$s���o�KF2w]�Fop7I6Gd�]�Al�d��]E��֠��@��W*b�W����_Kr��f�29�*e���@~��|�|}u��tw{�i�����~��?w��&�w�bsT)x1��Z�L(�}�f�s|�R|A�����;/� �c�S�	9ٿ|������7v�տ?�r��+���͆s��
K��L_�0�$��Á2(�c񴎕��E*"'���OW�o����}�������n�����E��H��4<E%�'8ݡ���&������{XEp����Aϩ�iZ,T�G��T{�%e�>u�l��3�W	�x�4JH�B�9Y�a}I���@`�Q���DCxaa����6��q�y��!�ד�P=������~�k�4%���L:��|��3a�D���K=����c$��j�S���U��ꜞ�e�dS��}Vٳ�91��@m������r�* ��!�a�4]��M��6PȘ��x��g�ŀ�M$ 	?�<�4I�V�	�AAgυ��j3trA	@V���P�l=�Vr<�y�ɲ{=���mힽP���p2@�BS���æC�gB)j<^������n�{BE}�s��|D�sn�R$����x��8j�ғ����uG(�	1]����/����Y8���Lx�y�vc��    �ar��T�]��������Sd�������`/�}�v_�1D3��M���a擋��59�t��~jL�A�L@�Q@B!�t3�:�?���ݸ��
�"�t����
���s�s(3�fA�� ���G�=�Шc3e����I�	{��EFo�6/`�����R<ky $&�T�c�u���9���$4}�%��]��|�$闆>�+d�[GmS��=�I-�$`vS������-P.�@6Cu��k���EI���2]��$<���,�t����|�3x*̛��l�JF�҈�@�{za�.��xJ��Sӈ�9%J@�f�0��ni\� a���$�=��t:GE�v8Ǻ��tF�]�i�=|�t��x��Jנ��>T��n&n���]+۩9[�Ht�Ar�t�^�����(�q��
�W=/7kn R<��j)x�{��/W�w�*����r(@o�f������8�����=^E�H^�/����i,�x��	@Z�$>���S���ژN�PՇh�#�%!��~IRp8i��L"�XE�Og I���ˡ>��$#[M�
jA���H.�� �k�dI�	 P��^��K>�B��"�'򩡒;����߿�?���o�_ת���W�8%[[₪�,�7���	�s�S������t��D��l���FS��jt)9pŭJ�7���Xx�aV��r'q�����W�q�4��>�"�J'�K��(Y�k{и��T�}�$�RQ��W�K�t+��r�tYS��+J����F^
t��p/�D�c���(��1QK�[y뙋�G1���Oܐ����6�kb�D*�JN]��3Z���}��C�9�*a����9�`��Bt��Tا��v�<z��P�����!��O�Rw�% ��6��S��`�kP����}TZ�`1<��>�\���@�<��Z#�x8�������Y��"' i�þ�r��,�b>jv�a�AP����� ����~����|�W㨼�µ22(+>�F
먰TM�y�ߐ���0E�U�3Ԟ�'�0�����
m�H���8��/:�Z�@�������Ƿ�җk�ZK ����I�r1H-(f��r��r4�o~JiH��.q�C�Uh�k_����˯�U4�OA��Q"	�@�C<I���f��*FO΄�Ɗi��v���H�'�|LQ��n�c�蹶,nk�`���z���r�G�n�M���rG
ȏVK��r,��=�F�5,z>^r�$V�Xy�Փ��Y�#�����~0�㍗O���=��1gД��k.�z��I,��R���7�y�����qV���ρ�t!k �8V^� ��"����6�U��d���`eN��A8��nv]�<���f���O���Z�[E�/����6�7-4����_ρ� 	�j�Ҏ�kQYu�%Q'�F�o,΄E�DM��H�n}I�	����Zl�.A���������
�Xj�J�-�s��rNcvw�ؘ��ɬ�0X�H9�^>��aۥ�����g#Z-�G�s�����d(g�=H��J>l���V�R�E	ֱ�~�$X'��k2i4l��n�o�<�q{`�wK��z�����ǃ=\��tm��zt/r�G��@�I��J�T_\�ō�J7���D��[�~��:��ߙ-��(�L���^�'+����t`�
N�V:���Ǫ�<.X�dj�͸M�J'cy��!l�t4����x���`��JT��*����^	,_�6i�̃*|�����<X�i�ʚO��{E�Zu[�u8齐gU��U:.�6C��P�PәRj��I���'�HR�Ȫ�a!�p���4@�tV�S��&S�^:+���0~�II��Y�̐� �I��Y!���Ő�گ�Y%�)^Qf���gΊ'M��UG%�v=V�|�����l�)�V��h
���>����3��7���i���(@$G�\�Q��ȿ��w�~m�t��LM�F�:j1 �ǝK�����Z|?rx_pK#A�,���
n�T��K����@� ��ʹ�.�@�`�QӰF�3yò!�vNs@��(�u�F�a��!@�-�aX�9��M�K�V�9K�ܩ�9+��/*�Y�:L�7��?�s��� ���WG�9��FE-�Dv�.W�^eE��o����*�"�H�Ø��#Y�+�W_^��R���G�{��� ;������}V�:�v�n� �GW������?�ۛ�Qz��O���%��6h7�FV,���n�4._1�xL:2N����X���~�P���K <��۹U�3�r4Ż�{y%C��2sÜ���	sP��kk���s�,�vs-��D��(��̧'��Q�^��n��\�P��pk��Tr�2�9����hf��J(@�s����(}?��T����DVۿ.�@q���$�������Oq(7�:U$ I����4;G�b)�h%��x�.�f��k��`��ԛ���%������-V=&��d�:Y���K^GOR��exI�ԙ����F�Kw@z�4$�<��t&Ԩ��\�7.]˙h�L,�\T�P�JKOd���L��H�eY�)kb�(z��,�jȧ�����nbʪH6�^:�z�H�yNp���t}���2o���A	��Y%}�`��%�
��5K��,%##O9���S�����a��ҹ=�b��&<!�cB���=�E��z�}6qlLJ��
L��KQ��@u�o�NP��B����=�	��8	�9;o8��jc ��ru��X��H�GV���҉�.�����hn��5ML��=~�t�xף
=��M�hH�>ݪ'*J$l.�F�()�:=6/��5�ם�c|�
�h�].YQbu\�l�u��]6��?�n�n��uۡ{zWWT��0E^w�����a����Q�� �G��ӝ�_�ϻ�_~{���S{b�t��Y�&�CH^�Y[`�������&���_˱ێ+��K��&���ݛ�_�L�W��J��0�e��z	I��6c1�b	9JE>!?�y<��k��	]kt���+)*(��VN���fڢ_�ٿ�L�43�)�5�.!1I$�'���w)��m�g�u���h� �3*D&Fͱ��X��jT�fT��6	v` �	��u�	� �V��B���|=�@z6����q��xQ���jw[^4U����/����9L����əZ_�	ΨZݨ�S��G���ta2� �w�.��
$b�v���(�(�N\_l�.�F�O���2���H�4�i� ��{��"�`�({
v�9��יִ=+c�uZ�㕀A�U��aQ���}�����`SMa빑�p��ĽZ��.ū���������O�_w�7�HS�:<9(a��-u�h�YcA���
�)�L���%��}�����������F���L����� G��������	�J,�����8)��j��Y��~}�[c���`G�g��
H��`����i��d:�w8�Y
!�~���O��_��mQ�	I��t)xaW��̠$M��RDP�8���Q����՗�������S�z!_6eO��/Jӵ��J�o�9�2�	}��$>����
���-C=N�<�,� �vj
��S���qyjV܃�@�T9�@�D���B�O��5��Nc�]�\�S�b��S����S�S�����W�2!O��O����y���~�IPBG���W3Fw%0Z�1,��U�s��rkF�,S��b_�Rp�e�b%��X��׷����>Nc�D�8'�Q�����Y7���~���o.'�z�u�c�J�Fx$3o�=z��BF�����$V��mX��c�Oc^��/:��R�Pj�I��s4��Y=}��a$	�L����g$
]��d�ĺ��9�U�ȺU�E�{h�����Ǒ����dLEc����Rʪ�4K�TE4�.��=$��c���@��9$�B-E������A�%�WMo{�Q9	�dU��Խ�A
�+cI�tUu'dǪ��|� �l��9=�C�MpH&�'e��M$�&�t���M��]~_�"�S-��T>x�dUsH    JM ��4�.�^l�HJ�,D���g$��CRj�y�k^��w��5B,���lJCB��G�' k�H&����v��&�?^�-�_��ӄ��C��A��Y$�"�m�RS�����U*Kwi~��k�%Vj ��g��"��	ڰ�l�"�M�z��n��ՄQ�u9P�����[b5�u��U��94�ߞ (�(��H��E����py#߾�+�2�`���J[��}��̈́�AQk��|��`�ޫ,n�e V���j?�xB�	����D/}�x_��՜Dy�t��1^|?�K���p�B�'OihN��=B�1���Φk�n�$o[U��P[-@pb��j7%䞀	8j0eJ ����gp��=[+p��T��O����|op�d�$�Z�t�# P[/�FZ^�bK���nX����$���i��N�{{�GQ��)�T�4+�l
����V�Q_4���@}3�X8�A�HqPUes���Y>�(��(�������U�7��Tp�����%�[�^){�]���*̪�.��.����>����?�n�_�)�Iw*����/6���3�˯�HX��� ~
+�WC��8B��J++J��B��k�������B�Ǻ��i	��D�&�9�la��u��A�`��=���s@��ʒA.̚,�A7�t�m�+��	Ձ�i8��	0��ZЦ�6o��_��q}���xiw����??]�>�H�?������=���_�űg�?��su�p�%D'�ꔱ=��"�=�0�#T�|^�E�*}������[��1I�̻n��wh{�����*.�
�ص���pQ������i8��"��u�Ngȁ^:J�u�ݸ�L~�t�H�&���cS�u��^���bS�� ��t��y���ǋv���*�襦�|��������#}�c��}���Q�0��a�Ȩ�F�(A�V����e'����U�txt��CMɔw0D��Q��lO�BXpǨ/��J �R�!J$k^��  ��MJ>�'� O�Ut'K����QO-�74���y�95\A.�O��d�zx�t�A�6)1�Z���[��	�G��(�9���ob�UP�7�S ��U0��{���æ9r"5-�S����A�N�3�Qg��A`�to��/6ķǎ�z�ˁ �K�����'y4{b��{p�ʦ-C��ʅ�1H �'����9��L�cM�k��@`/L�r�!���o׷����0�������������^�e)'��f���g3��YtkK-�=w��1��j��y=ȿ�ݾ���q�xs�����s�?�=��#�o�����E��T����Ө�*��w=�5J=	☊���0J�f��٥쳮8FI���8W���o|FIƯ��tMpEb�$�'�7��M�k��$ݧ�8Mi��t�͡%�.`ߋ��{�4ZR7h���tUsHN �G�I�+��sT���|JP�"E��+#Y�z.��r���2�Mm� �f&�(iI��4�*0�dUcH"E�`T�O km�dT�D�><�"SN�$�MI?]�m�?߮&|_o�dT�����u1�ɨ	I��Y�F�8��`8l�<��!�ԁ=���Rr�+�x�=es$�"㌁l*PLM=�������������ư�]�M��b�$���m���%��O?NJ'��UC�)å[#
$G���,P�����A^�W&1�*-�X֜����Hf�rٸhBU?�A.I�4 <V��|F�:= �ʪT-�(�ʪ$	ֲe�/�c	K��I���6/&e�H�%�XK)�"��B�m�h0� �s-O{طH�8E/dV��\�x���su�]E��B'�t�+�pH��_5�.>�>�{w������ݢHA��R����i+I�"�X�@�=����%_C�r���W�=�҈�D�*��l��4"���pn?>�ܖn�0���'wvD��A�iw�� H�<Řv���JT�{&�c	9htpgο���1L�s�wcy�Hq��C�XR蠠/����3���-�5C��q_<K���(��Z���xhd��ؽvc�ӸF;��'��48��g�Ѩ5���Kjd}���j�$�svƉkw�>a	��� ����|��w�-u�UH�=h�Ϝ�f��Kâ�J#��^!�Δ���i�»Vd�i�@�����ͥ�}l)헾?��T��`����%P���t*�bIz����$D�/,N$���՜O-j�#!�dw�)`� @� �c����;-v|n��̸\�cA���w�6�v<�����{�f���	�Z��9�"Ś���r����9Lt�f���YB�IN�4p���=w�{C+j����:W=�xɫ	I��6��1����Y�n�����[?^Z����%����X�������v�ﲯ'�@��H��m��6ѓ=���y�(p OArѽz�՗�J)P&��s�uP|&�9��H�Z�����X`�w�pYG}�͋Jp:X$�HQ�����{@'������1��~�-m!�xl�	J"��ؽ^PQ1kC�#����JS`��FB�t�|��=�__�����c6�rm{��h�R0��z�
�I��%S��������x9�>k���r �Y��uZ0�~"R��k�.�>Cȑ�+)�Կ���Qb�A 1������FT	��(�.���u?M�~&W�.f�h�Չ) ?�F�o[��C�~�֢�h%�v�D}�C��MP����o\� o�?e�W��w��E@����N��z0�ʻ�b�sW�K HI"k&OZ�^ABqT}�ͼqAss4&�1��.(%Qx�DD���JR����#
�]P��I>�R�'����f;_P��d]@�����P���%4,�ɼ((���9]����[�|i��X߮���+6�����%���{�%)�F
lq
%)�*�
*��<����o_LL�?[��Hq�l��i��W$u	ZR<��r�i�8��@w��ГAy�������N����1QBv GJh�Ԙ����&� �S��E>q'f%0K��ҟJ`�����Z�oYś�1�ɧ�AB�4��	�}��BS%?��)���^�T�3�0� ���[諺xP�>ڗ�v�
6� ��C�	p����^�X�������ک���X>�m|���y����N�O�v��+rn�$�����~�X�Xi{�j]�8�����wM��цmo0'��jl���;5�%c���6ۂ��_�qOAf�h7�? R;�1�k���CH���	×���釷_��^�C�e�$p�٦�[���u1(�ƭ���1�(��&��)Z5�gr���I�	I�G��,jIĖ�gkըR֐Lq:TT9W|wH*FGϗ�D�"�8���i�t9� �P�FZV�D�E�JFMh�}�"�[�v	ձ̟��d��aM�̓��W�~���B	�F8I�����reOQ[�D��7�1���P\%���ŕZ/A8�2MI��?��+KD6�P�U�i���w�ˤ<m�@<���q~9�$�@wӼy"	��|b]�ܦ(ٔJ���yr�bcH2՜y��rܪ�|�y�
��J��֐t������+���dɣ4��V{�V��$S�6UЫH�dI�T�Ut�YC��a�[�P�6��P*���4�r'��u� =��UM!�P+D�S�$�Ri������4�d�0�x(̠N2�a�>D,ǠN2(U���M�Xlɠ4��?M�-dɠ��S�cb'I�F��ʛ��j/��ifE�V{ɤ�;~na���ߟ�E��2�/�^�i�>�6t:@V^ɧ��M����|F��H>���X�:"-iɧ��(���C�i� ���B�?����q�؇-"9���M�]4��E�*r�>I>����d�m�s:b��7ք~�!"	�W	HH�k�[e��	�Y�G6��5��o���	�Z�ǒ�&gYx�I�����\ I�����f���o��x���Y$�"RFƺ>4��E�-r+�����r�dL������U��,���F̳�>�x6P�h�,��V�T�(�˵�*��=��Y�&    &Ǒ���x��-�DDS4��V� �	ل��́	R�J,�"�.�@���
�H��B���\�$��r��S�=Z{�Q"���TO6�U*a�3F�-0�U�z�V10w��[d$�)�w0k��"kH�*!Ye��K�$J:�)�����!Y�������y�s"y�ާ�Yi"��L��P����A$����t��n������\�-e�Hm�,Ù�ВK�
~-�F����t�)�[�G���%�jϏ��AJ	wY��)ׁP��Ʊ�)22\����%2"T�LUS-�"#�@������YB2(�2@��l�x[���D�x�%���t�r{S�g��Ce}�����b$�&(4��y}X�b${
W������`�� m�:K��ª��H�$�.�Cl�dP��^|���<���I�����F�E�)8����}�3ϋ�R �ۧ������H:�}X٥p?�5�V�g7�AiYe�}�W�� ��57
HbRe�*�*jI����J$��C�k�@O�k_���M��� �2ӣr}XV%X�K�t���fQ�H������P�,�fI�#�[��=[�*�f�T%���Q$�&$��P�}y���e��k%�Z~� �^4���J��@�(�Ū�-#���@C:G<䭄?��l�	4�[_���ZI����`��A��k3���'ij>)�yamF��I+[R��ڌV��	�A�o���^��ڌn#+����.�H�E��J���XX��J#-b�bW�yU��Մ!]1x�]�M��N����K�JZEK
�.���|K%N��!���DC/\�����Q�M�z;%�c��WZhI���V��6��*HX���XQ��22�cH�	��-5&q��V �$�u�M�t�Z-+��i�	buO&Z�w�
7�&��s���ʕ\1���g-�br)V4�zp��RvCD$D�gF��@�t��w1q�v zI��l�R������u�d�v��K�����jS:�m#F��{>T}��C�'/��k���r8$�LT���do4�z�N���+0�J����K&G-f�+��  N		�5���\�0XU����c����P��e��N�@LZ���� )��v���q:U-W|�B�1z]Cne����>HNM`MQsHچZ��y�/IΠ��e_Q����!�!�aeowA�3�2 V5�$f ����a.��h��_��A����i�()�*�z��!Qr��t����	��Mitx�H����$�O���'9�Um")�V�P�4�FI����r�%���Nc�j�(9ղ'(<���Rk�<�}�W:�(�"uMQ:��2(�h��M:�Fƶ�, =�>v|4�>��$9�|�u	�ri�*_���/��X�zE^�˾Ɗ�ڔ�Gщ���Bl-hV5��A���S�P�E#^��t��JgXV���`�]gJ�'��,LWwǧW@Y�Z2�a--��ђT=�W���ђV�U��[e��I2Ze	:�X�$�F���W�([��:�V.wMsK�
VԒbAq��c�
VԒd�ճU��
F2��;M������&9n#�g�����V H$>�tG�,�i-���G��c��p�]���̪nV%��(t�z��Z������D���^��Lk�~1Ȗ'����F񇻇۟���Y�݉54�e�.��%��MZ��t���R�F������)���j�H��|Q�y7c�)�,�,���fS"Y���qYӯ�m*��`"�L�]I�}����]��co>�?�;����\ϱ��7L��C��O���H�M�ӆVg&o�=$Y���!U���$�"��U�>۽y�K�ǟw��5X=�X�v$���"tTA�`$�"�����X$S�,ps��;�����ۻ���<��XB����)]{@���#BF�@�"�
��,B����Vb{��)���2V�v��ܾ���m�ge?�ֵ���niӒpA�Z�s���|��<~%[��P}D�%|����{�S;-�B�	u�gm�iE� %vvP�m�M��|�����}�ɯ������ر�������_�O�d�?=�n��!�i�a�����vg�j;�7&��/_~�q"��ٗ�h�O�M��=��2�D?A~?�;H�����1�~��L(�W�3�A�����ݛ��ۢIP�ˎi�B\qA��:r�� ?#�� �r,�����#�W�fA��K����	��o��-�����_}���0��������W���o��Ǐj��s�`���r���C@�--*�^��#+������0��*%1*�醌��8$�����~��7/�%���b(�K5���'�T|��^x�k^�Q�1	`�C�g�� t��)��eFNل���h&����qnV���Tӟ��+^��[|_�/�9�z��^XsO:ɞHh�;�(q�)�X"!j���$oZ�,FXJ���B2fB`Cg�><YV�1��(-g�z���sT�D��FNҪ���ɄFg�K*%��g�o5�%�Z�'k��V���K]�B����_���nw��|�ýk��l�>y�Io���{6]D/���Gq���<m0�K��%jp��6�%s#PX��`����k��!��������� ]� \��sZ�5���邭���K�>�i�&-�}��3:-t����wj�
��l��j46��i)u���[3��[P�L�#�g.���M�J�H%��-���o�#_�"�	uE�����g�	$`��k���ᴖm�~�B�F�����L|��{�{{�|�w����ޔ=�/��iI[�ʺ�'�O�*Jn��O{/S_p*ۻ���X)W���~�����������**�1J~š�T�|F
�gdJ�i:�+7+@/b��x8�m#$���`Hή�T����sE�S�z��qQ� ��N�ܿ����\ʞպ��ů�5�p�B�ן��7�q�[��:r��W� ��\;0�t���3)ګΆ��h�>݃�X�#|մ�q���6���q���0�E����f�ѹ�n7.sc��ȿA�PX�)�Ȕ�g�_�(�$-������rjJ�����m�88$V>s 5�6�5
���]�$��D�٪6̥�IWZ t��N@�|��_~��͋�K�eh_����̊���$�v�20�4T�������7����?����%�F�}&��v�I��V B���A7�F�}N��f�֯4~F�g�"�i'q8�	 햞5��&��8�������o���=P<r�����~7}H�Ɠ���s~E�?���\����������IX�� G�W;���D9V��!�Gr�����O��(���aȉ��0Z��M;���W�Hܚ�v��խ �#�Ѱ3F��Z,0�#cal����`�;%nÍLM��n<uNB �K�K|�ki�4r$���8ʲ�U�C�'�J�nc���~���L��������L���AYs>@ZMe�����{��+K�<�a.��@>��; �\��]�,n���jo�+$9�X����0���ݼ�ۏ�����db�~�C�E��?��Vk�װy�R�b-�{�x�Lmʁ$YҸ��S[;�)�f�$3��fӞ=)�j���4kN��lk=�����,?�Yɴ�_X�,XXu2$����:1]:$�Z.f�Ǎ��:�qk�d��XqH��ِԊ��2]��dq����+�Jb����T	��̔HZ�k�����]g�?���r"�?	v�Ǧ�(���iu<`��٘cR�Z�� ���X���}�e�����:�@�N�}/h�Fb�\�y�U��	��Lp8a�^+ ��r�����n_=6��+�)�]���o��N� ���� ��{��9�9�Ć3K�k�	�G���Xm�qD��Sf��ϫ�-'��m�\"�9"pZ`5T8�Yc7��H����������E�i�dq��<cH�So�4t��S
�*F�V�1ۼ8;i%���F--|;�As�F 5�c�f�o'mC<�ٍw����> ���!Ϻ���K�G��aP�l����)�se�"g�4�H� � �V�g9o%DM�<b�v�Σa�߳C�    x�@�w7ҋ���q�{	Ѳn�����r!�X}��>�H�a
�6��A	�+�Q^�S��$]�3����E��yYx�?s����Ͼy�f@��I0��A�`PT���d�������@`�e��)��?@3ۥ4^��JgV\�n��R�~&p����q-#c����������E)q2�e�ˉ�q-�	�(�<�vjRʑ|fR����+DSZ�g�=�@�\�@�e�w����zA�4!r}>�
Y�����v�\�z\�8-�Ǹ��Q�oGS2�aC.�MjA�l��{(,����[d\�؃p\,7���z�0O���T�u�=�������PL��#m���c�K��X"�0)]�<� �g&�Ӂ��k!�ӟ�j��)�R�xN0��n����Qǐ<��\
�E/���`q�������LA���M�M���)�cŷ)�	;k�|����WJ`!�4jq�B��4^i�u�i�k��z^��ccʛ����u֗I���{n>u&�����~C.�~q�u�++Ф-J��K<��b���@ǳ��B9 .��:�s%rb@V���А�,Q�fm{�%|C���E�jXRu)�*�H����uNY��E��?��z�ќ�xW	����*���%��mCS��ZK �\>�����^ui��}|�O.�����"x�.����rWL���e���T��ZZ*��|ָ�S��K���غ.gg��48�z�'�$�s�n]9Σ�u^K{��A��%�<�y�Ei���0 ���q����F��i �F���9Y�4h8}jf{�(�W�ۊ����-��c�P*��y��荴���*�
�၊�;��&Y�̘ڢ��8>3!��1�h.�'u�($���9%V��\�&�闩G<�k�=Z����\^�x�uٌ�q����Ɓ{	ܒ�H'��ۇ�����v��g��Vb�  qfӡgOC���$���f	��-;��`%�z���Q*���[.S�V��ɿ��ӕ-���F 	��I&��NHZׁ������t� �1��o< ���&dC]���Y�MĘ~kܻ���ǐ�>�$cc��1�I<� �7}�:��ʗȒ8���n��1}���:�l%�$EU��ſ�m������M�>E]���g�J�6����Q�J��_9�_�e+u)O�J� �o��QXu�%���wv��}�\�DY��`��5��U��T���M��v$aN?JM��PYhM��&"-�n�}(�H@}R�zJ�7P�[�yPZ�����^����R����h:۴5��.ff#��g�c��Ǜ�ޔq���N�@�3Q�ӛ5��^t���NȌKd��A i?��=�/���O�(�M_�n����5i���=]�W�w��Ѳ��=��p��K�)N�x��x������[_iL-wE[%|~Q�Җ��Y�Bs����3O��^㶗��҉�{���۽��~��.���U=v�4���:�N�Yǥw�q���7�9Ke	�<����eV�c�A��'��̬��l���W[8��'of��{��l78�v������&�R`\q�.���5y{qۓ�#��l����<�BC�w�>�}��k�vl�犙��69�f���(��f������P���]�K���j�40���v� Nz^Z�4�d�Ԑ;][�aӑX\��}���W꫚� MUK�u�!�n�7H�E]�|u�g���O��!����ٙ@ݗ��22��9� �ap?df�uPr�]CF�VX�#�â�R�q8-��q�Nn�1��1A�b�ٽ8
�@��tô"{�J�D��C��Nk�{�t�Jخ-�Vqh���hP��aZ�M=�{��M+�{ ��n3�F�znB�)�1Lr���MK�i�����U�z���D�d`x����i���P��tPӐ�~���ʪyDZm鎫��-��+�H���G�������Lb;=�&�C�L���lCP�6�@���4[ �ӞJ2���s7�7�I���
�禙������nP�.����O*C���&�'<U��$~�詎D�/!�Y�P�*q%���=�ʹ�hu+uzՋlUP�H�Q(2\W�S��WS%M
 ��,w<�5;��pw�|������M|���gxK�J~�N��­m1�c�������㴳³w����Մ���l�S��M�����:ӫ({үZ�0�mT�3��JE��Hp2oʹv�n��XQ?��+B{���5��6:{N�h�F�{Zc���b�A�'�/�Ф�.B��0-0'�����E�L����7�W�,nx�dLk�	��0kNʴ$�Ǒ�g��.����7%�^� L+�X(������澻��	v��0�RqСkx�E�7c��T�s,j�-mYj���B��b ^	,�<��;+ZS��Y��n�Е;�e<Sfu�Ģ�R� ���JZ�����le��Q��P8��r���(�@A
[���[�0򅜕[����7D1b��\~�$��J��Q�Kk���'����,�� �褎k�����@�K;�dkf�K$\f�W8@�p��r�t�%Yy2���	be�i���X~dV�z˸���B�;Uk2-͸$�a�f��q��j�PlZM����o�D97���(���n�s��q�sd�q��`����z]�jєX��J���������EO¿}�`�����ÿ'2�F����^��w��b�l' @�63�O��G�r�׺@v*X/�$_Ŧ��X%��㢭��-	I3N�Pd�d��C�6J䁕��t�O���;&�x.t)��Qh�p�v��B%"Sh"de��%4�Ɵ��<wF�����U�$�N�>%�0�.��O����nߗ|}~�$���|��wr�]�eFI����1u|�|+K��-\8�����(����ׁ�r���7��m���CS�F�T�&���I��CP!���V���{�{|��"����$ד���`�Ilk.�����Q]t�a�?e �i�\[�����+����ŗП���1����
%bm�Q�ȹ77l�OaϜ�h��,�� -��_���nw��|������C$m��y<Oꪹ(s����G�U ���h8>�G�@H:��s��
��V�3����y6^��œ�p�&�K��iظ�ԛ���D���P�"zn6�豨��ɝ{���v�K5={�8���3������0�`vV�Bi<HM6�uK�4^Cr��:=��3��0Li:ح� ����{5�#H�A��(�t���E8;H#C=�k0P̬���ݛ�w\���xiEWWD<�I�w�惤vU�[�^i/��I^+��/���:�%�Io�_�� ��5U�� �HC���f�A�(Ol]���М���.՜#Di��_�ѯ�xY�� ��QO�,��G�����Շ�(Mp�;3Q�ZuΤE��dl�L�?J��e���(5J����zŎҎY�Y�v��Z���n�E����E�T��QI��w �D�������f�&�o����F#б3a+t�4"�R��2��K��JZK	d��qM��40�\b.��s+��}Ô����Т�f9G<�"�VYG��7!�ޕk�Z���#}���c��ki(�ҕU�'��%�#~�����VXWK��\�'��+`;-��@�:ko�b�S��vP�ta��ߪy�QO�?Pnқ�
w[Յ]m�v6p��J��\C�cH�$���g��2H4ܡ��&ͭ:-1B,,��sgĨH�=��y)�ã�0zA�d����a�����#՞��(����R\@�ެ�M4V`�����[�*ɛ����i�:~�8.1�XQ�����h�6��-�)M�h��Y���}�6���
ܬS��^ǼG9��aRf)^�X@�c!y:pW8-�Ȅh�gL>jna{g@b훠��`�7�j$ϱ�ʚ�P=o��=�b,ܥ�P%=��5=3Q��0�s��_�J���<g��E��^NS�k4CҤR=,;�p�YiR�3�lX^���k�A ��׮oV�A$-L`����4�@R��k�4�@�V]�ʓ+    .�AR�!���`J4"N�CZl*s&��\���q8�\1r���_�3cc�^��s#ь8-�'�:n*J+MBߧ�"�\/���������������k��L�-�(-�!�Ӛ���I��ͧD5�T�����l�:��$=Va3���P-%u��6�` 'y`Z�Ob�f/wp}c�r,\���ͼ�XP���������ɱP󒎺�^�X�Ѕ[C���E��X,=���=�.2���%���B�J&�X��F]�yq�j�'�^t�}���ej�K	؎:�^�X@�Œ}�����{|��v�?||�{�+�<*�H~�r�8k�Q����O

%(���k�b�"���XH�s�*UT��S��i�Y�R�VGr$5��I7]���(����j���q�kv�-�w{iyA�j8�8PB�oӿ���
��f�t�ґ�VH;z��k�V/m��,�+]i�4cyո��E�"M��~��q,�jj�ŝZښo/�f��έ�fjʣٶ^V��$��i|PN�k�iM��&��l~
���U!t\���e�KKi�q����r�v�p�_��ֽ� ��~�]T�4�$�̆R��
7�<�X�I�lyf�X�������q��}1ǆ�Gi� �*0�M\�&��/B����Di�(�Bu�b�W���n�e�xw����O�M���7��?|�������IC�@�:�})$r����;C�?j�I5z�V��OW�Fi���"#pA}jɵf�L5J�f�p0�����&�Z$��S����!/\��&�H^ 8�=��!+S�05B�WٞHI�-5��~L��}�qZqK��/��!0Ҭ�VBb&H���ea�V�}	�Þ��4i��o�����P�")��<��%һ�<�k��@��t�Ҧ��;��ب�K��������g#H�u�7��U{�f�x�KX�����Y��- 1ꡕxc=�#�+�SI�ς��:�K�N�5d��'BK�6��FSg�4J�J��H�o[U{Nii�s�]�ۂ����*�o߿��(}���������'������k��!��Z�a�;�LiM��������Ҍ�ﳃ�-����nfv�6�����8J���A2�̋�/ż����:N���]�O��e�.n��S؉��h'#�0�Z��k�f����>�[��?ӡ�`�	�R[#mҚ���b���P�u�P���94�.J �xP�˶D^�`��М��9�(d�����U���X�|�	�{�o�-wN̑P�R��@������ճK�ҟ9�lt�1g�%��gǐ����~���(���;8�7{�������s�䀄�[.�U�bO��Hڇnİ_������(���U�M � �_�g��9ʢ���b��/+�%���X��B���,�LS��3[80\��i�S0�)����kc��~q@57���/��,&��|V����7�OK|�-��F��u[����/8#ڴ�� uH�e�M���
�y�0eer�(��d�3(g'	��<�&��K�Oة�:���&#O��޼z���-�tejM���^ކ4�Z�^eϱ�5��贖��(��=����Z|��J+�i�kS H{}�
�PwFAl]>Z0�Y�i0F��RM�l0�u�j��~�d�ą�l	��й��:_��V��1Gɧ�U�ٖ�<���tP�f���?ܽ~{���Û5"���P?�^�l��+�A���	�J�|~�MV+��S�j	��f�:��l�u��Ice=���L~f�7'��7	�.O8�-�I;c�'�P�7��HA	|�ޙqÉ&"	�D�L�tȪ�!�>a���_=>$wS+��\�u�)�T��:Km������7m�dbd��3(�N��U�b"��۹3�%�"���cYsJ�$�t�lk�T	�s ����Rz߷yp���1!U�($�&D�O���'៼Ax+G²-Zv�\u{a��D&��ł�<3[�x3̥,y7���^��ˏ_��p�����[�� �����ԓ���e����`�cT�!�J�ˋF�݊AK(H-~����F����jB��L�l�'9�_�:f!3�����1�L�$m��C#�/��॥���O�"9�Ws�&k#Y�^�\�q��� ��7��A�,�e��qK�O�-����(�>�H�ޛ����0J��H������.d�,��a�:niHJ)��Y˸A�6��gгw�+a̬B��Q��&f怟\-�'<Fi���6���A���E�qC�A �)��!��U�ZIB�Iɐ��<Υ��!ɞE����J�òvn ���6�P'�Θm�5����3��;��[)�-�~+dgmE;���S�Y	:�����Jڨ��lp��Mq�p6���&a��V[�=��&�����no�47 ��GQ�m��&�N�g��͍�����d��k-�GB1�	�z�k�'h����F���c����3e���)����FK�}�������ݾzl�0��4	��.��[evh-�e#
��oo^|��&�H;`Y6����_e�I<�����j�Hb��;�z97���L>m$�[��A�b1��QF�E�X����Q��-�v�,}�H"z*I�\E5�6��)�L�!W��r����H�&i�ؙg��Y������n��F<*��4S�(�]�q<���qH�`���t{�� �=i#�;!����/���X4H�F��T,J����H�':�P��<�X$�"I_�_i�� �9ƷK�� y7AH������5H�������^H���@j��į�4�rk��%��2.�d��U4m2��6�g.tk���xԓmÅl~�>��r�F^~��ݏ/�.H<g{،R����A�����RRq(�w|��{�}��(����?��/�T��$�S�՜���ہ�9Dj�=}Q\�Q�V����F���c����0��\h�0M�i{ iCk�6ZO+i	wz�h���K���T��X2FaH���{k�i�l�죋?������޼���qf~���$�vx�#,7c,��i�*������ɯ96�����_��هǻ��}x�{{���î�P��aF���w�)��N3Jv����k�Yq�$�r�ko��,%�:��TQ��YJ��&�i7��]�W��tC9
k�us�{I(���Ӟ,'٘�Zr�|;�i�db�˯�j�-��I*֖�Y��B������HB&u����Cz�H�g�6�����/��N2�v$����2���2*�����,�J�]���=M*s��-�?I'��ˈ��k�>�f�8F���2�����h^����UN<�\%͸?]�U+~�%���a=��<ݼ~�|������>������Ϙ;���	�Lʆ��°�O��XҪ�^Z
�.����v� ݨ��K�'8�G�̃`�4�؋�V��dO`�A�b�"Q��NW��5�d�w�պ5I�Ծֳ�n�{��l� �+�s�4P$YCޠ|�HU�,� :K/F��LE�Ǭw���tqJ.?ޅ�2R�$pZ�B�Ɏb�nh�b���g�|uȘ�Q}-�ؤ�y;��d�m˓�1�Rм�Adf�UE��Pչi�妭8�6HcC�������~��
8�2��۝�(-h~A�:pi	��}�F[��F�B��I֢���t�~/\[<+J���!�I;�Uo~QH�;*�n֒IGi���/�����(�W�H�2bv�W�hbf�����cFe&%R��^)�]"�Q�FX�Z�[Њ�b��{�-W�����5��ԐZ�N�F��r�31�������n�ZnDM(��o�=\���N�kZjDQ(��кya�iMz�堰�:M��//�)�P
`.qO�HuѹD���o,ZQ;{je�I�
��G���iG�0㥙q�����t&9=�χ�X	H�q���t��>������bY�C+�)͌kA�� ���р���ƫ��G��J�U��h<���yl�L��m�*G��Ѡ��Z���AqY�r/b\�H�(���i�r0���!�H�Z}��4��JL�����k�6u�iI�b�+���;
&�dz�1�jZ��+Ҍ    ?r��\��f.�F��ŘC���kd�ˑ��u�̬���P�0�[&$�����В�]��ه�����~��c�6ݫ���ﻷ�����yN�d}�O��`^c��*~�+��*G7^ŐcJ��6<K�����=��=�m3=S��*a;e�P��p*:_sǮ�����gX��.K�)ϟ�#�#��@�`�\��V���Hw���C������3`�t��;(%����zhH��L��}r�F�!`8����r9.^S�����	OO�+��v&�6�a�����l]]ea�r�v%��9�f���3���h3vT�iM���3kS�!ò�î���p!I�b�����X���k,�L�YY���Q�'/�V��AV�Ps��F��LQ��if��&�L2��t�JP�vF$'�DߒPұ	���������;��u����g.'��|�_�K�H�Ԇ;b�CZ�Ԣ�g[�	�犎�:J
7,{`��+֚
%��B����4�Y��)��(M�͸�(i��]m�s�fՅ�$ܝå+IC&��]V�M��A�ɔ�:��SΟ
��	
u�.�UY������L�^��P_�X����M�7~�M�ٺ��;��(HG�m�K�>����.9+0P�$�(�om���8X�k��ޕ�����n^|]V';�]O�lk�����X{��?�~ٽݽ}W�e��������۟���Y��:�K{O3bČ���z�ɛ���5�E�2n���4���d�Z��m\����+�~�	>�F'׫��麯z��?5�^� v^�:�)8W�w)�c���	H�NA��n ?o��x|�n�{�{�&-]��ڏ_˪W�
D��."���/~LnAYڭ��LB���IգD�&xȺ�#9��Q���w9r��9,{�+�����9�.�vv�u��n,sc�c g�yס<N��rc:��n:�+.c��n(_���<۽���ϻǇݫ����/c�s�5H�7��uJ?��ݽ��Q����x��%�+��o:HZ~�n�b�L8�I�TOa9�����ٔ���4� MD��h}�8Ug��X��� Gw⴬y��5�:�4�x�į�oiz���V!H� ��;���A<5I��Њg?�����Q=��>!m��/�R�9=�'0J�`Y�t�ܱ�b��(kn�Q ���&+{i����.�0QZG��XG���f(�4#�R��5�ʖB�J�R]y���RHSd���2�h�0c�F�rF���9�7��YVq��u���l�#bǽr�����6y�ԥ��ɫ��S*�G��7��)��2KI��G����� �k�V��&B�4ğ6d����qP���^t�@-(��h�:�3��U��$����U����-$����r�� (ITP�:�k a-I��\��
����?��&�-���/b��.-�-�7a�wxn�E�o~ݤ��%�
/,�qd�u�v��'ެMV:cl*�H��H�����*������	�q�R6�c�Ў����i�i�6#-���ڥq��r��!"Z�V��A�֍��C끥��e"
}�w��<�޾��v�S:���>�%��� 4�8����8B�jM�>{�G��Z�L$��~�����dP��6�:�E:�6��������4��&S�U��na���dr�L�@�w�q�rSHv�G��s|Z����>����4��7�n)��:��$�T��4r�Ԋ�����!	��fI����RM�G�8�q�(�k3� �A!�������:���Z� j�ҙ��z#&GA7�u�,�O%>�2܊e	�p�(�{�_���7_�A9뼌�0�8L��p��R0��2.��C �L��ݸ�r������P��g�5d�~8{*BŚ.�i��D�D��q���rB��P2�ɺ��b3
��t.6<&6c�@<��l�V�Y��T�S�$#P*���m��)،[��~C3�����o�=+،�#��b�"n���-?��Fج��e��P�]�t�����6���L��1<�`֜��lY���R�𢊒�I�)��!۾�E����]a����_������d*��7�0rV�¢r@+p���v���qMG)��T��`�X�5n7S�T�d��	������v���� X|�2�W՞���,ͪ��
ОL��9��II��b����S3�B��F�]V�%�=8��U�DC��G���j�d��$RKi��O�d���߄���@�A�+Ό#�z��=Ήh9ic�-9���4����J3��A%�pm[C�5��9?]���Af���"�ܧ��>�R�S�ܚ���>3k���M�&r�fV+~�]��;�m��4[�5"\ב��jYv�>C���Gg�K�c9T|��S�xim��;&���Mxi>l `^��E){�~���j��E�2��՞��4	��f8�c�k0A�}&��m�L$ד���p8�-�	��p,(ͳ������~|������y���6҇'Q�)%�) �=�O�
%*���ݓ�r��!��dъ0e�8�S���~փ$�N�T���$#]�'�g!J\�4��	��5-N���I��AF3W����g�RQℛ)ǔ"����ĩ B�c�i���>7�����GG��bE�q�(�p�r��eVt�:06zZ�>�>�Q��j����C���,F����m��k��TW.Am�%����ܛ�
���ݼ���el�̹+VI^~�փ�sS(�6�+��Ǎ���C$�$C���>�,�nI���w��א;��4�\7j�Y���"��
?,��z�lH&����0-�T��2�ݗ�=�_�~ߕ&`�}D��K��=%T�b"����� ,�(�3��q�!<W�#����]��HM��ʳ���ް���P*��Kf�(�����@55T��S(���֪08�'�1�~h�Ly:�p9F���ؑ��YU
v\9�`�]9�a������|�x�����iN��Uh�@cYI�)�K��%�ɡEW"� L�� �l��*|�t���p�9}�v�&n��.@7:��BB��(�ka7Z�qa��Q ݺ�ӽ�I���p�{�;2����B���Pn�8N�mG�z+�X	��p�d�-VܗS�u���Y���X�$V�����˪��x���p��/u�l�&H�o+��Rn�ѿ�IuM��,��!;NMc���J���w��H��ry`�gs�N�Ѡ꜏O�g�h��
�sh���{[�3�4�N�6�����l��2��R*J�����:��E^��������=���pOiU�a!���ģ/tg&vL�ɼQ ��z�(��H��B��Z%�z�s�CKJ2
��V���[��Be�N�0�=N?�tE��n"`A�+���Z�]~��́p,�}0ע�bX(��)��N�4�r�'(��vj(��̴v�*�9�to\�gm�q�@��#��*����
c��vע���e��IA�5W� $�������m����HJsE���Z�,�l�n�>�(�p9�ޢ7}E�cI�9���a�]�s��IPq(����E~�U5��ʩ���-�F��@���]��W9N��>��,htq�t�B��楺ǵ")�K������C*Z��cM�r:$�"�ڛ솺;�I&E��wBi��c�$R�*�6n�j݄I�V���h�G�1������sg�+��^�R$m������j3����w��N�4�	�j`EGq����Ql��'b��$r($���9���|fkX��2�4G2k�y,4^�a�Ht��^�k<#NB�}��!i6!>G����ͷk�P��(�J̡�����''(�5M���䌫�g�R D��ܳ���5o��0R��ªD�>�O*˟\�%o��A�p�l5V�py�u�P��<�f�_���3/R���JZ׳��,�cS�]\t\��}�4 ��6��P���8a[VQ�q�����TۆΣ�`"%�c\���~>�h� �����jx���7/�Z���傮��&�N?�R�2%R-��XQ��LUǓ�l���<ɆTn{��1����n�~�} �   ��v�{����w�ͩ��_���O���o��`�O>�Ѥu��,�5Y���M���؀R݀�����o�ӷ���f�?x�����f���
F )��:��J���p�#���+N������Jv*%�y)��8��"��
`�yB�%vG�DԚ�
�*#��!b���R@��I�J��p�CZ���p��El��[|S��P9�ĒC�olq]��ݿ�ۿ�+�Wd      �   �  x����n7���O�=�r/��@�"@�"��C����3�J&7�q$�Z�w�3s��p{�~zf\,�������}�|���K�#���u�ǹT�A����>Om$JY�B{ ���DW���G�&��N���OsY-�ZT�EθF#�����۷��#�㵕}5-D!ʋ_x<�<y�?��ߣ�"��V�U��&!6e$֟"Z[E
s��[	����������梹���uG1�7#�G`6|��_���@Օ���x��_~�8{�*�F9g�<���F8^@�}�;>����an���_
?��)?}�ة70cپ����t��H��
~�t��>!e����J��`�Y�3������d�vΥ���Cs:OL�1�M��}bȍJU���)�g&�cf��I�ub���0�2.�K4����\\���\]Y���h�PԢ��P�aq1R�&�����5�m���n��#V~�d&V�"i�BLUh�*�Mp�`J۷�`�E,]�<;���vG�Ɋ��b֌��j��
��.��oa��a{+ڑƺ�0o��d1�%�H�3�b�^\��o�#֖��f���ױ�q���Ahr���o��v`Y�uQ�k�2�3�A�(�,�H���Q����f`��(p��j�Y��-��i��\��>s�&���U��!m��	[g�=��i¼�V�XX�JR�D����9T+os�Qkdmc¶+��X�W�ö	�g,?���9�:��
H[�xm�����9V�y6���F3�M��?�eYԼ�ٯ3��S���c;,۷M��K3@y�jB��h(ݤZ ��R�W�)h%��j��+�$��/"7Y�Z��}�H�q����/��.l9Հ���*�a�w��6�k�?��y�D޷>�@AbU��`��|��������aH3�k׸�	ٸ-���`C�3V�Ou�������嚈�W4��i�l&�8�̌d�D�؞"1�ȏ"
������8=�y�/"m�A�= �:�=�A���`�Y#v-���v
��w)`�s+G �YB&���DZʮ��"�+9HX2�m'1��	�C����������Ecr�)!�u�,�O�V�c�y�1���~���J8�q����O2j����h8,X�%�����']�R�m�ǩ�ָ?��Na޸�4���v �ޫ������+UL�ĩG�~�8k��������Ñ�v5������.��o�r�>��kW��6���o_�����r�k#      �   �  x���Mo�@�����,,�ZcS���{ٶF��6ӿ_4;����d>ޙ@(!�Q ������RJfO�Z��"19��Kx̎�XV|�S���|7I�m�H���c��T�NC�[`��b��W8��`�oڇ��4���-�Yc���@�pz�4��P����g���C"cW��v��tg,�r�F9��0.'DN������|���eU�N����kM��r[�<��2�77�����t�Ҟ�DG�5)70ޮ�H8��S��[3@����<�#X���6���i��P�f9u;wS���9����#��v}!������[�a��X����h6�";}�X(�M�qb����C�����a��Ƕ�Xdu���Pll�3����P,���B"��P:1M0ఔ��b�?�����Z]~�S,�dI���Xm�;^D�קH}1���>vQ�����W��)���<���j]      �      x��\�r9�}��
<M�E
w��M7�Զ.!�mwļ�%m�cYtP��x�~O&
(P%�2۳�,��d�J��d�|��ڬ������r>kf󣣷b~�w���J#!�׭�~:I�685�j$@���TJ������t��>÷6���Pi�4���x�����L�֍���
����T�t�V�nj�H�B��3������>N�c��Z��ʌ�Jk�b���z��t�s��HݹVk5��Ӻ6(3��H�B�/�V�l;�b+��?èV�@ɐ[B��Ux�qJ+��z��Ó<��O^Ph�Q��e�l��ک�����SGB�U�y�m�Y����˻����vy�X'��˅���f�vs��i���#=3L��w:��h�Z�(���(�^�윁W>C�.F-TZ?�y_[�	�BȒ5U�m��.�l-�-���,�o��'����3|uȟQ�֏a~k����Mp�HB�?v��Z��Ə(��u�pW]$i�πqU��Z��
��������77�WzӉ���N{��>��Ξg�ɑVP��f;:��.��E�2&L��c�{9�n$TZ/��c�X������nc��u�Я�	nj�H��i�|��Z\�umt:�V�T~$TZ_1�u�;��l�[���J���w�����+��Xg;�(NM�9H�0��#
-4z�ޚ*� ������H�q$TZ_/��Ŭ��v�E���J���^���ދêM]H� Άl�FZhd��R*{��@rٲ�]4%�-��R�����es�����U��!��i�� vn��
.ؙi0#
-4r����yW;�v(��,K
5*��ش��T�]mt��+b�fdH�p��� gT%�ܱ�~�]�(HN���B���1Uʆ��S������/ю(��5�{Ȟ(�����CD)�z$TZ#L>���wШB�x`h�X�� �}	hċ�rL���*['K��Jk�	��P���gtH%]�+L��
#�Q��V�X���IkS��֢J7*�<h�/��ܩ��S(ZO#�3�N��>:k
-4rR��FJ����?'TZ/�::�F���>;���9�6�wC]!"�s��ĘYm-TZ��->� �=n�5y��]Ź����H+�V�Ӗ9E��esb��.�X���Q�a7`VĞs�������*�Ŭ	s�q�� ���
���N�%@��F���:_ȱ�mWZ	�F���\�V��wpD�������*��S����E�h��&�2��u#��44��j:;(�`�T ���sK���Cg�Gf	��'���@�L��Z$٘��&���o	P �,`[�L��(��*_>�*���l.�˻������������t�yx�m�p������x7G�B6��g�5TNd&o�Znq�( ���Q�K��� Jdd�	`-TZ߃v��f~"N:H���roon�X�3\�H���8�D;��W�L�%��<	�r �j.c��J�[��v�#�(ADA�;�7�"�wjo(��� ���Gn3�F�K����w�6�bK��~��������D�otD�F�;��Ԋ�+z�igF�6��R������w'}O�U0�8*��m'�pw���aL��	􁨸���eH����Z��p��*�A�v��M�v$TZ���{q|����"P����e�E�>�Q�-���g��r�C)�{�U�oH��b��[B����9i3ɧ�J�Bj��0�阏���Z������0x)�
�y��h�b��4��ˈDG`��m��<Y���H��y��� ��"�$����V�����D��t��>��rc��>u5�	P��"P��c�t����_~$TZ�B�rb��֡�1�>��݇�� ��5D,fvF�52�\�H����X[�I��(�x٩�H4J�Q�Dׂ�X*ˎ��D�3�T��΍�J� ��߻����p���b&.g� b`��_M;�(�"��mj
�6�I���>�JJ�A��H���" N'������&���B�C�Ho�!��u�(V2��R������sn-TZO���X�@	3� w����� �?e@�Μ�T�	(�
C�(��5CC09���W9��+c��H������0�j+x���<��+T�F���j�u�5�����d0[pK��^���H��apJ/�"�\�2�D"!�8� 6>�Q�c�f��C̾��c*�����i�?��� ������Bv�s�7� @��t�+����0*�-P�ESp��tg~^�_�R�Q�']΀���n��A���\�<R���� ���V-TZ[O�����BX���b��1�>shY�m�6�Ƒ@-4�@���Fɾ7�m�8��Pi������߮V���7�ū�w��rq�aƁ��I�9*dW�9L��4��5�+G�l%���A���p�������x�[�XX(ɓF+1��-�S�X:+�@3̀���xlc�g�B��Jq���fCq����Y�ss��y��rj��(�K�\��KW&W���>y�f�/z$TZO���������F��iX�#g���f�bX�smG�pCW�X�.�Pݍ��!�B��<Xr� �TJ��B��Y(?��B��Pt��� ,t���%�~$TZ[���6`�vi�
Ncr��$��Z<D��*X�*��'"�]��4�5#��z>���˻s�rWTrEu]?4�"
��FW��rmvw,LU:*������
B�!�/9W9�,��)����p[���r���貇�h�8 t<U��B��5�Ɇ�ڠ5gp��,%�2��q$�w��h��`Q���#�t#��Pi���l��ɛ=qr6?�<ۛ��?4<}ۙ����bf�j!�:��-��N\�C1�2׫(����ɚyЎ��?A%�z��*�o#�#�ɉ�4Vy�[���m}i�@��(�K�9&X����;�P��T�B��f�Ю�j�b�A�c/G���J�9�<��ofA��dbK����%�� ���w��rȇX#tuޏ(�YjT�x�y��獆����Pi}X�L���E�Q *A��F�%xh�p�afB��f��(k]	��w�����\�"Z�Y��=������*;���N�h��T|�:��j��*�O����K�-��Bֲ]p���"�ټw��Ӽ�	Ph]5w��-��"7��G?�p�H����������('@��|�����H��8L�{*ҁd�Q�+���f�m�H������%hA��O!��!Q�U^�Z�o;e/D�+Ǵ��,Sw*[6ڷ�J�h&[]w9�g�:>��H�'�FE�� �$D�Teh<�x7*�g�Y�X��)v55e�tҠ�Ί@���ĮW4�v"�%����b�	�V�vqyt4�q��ZM4@L(�~9�B)��-����PJ��Q74w4á��H�����@(�ti�e���Cx:����������2��r�mi�`W��=���J�4���� o��{y� m��WՆ�	V[Y�$�}��S�7
�J�#5���YK��&�h���F��ێ�������_���g��̎O2���$:��rs+޽?h��������E���(i����w3�����ԁ��o@�Z%տW!~'�[��v~�7����zU� �1�ax�"�����`�(	��U��D�Ǆ��?|�Ce�y�����~]��})fi�-
~^\_[���-d��&��d��N�O����!�%���F�u<����˫�m<����iX��&)�;�@�&�y�2C���:�7�~���{fۋX~G\�>}^l�4F߬2`q:��(Ac����4��	2vy��F��ڰæs$��7�o��8t)�]�t4V����ƅ�3���|�]������SjfxC��xW�A�M��3��D�y@��o�NΛ7��B�"�t0�PHu��,�7�
�*�@f�O/�Jߺ�����s�q
NC��7
��#����[([������p��|��M��px�KN&�M �  G;�4�m����g�>ݘ�Y�l"�z�RP�	K�������ǿ���|����,���O΁l����J+f{���	�Z:޼i41�/�;;�����"�>���c,�Ӄ|4��Ǎ8����~}��\݋���w�5�Gb@��w�g��'��������Ht�tA���YM5Ջ�B���q����w��lW���_92/WW�|=8�tjJ���1_(��tw�g�`����������~��aq�1�C�;ǇGb���(Z:�<�������F�����o�~�Y�{�onD�$1��pr�zH�|���r@Y8]�
���xlPs�J������7_}����Z>��?}�"��q����>�~ΝZCÏ.��>��W�My��t�']��G��R���_�,SF֖�p�{�dL�!��K~�.�7^��s��`y�Qr}s��O�[�s�n�P�nW�/�����oi�ވT��N��P�6�cT�|q�rl�9||��x�?ѻ��b����au��+���_�e�O��G�ur��I\��P(�r�8X|^\-7_P]>W�X�.��j���YN����|A"W��(����6�{/G̛��U��7'��3�?�U{q�x�,���Q�Y><,�'"��Z��M�ΰs�+m��r���T�������ϭ���_��7g ^�/'s�+q���'��ԭ�M��7�h�Ե��h�(���믻f-�����JL�G���� �
�.�����b����rj�1�'i(f��iC�m̗�=���$� ������cT�����R�0�Ab�C��U11Hn�,�NNCzQ�D���\�;x���+��~���,������,P�CG�L�h��7����[�{[>~�,.h�#F���ECg7����`�f�ϻ��.�<h��Ľ��_�q? 7�JY��+hqJ�4�U�6��_O����u�Bn�&�?r�@zEĚ>bi�H՚�GW.m�^`��f�^�M��(e�J*Ƚ�t=�@S@"]h��X��A����nd)���i6�.�s3/����YĢӅ�j����̟~��Ϧ�0ˍ����oq��$�~��9R1�Iʡ��s�sp&(�Dο���qq'6_>�l#����Č@����7��[B�d$�����i��lu��_��ث��tJ�}S�N߂D^�/.m����k���ű�&=l�o K[�b�����zKC�!_\ۥ�]��4Dձ��}�6]�������oS`O؟-��m��J<l֫�7��KL��5J�ۦQ/W$�_
����3ƍEbG��_�a�������z\fJ��R4�nx�c�E���4u��Ζ��C��������b?ցg�1�]Mam��������=/r|��b�>����/A��q�]�wF6 ֎:�]�`{�Q���c��GL����_R���tX�1�a�i�E����e+� 4�6V�	��ɜgT������&b�C��rI�o~5����rB��V��?������4��xu�+my�Eߥ���������A�8z
aƭ7�~�7�3��?9���J����d2���b�8�*ORh"�P�|q����5:8!���B[KU��͒������P���F���l�XVuȆί�C6�@֠Q��Tu\�F"	j��u�P���z�\�.�ׅ}�Ѧ����U��A��v�
>����&��yϖ��HJ�H��F0A7��.�h�f�pH3uv�H�ͦ��I�F�)0�l*�*x)�^P��6�J�k���Cv���?n蠥��@ߕ�Z[���	t�Җ���S);��m2D�hST>bS���x^��8tiIi�l��Q�+/勹���(հO���W�y�Nl�,:�X�\��ST��o�G��b��!�>�*��JF���f6�&*h��Q�Z���:��J맿M���y9J'      �   �  x���[o�:ǟ�O�/ pyd��n�4T��<U�\0!7H M��ӟ�%ĹР�2
������O�E,�`D��rl��֫�KZ���U%¾�@��}ö&�eY�e�p4�����,{�֬��ӷw��e�P<���C�
�#���M\_���V�[��b�� ���6���#:r� �0�d�P�R6۱�$�&.�L���EjtbO��*�w��c˗w%�:ٰ8�$m��[Q;�e#y�^����\���i1�3 ��<�.�iS]瞍u/����I"��=E(��nx6ƽtR���T���+�.�`i�?�F~`��s��(���G��k�L"*��B�¢��=6���������{�`�sS��=�S���r1����XW���m���~��mv��,��O%�~f�⽙�G3�>Ӣ���9(��yG ��sx��v
bg��E>�N��ۢ��,K7��넺�%g�?�9g�耆m���.��.=َ݆+ȧ	ߪ���a׏���P'\W�z�]�[��kլ�L"��3OO����x����"�m��Ü�ʣ�"J��
�� �B�N,�%�.��	U��}���*��o���`�Ƨ^*��(� GZ�0=j�L�*3/�Ģ1;Ye�G�ɯJ�_LEˋ�q���-��"
/�R�����9}��`���Z�S���N��NPL腎��4�ټ��0�>P�B+_Ʌ���O
�|$�u�` �CǾ$�{D*l�CA�&��y���GQ�KV�t�P�h6(����]6໖Z*�����k|;n��zR֦ݛ ֵ���I�[ ��K��Qqy,��(���۲;	@m(z�u��&҇�U.�P/Ŭ���}� ���}��y5�xX�N�dq�ck̶o� i��:��$L\��}��ix�-�&l�	!Y3�@ϫ+��%.g�!�A�x\u�k����n�����.��A�!�t�Oۊr��'M���N�~/Wp��=�v�@�s�������>��|xx�p^Ey      �      x��}ks�H��g̯����kUx�(�$D��vk�FLЖ�R[�<zlo���' A��$��c�{D R��aV���������~��q��C:z/���5�n��^��4�ǳ|SL��>�&�U�N��&���Fy�)�G�(�Βu�Z�S�v2��ܚ,Wi����_Y��}~�������������oo/�l���^��}����x���_�^\�~��/�D�w-��9q����^~#�����k������S^ӿ���#z�w�gy"�/�n�y������?�]~���^?l��n-��wIV�z���7�~�~_���{���*O~I։=�,��.>&if��4�ϓ�zP!7L�)!�%��z� ��U]����f��f�1}��Q�Γv��]������z{���u�����//�i*|C�pT#��?ݐމ+��I���q�/H�-$�HD�U$�zYL��x:Γ���Y��Ųzy��;'ԡ$�;��r�}y�
��G7�2
:���&�
>نOF���.R;O��$á��X�ɹE"����5o>-�\'�$���l��H�����:����G����?[������iU��=:��'�����϶�q�x�w�-��D���PTxv28�がd =�a����9��Xˡ�2
�rG��U'z�rsk8M&��h�{�G\����$�q����J�������T^� 3$9~�8q�C� Ss���H�e�R$�d�\Z��<Y��&A]��;H7�$k����:�X|D(����eRD'$��e�k�HVڍ��,]�I���!����yR�bxF"�N�w�����t���鎞�^gۣ7���?�a��!kXg9-�<.�dw�����ѣ�N>�-�	{�ګ������������6r�>���b_����E�V+�q����ؖ@	��(6���p3���H�G���=�pF��d�S���"��Vo
,'>�Rpu�4��m ׉�Nx��/�G_(I҆�(�WG6���,���x���m6]�t��1	%��${�ዽ�`����b{�}�ڒ�ۿ�6�BT	�#�!�\�� ���aj��"/��U��+���*6p
{A�3���-��C:KfI����ּ��9�U}��Vw�_���#=���g���7�������+�������_.o/﷏MӬ�a����1e��~	�l����O[�e��G����.O�z���*�ܽȈ�!�Ze@�6a��"^�w��v��!j�Bz�4���*�H +CR,�ߡH��v<�d�	B² #2%q^Np�_�#�;�t�  W9��?�~�2.�;� Z��B�͌ϹR�#�d��y��*�!�X�ZR�ҕC�6�N�z���iq���D�h�����!�߀���~����_��s
	���cyBm).�Y�)�ӔlEJ>5�xӥ��(^ɖ���h�J����Ow����~{�e�&�����J����B�~��0>q�A$B/�f ڧ��B���w� ���>�%3���gd{s��圎���dA%3��}��l:n���/��b�9"y�-���8[��N�K���W��i�$�In'ӡ�|���3��o3L� ����b�껝w�գ�N|w��Rt�!��>��G?N:j��
UΆ5��aC�HS���s��J��3;6?��{�&㠏Fp��9�CT;�����%��O\�	C�%�\�܈��Iq�C�r����8K8g=J'�q�ש��{<����6)���;�A����<���щ#�p]�;�i�Y����z2�|��+�\���ۨlb;Z~���������D3/CPƃ0��>���nN��n[��VQ��ub�L(�l6{Fn�2$�O�)pB�,�<Q��W�fI��p8[�T�A����SmA�8�T��q4"���( ��B����؉MI��e���'��r�Y��=�CLvj͓�x0Y�����=o����d4��>��xhg�$9nw�q�����sq Yp���������!P�D�3�(�@����N,"R�Ot��bK��5���\>�������u�;�S�L�}F]����}-�R�;d���^*�8��/I1$�H���� ����cr��
e(��x����k�T�����@��I�ۜ-[5��eZ�p�rڑ)�݆�#�y܃8��oY�-�Q_,cD}�FԷK�N���a�x�22CU4%��N�<5֞G�_M^x��	M)�^��?��K����Ko3pc�u�ƕ�=C�_��<���I��z���fB�H�X�W�U��,[�M>I��������>���++����B(�����1b�A6H�Q1#�2O��5N�"9���˛W�1$��������Z�J��^�=I���?���$�'�?��t�z}hH��}n:��׳tdϠ�`��tD��T=���~���_�����լ��G����J]�Q��Zε�;����ߞn�v�����Jn�ך�d�gtE���9���%2e "S����H9����4�g�?ǡp�J�e��S�02Ս&dVVe�XSwk�1�˻�~E��W�-m���⓰���l�B�qr@�����a��\��>E'�,���W{�����۫����~�++�vM��|r�[����l3�A_X:Y�w���F�E�#�7=0�7��D:�j1t=w���wzO'A��	_��9�@����ij��C�
�%�%�ox��{[��Z~����x4έ_��������z�v�jy��]�7Q�wY��l� �����r�l���߻��8&��q]�צcD��4���Q$��1_�>��%��Z�W�h���d�&7��U��k��,l|��6��%���wp�"��/q�.�-K��ݕ}t�S�z�8t4��0�WV��<�s�Q����~Bl\L��T�x�-������֬����9q�A�&yg��©�iB>'x�7�n�ϢP�m�;���Qu,�I>�b/������x���O�w�.�0c o�3a��qH�ؓ�����Ma"�W�8��{H�?/�-�t�4`Hc'���l��ݦ��J���|M��M�pJxe�пPu�%��VR�8� �\�ň�+F��v�8�fa�/���i�:�c}��k�"g!_n��XP���4��^�����W��R���d�JÀn�w�.�zj���7I�y'^|����a�9p��¬����6�� �\}�-�-�/�?�3�w�e�v��Ţ�nE~��V1�M������|3|u���u��*�ut��h����Ƒ𵰹��T1_季���fMx�X�Vq��폭�oo�������W�l{���"?W��O��S�"*kT,7yʎ�AB�qj��Z]�/�]IG�3�L���4�gA�`��P�/i]���#7h��<~���D~~z|�W_��;�O$�L���
�d=U�9a�j����ی/���r|A[�UH���Z�5�#�tl�A�zBߣ�k�?ջ��Q8�EpRg@�șU*w�'%����N�2#�X��[J��������?S���oⓎ��e/��h�`Sﶵ���
���ʽH��M���=�P�����ߤ���D�_I2��q��8_���/��p�	w�MH>F�s{��L�f��#;�FiY��,ف�t�a6*�~I�'�dl%���W�9�����bI�9$I�18�B�<g�7ġ�fym�B*(�g}H�}�Y�W�HU�HJ蔡74�HA�Z��6V6��t" $��~���^�!�|���Қ嶐�=mC��P��aa��ǿL��	�� 	�޽��9���	A��{���ȧ_c����:�����-4��������.�҃=��~��|��;���^|���Oً5���Ȉ%I�7�`��>'�t:E�� �zGǏ�D�:`�U�*�{he&[��]�����6)"�y2��<�j��՜� �N�`��Hm�)}�/.�qH*C�����f|����Rh\�0�-˽���c�������O�{qwEajoɧ��o��?��8��V�/���"�����p����U]'}� ��M������&�+P��s}zp��1ˑܞn��~$��皙x��p4�58    j�e\p��}�����(�"�8��k���QЊ|��N�]j��:�/��ʧ�P3�WJᑜc)����0�ѵ���ɼ�N�ª8��F�x�j��#�^U����T�-�,�hu��e��T���e|��~e|u����6O�p�H,P��XԱ�AQ�cQ����p���f��9��_���[r$Z=�p-Iա�j/�O����}���U߆��|�$U�6�V u���$��M�a��4�.;"X����O$���1�'���_���B��_�����]�]�Rjϣ)2hv`{m�$cEt��_������\�j���|�!��rq���qЍ�CT�@�f3
�_ۏt�	�si��#`chZb���.��~��)&��h��[_
�vĉ��U$�D���,���mD�PB�nA�4$�48��������γ
W}XFS���׿T�������obW���0tH`�����r�1:�Ηܢ�ڸ2�l2�8��r��5��-W�L�˱	��-�K98�Z�P�'�ŏ?�d~�MX�n޼��	�Ⲻ�Lq�pH�`Q<X�aQ�U9k��KO���>A�X��[�NQ�ZuO����V堩��ْ2��@�V^���1Lb�O��S���#q*Rr5��[�j����i|�f�$��> Z%9���/�IL�g+�'NdD����1�hv��fQ�.��O���j/&�Y��-T)�[*��m�}�	x�6YJZ	�3�#�h>��yZ?ã�����a���J|�x�`����I��~
�ZPz�@�P"��>`�cx7&Z�n�L[:#A���-�K�2�O��p.���1Z�	YL�5��qz:%��F��wu	 |CR�J>�K指�4jS�@�m������)$3w���Gz�:2��� �ve�"UQS��{S3\��ښ�`�Ӝpan�O����?��O��:��Voh�V��l��qp��t���0'�'������nDm������b���7���P����Յ���n������ID%�����Z^�wa�������q~�}��������S�(G�5�o�V�}�c�i{q]?1(�[k��l�eج)����ߔ��w�,Ѻ��c������c�G��ke��.�������7[u>�?�}��o�}������>�%�yA_�[z�~�{,KcL��}t::,/���˅4�YϞ������jwp�ݶe]'�����[��I�5�!fП]no�ry`�x;�I�3�\� ��$��T�D�3pe��1�L��	TgŔ��}�.p/�/��z�0N�5�R�ڼ�B�`|B�v�[VQ���D~ˈ�^H.�G��.w���VvM��v{{Q?9tU��٦@a���+R�\��v Ti;�2�+3p�n,g���G ���]a͓_�*OIGc���B��*me��~I�������``@�|�V��{�:��5S'd�{9|�J�!lq�c��@ZSR�0���{i9��O�_/��l��a�UB2��F���Q*3��Z�<6��}��t!:Fc� �轐Cn�C��X�\zcFCك2J�.����ي���i^f�ksJG%:����b�k����}�?�#QgO�=�ܨ�/���ȑ>�^�ca�o���|��&��3�g���b�Tjy�b�yb���5����/K���*u}{�x��P�6#�9:]F@��IC!jE�%���A����k)���:��\h��0�By��E��e5)��k�t����~�A�!
��A�c򗢊���C����Gv-D�0�U��G"�N8�I����^��!�@�סG�_���7�뒟��9����tM�ᡤ��R��8S���x�e�6�]��Z� ڮ�&L~R����"�8���n�f�෯-���8��B��0xزb�A���pՏ<�Q��}���Ӥblc��}K����f�Ϭ�w������c��W{5*l�s���]�#�uea�Dђ��<���4�zMWk����c]%���i5��7L�nv�jQ3�$C�V�j��K�4�#L	�^Z�u�/���t�\��૸J
S������[~y��/��k����)��f��t�ΐ�(���d�E�6����So�Y�k�iJ�.g8#�mv@X ��<�m�>:rO����D/hAz���Ӎ0��c�m����%}�i���qb�"6dk!i��p5�
��1��p3O��*'�����Θ0�z�q/Ј_ڂ�8m&��I�Q	�I�4ܱv�Oz���\�a��*"�<O�F��u������U�ޡ�;��y��i�n��	�t�;�	=�M���/5���5�TW/.,��/-b0��㬃��N��.EE����0'Y�������>�k�yv�����p��}/B��m&`�e�*��Dt�U���Lv�� ����Lj��D�ԯY�SF��d<ku�:2�s):���O��R���+������L�(��D��Z��CP+
w�yQo���M�����!�g��P�>>�E��m�������&��Dc��|��d�aw��7+�|������ {�4Q�lR���7<q|�)�������߷�>-�ǏC�Ǥۘk`
��d%�{�vJaH�CZ�g;IxPb5#ǲ����"i�KqDd����Ǝ�L��Gg�&�l� wW���j��|�\���2o���u<��@JW'�j���Ql �1Z��"y�^V��,��f�g����gA�Y��1I4)��(_u#��C�{��"��	HmV�S�	]P�!�o�z����ΠѮ1�"���E���!C7`�B��^���t@4�0�Փ2j��o[l;�� 1O_����r������ۋz*��Q����S�h�����z��r�67��+�@	nf����}��N���V>(�V�kC��~�3�D�Ig�8�H/��iFA�1֗�k�
�U@?
��P�6qUn~���O��a7�b���R�sɖ��aȕ}!����>���>B�j{�p�tO]?���@v���b�_�|�Rǫ惜�NR,y��EG��~-�)�:�#D@�X,�X	gS	�ͼ̪�:����Su����ɓ.���������@�C�{�������ߌ��ƛ�'KK���\�uΚ���~��?��r�q��XL�Bۭ:��Ø
�n3�7��#Wh%LG!@���87&J�w-^�'�q}/��tJ>&k6�#k�b3����p	�Ta�	Қ$��&�ӫ/0�?�XcF.`���t�o��=p��-��,�C�"�*T�M�Z3��rÁ]>�Ы^q��S������&���bl:ݡ!�[/��>�"�w��R�{�q����m���a��&�$�����lSҫ�;�ؼ~�RMr����JQ�%����%��5�b�)
cA��z���Hr�'�e[�I�'	9��������f��Qfo�@+"�c}ì䚁��lpG�j[��wd2Kk����S�邿Q�b��"�fH�_a�_(v�bQ��/��T�d2��H|.;�C���&:>��@�b��m�܎�n��3"a�ɰu�o�XZ��P���傻�`�����I�.��Ԩk��h(�1�2��lNW��zZ���QP��bz��H��<	>C��P���#�?�`߇j����s-�.��P���h&�u�+��t2�7k5J�+��F]��k�{O�9+�V �����A�N������s��0�D߃��S��l�ն�:D�	g��/|�`~c��i�tӄ0���4���ո�L�3��v0��W��?͎a���~³\�_�y*��p<pG~p���ϋ\8�!GE�`��������?+��Fv�~`;���b�~#ݧ#��y&�D�W�BJc�K���qI^V�Hʩ��$���x/��>�l���/���9%�m�
�#n>?����	=6��$��z:��������C�9RB��y"]���0gmrk�U[�qk��DG W�$��Y2�Rd�mu�v��XEQ%�|��k�>v����Q����i��S<G5����Y!F��<)���{�{Q�����l    �E�\C6U{^��a��@Ԫ]����
z�=�4ͮ��a�:���uw�&�ku�3��#��n� \=��a1Z�[�����~�Ɛ�"&O���̨�����zP�!�R�_ʁ�I2bN��B��>2�5�~�|g�C��)���x ��C�)-4͑��cg�D��.f^��Ş8��K�D�Fe˕���$:�ƞ�,ҵ]p���Q��Q7�@dMjs��|�n���̏8̍E)cǰ@��i�Z6G8�����)�L{�'��cu�>��bsm����0�-i=�ʧAl�Q��(8>��;M"	*�b�t�����G����۩TXE�i|�|�>�e>�M������1J��, �(�\��4��b<��	�,�����&��H�z����>]m߇����C�'@�I���uAon��oC��JDiű�-��i��Z���R'��P�i��!�'�����坩 ����{�z��N~v6H��c���li�������f�|9�G�2.	�]I�z@�h���j4��Z*�ۯW����x �n����i9[��F�>���I�$�|�����:27�c�6�2+�w
}.�n�ӭ���������P��\�f_� ��#P"������P�H��­E��J��ɫ�@%�g����c�fo������-1��:�o�]�TCE|�S�W��S�,���z=^���'V����Aʯ���2�@/����_V9��9B�~�Q94q58���"��Y�L=�}�W�л�8��%wt}Q����|]QO�4ڤ��h͊���!&��C���������E�`�</TW[_]\���ðoSP�5*��%�&�M������⚩�˂~}�z�{y���G�d|1�?;�tD��� ���ŋI0-)2���U��dw�J��ў�d2�
���A�R�H�,�6�R{��)�)+÷� N���&�%���2Q�B+ ��7��YFsP3�}�*��N,
��	���u탧��D�8�ˌgo��rkJ��/��A�7�Eo�X�)�<G���'Y!w��)H�1e`�'J�P\+��$�%2��c�g{2�tBKc�$W�Q'2��H�����&�_�]��Śm�,?�Ix�p��3bz���e��?�x5��v���Vᄼs��L9��e����4�찕kE6��U/)�?���|����p�*��M��g�V��9���_�k�*�_�H��G�O�oF���+�݁����t8qҦ.���.���\�<}$�g��.g|'hК���5��b���ޓ�Ki�ްj�J	��(���0�8V]j3�~+���G���,MLM��+F�����yt��-^_x�O���BYx^̸���i]x^�3�����]]���G20D��~�A
��?�4�PZS�����+��.�7��*��ճZ¯��ۯ�b5��c�lێ�#��0�I�=�<���2"w�L�z�(s���<̀k�Rn2o��2x� ���4Ipt'��t�W9c���h��d;:�my"I��:e��A�Q��V���.�8�ۑV,�bZ�+�ꉮ��>�EI���ztl�]��%�g�����0��H-�����LSK�)Z�ݚ�(�tz��p��D}�������-63���K��wA�ot�����+$_/�����F��H~���ډ��������G�4�^�!�fo~�����~�Q
��R�W#v��>l��D3sWw�O�r��#��gp4?||�����t��� ����\��������Mr��m��66G�.B��a�ĘQn���y�	T̈Y�8��s�X�\����f>V����Ec�b�CS�*00h��'�����裃w����j����c��Y��*�&�T~%����o7�Î��ʯoZ��_��Ό�^�v@V/�;3�z��t8?�znZ�_H	�L��4X�34@PP=Yn�O�^Q$r?W�f$U����y��$�F��_�]^L*����#DIͦ.����5��S�����AZ�L9������v��v�F�L���w��G������)NA!�|�ͯ����wS?yrFR���	���|<.�:�-犉��6���c ���A U>}��T�֋.�t�v��P��g��1�M�M��g��)�p5�s�����w1�gU����ad�7t19p�L�a�r�I��g8qh�b�%�8,H
�B�i:��I+���A	��r/K'9
̓ҡ��uhd��k�z�wͩ��9��@D��{"���D/L9C^�Q艾�csNK3�)���d�|���_0(4�M��&�����H��،^�!�dX�>�sp��z<�tZ�)ӄ�M瀧dEL�t�a�&W�~$��(C���Q�m	8Nww�<�+,����u�Z���'�y�����힞��+!����j�M�p�W-dc�t�4,U#��-S��rzY�7�[�"�O��4�p���Ô�S�f�
/Ż6�@TW6UA���Z�1��0��/2�C;���;{v���cE{<��~U�}w&��\0�J�k��8LC�I��b8$�g�VN�=�~�0�'����$���h�$иPP���i7� VD�&�ֆ�'R͛�w�,��+Q����sJ"��w"aX�i,��n��o�c'#:(��7�@i۫'^��h��[�=&�l�y���@���h�w@��h�).�op'���
�A��&9�<���~�]y�(�/k�O����'"rsD�e�?ͫ�z���v�@�e��)E�M>3�����`�"��u{�}P����g����=[��z"˥LI6������sw�����#�/�0����+�zL[��8V�[]j%\���(p-^�0i�b�愅�rFMN�R���꥛n��N�`f��7���-����9ޓylw�<����L�2/EO����N��cz8f�M�s%ІWb��d�;�f~�Q��eP�a�*�Ԑ�T�84�9��q��3��Y����&%��2O��(�H���ܞ&�w3n��0y�6�YrZ��6._�P�W��&�������l]^A���AGw)��6w���(��(����T�ۇ��н�"���s5��/���'�sA�TL�eX7��s�X���:���#$\���We8���p<���#Sa:�#�[7�a���X����*ǳ��1��&0o��6�^g��kRD��K�Ti�`�����e�� �i�WVf�0�Ѯ<}X#ډ R
��#-�� Գ.Df����K�0�ܳ�ل�]_&�*CkTh��fء�լ���V`+�4<ܼ*I�vϙ���������N�q;��;�1�����>v:M��vV��rM8~�I9����ؤM���@���p<'�;��m�B�-]oH2}����'��C��w��O��	`��s�8��S#������ ��ű��V�@��h�$S]�P_���3���ѹج`����ѡm����^�:r�ӹ��G�i@���j-��Ng\j���� \X����Ɋ�6��Y��J����>E�?qP����\;I��ō���雾=�m����^\>Z�;�,�/o��,������Ϗ�ǡ���C�&E'=^[�x���`�痒�W�UW����DۉH&?]?�_�C[�7#U�m�|�.��m��h��d���k���~������ ��?�V�.�6�^�ی���{��s���u�݄"�������3��O�5]ӓ%A�סhZدn����T�/��R��!gZ�^*�K�еS��	�HB���ts���.o�V� ���0?0�[�F\����h̏�5�1(9Q�Ԏ̫m��D��s���ؔ���"�.��ԃ
:�Ū���̫��A,=W_n4��&+����$����cؘ$��7k8��C��g�F2�Pļ��L	���a���u�"jJ��\k��ӽgsk?�����)�?�_Lh
�࡬��8|�����9��:�jR9����l�gz�������Uɖ���S��%��71LyH҂�����ѓ"���O3��w��)��IO�iwt_9�p+r�    (���� e�
%����~�����B:�K�����D�x����%gӲ���Zv�k��UO�bf����v|��r'q�5 q�b�g���l\�c&�)��2�+ߛv���Y��=�/�U{��
�3���Ww�r��B���,ЃR�Y���}�mۆ$��)�o �?B���0�
� �n���U7�������x)T�M��V�b�ԕND��tP�����@wlOi�����tX��؃�?w�}.0K������]L�*�a	���8��rd yΞg��eo���1oS���sq�V��:vԙ˩��W)u���S�������亮r��28��2�}v��$��~�FV[�#��H.�r�$\��׮����������/$����?���r���0�A]�Cl57a���谈5)���f���Wp��}/eı����&�(�9�f��bA�����RH��V_�d2A_�3&z�tm�=Qw@�O��h{}P��O������(-Ot�f5<Y�r%`h*��$cg��-��Awۃ��A�Z��vFB:�(��9��E���y�}�5�]&)'��}������ƞ_�R�-�w쏧����7c��C��0	�{q�U�2Đ0�q��B�;�T�0D��)��)A�u��'�gW��G%x�e��	mĔ
�!�sK�KF;�>�p����ct}�k���6B�M�X
k����r�������a3�ëQ��#_n��u��!Ϛ�4<�9�"o�������.��np�ܤ�s���o�z�&uX�`�{m
U����q����dUM��Sqӱ����U��9��/'�r����L���dT?�=�w�X�5��JH�Il���pI�y��ȅjE,�9����5%q�918(A�"�|9�]��d�:��vSʕ�IKc�'VF�Z_�H��K��_e�X}��/j�S5��"rh�����~��<}�X���L^Z?��x�q��B��K��頝��$%��7�ыM�Ŧm����(� 	�9��n��T������r��(�tO�����A����N��H��/�A��!���0��Am�:�Vu�� �N�L��h��/U0��{�.E��J�_/6`��t�������@X4V�2ԗ��ph�bЁdw�\�K'*��Ba[I���~y��iO�o��)v* ��b�^Ll<��`��	�zhׁUL�ra�m:N��+��"C+�\���,�YM!�󖥛1�@)|�0:�tK�K
�Ƽ�Ʋ��'����F���������´f�b�i:��E������;2T����C-�m/֊�p���(":��uXWcA���کŽv}[4/_ͯ��;x�F*�^�����2GTc���C:��b���j�u��[v��ۇ���H�&���j����[��Q�%��{��4��64����$Mi�z�ˉl����d{�#��ߟ�Q���}7|5��]���pГ2�;�fˆ��nߢ(v��w���O7�'��~�'$�
��-��8���7�=�<���a����O_��U.�K��
Ε�k�\�)W�%��f�����f���A�~|���BA/��Mq��� =Ac���@oWneS~.����"z}�s��
��r����F������\���=�?�͑L2�F�+c���?�L���tՒ�IҬa?&�ζI)S��|��z}�l�Q�;?��i�S:�"փi<��4���qn�-��BI�hɩ���Gj;Zo�7T��!:��쏣w�Й�}_�����X��c�ֽ�*,�Q��Tq1��Lp��e� �߇"/�bϨ���B�s���sr�u�pe.�TS�p{�#���O�z���~�28��tIO����ͫ��������{
����|�� /��6�NӜ�0ܤ�mΖ��F�X(f��������Ңm��ze����qH�c��>���t���U�u�?����tS�J�I�^��:�ޯ;�t�;q� 2�7'F,��眪�x��J����	GԲSN�XL�_PɈ�� �����_��X���jd,8=��!%tH�uC��-�^���Q�8�@�	�E����Blkv�Y�Yl��D�E1���N�aC.H��-����T�R_���E�v9��Mc?#y�)�v*[8�+x���݅���\-GNʛ��U�����3�=&"Sv0��W�9���^Q��uC.GQlq� ��Rv��I�p*2�5/ń�^�I[!>���Oa�'�15�7p��]-T2��T�]�	�w([���-'�8=n��8}���o&]��
�W�|�G��ؗ-��]��@��a.�*$�Xc��FΚ]7W�3��.�r���]f�_\���)�����ތ���&��(�V����]�#b�Gum.�y���E�����'�E��a!������W
\�������g�p�L˥��N�۝��A��:�Ȯ�߅���Ԇ`�l��.���[�'\���:�eg��<���]�:+�`C�s>^�K��a���j�����X�k�}�K�������^1�*�4���7�^�S�$<��C�0�����H�X]���dQ�	(��+e!uX��J�f�K�Уq�g�B'�5�y{�[����v�32�|�Q�IC#���a<d���#,6[�K�`�'�����|`�"��]���L�ͦ�}���(�q��G�G:��MK����m0��u6*�)z���z�B^%���4�c��p3O��赬��cc�>��O�Pd�����y���g�V
�F�C�+n�V	��B��^�f� �{}����.{�e�=L��K47���d�Q(�X�ɪ���t������}s�IM��;��� ��Ë�����A�ٶ#)W�Td^��;5� 43`�:��W������ఖw�Sw+�׹ʤ$�0����X��_n����>�{|���b&{Z,>�d�3lj��p�հEP�b(A�P�(�T����qY`&���W�T|� t�a���c�y�.p��*�y�}Т�����P�P�M��xaU:�9�0E~�:�֛�����a����[�	݌�Q>�&�-Ӌ�5E���LG��y���{�HM�f_�	�������%2�5��������w��!q���M؛F��7������;�_JE�� ���M�F����?N�\�|��˛k\ 3��_�<�x̽_^T�7c���� ��,ֶ��;1z��%�;��3��+tIc�����gT��?��7����)`0��P_���G�����<���_��N�b��ak���%Ik�^�������Yhi��o8N���L��:͖��p�6d~
�c���0i��k"�4N�6�d�>N�]y��:+W'!�ɏ���\��e����T�|��Я�~E�t����!���Ehdɏ��	'�~�ހI������_&Ě�{�� �er.6�\�6i�F�f�"�Ŋ��=���A��X���\�iR��J�t��&U��*�q!u�O�R���q��!�}��	�`EQ������]���لN��[����BH1P�*>��Dr>���IFc(7~Z�<H�ԉܧ�����Q|	�W��=p"��٬�(6�DNEO��qȝgi��j��f�f��+F�b������|�&8.N����VˏtD����(:���7������p�%�ṑ��ŏ"G�i!�ܙ��[��ϧ������A�3��IF��&[O��~K���{2����ܯ4Q�6��V^̽l ��Y5��n���&�p�8������/���p9/����lZq2�Ͱ����[�h�V�u��9�#�yg��&����W2��G_&G�P�\h�W�\?9:��9RG�O�R�5������m��p<����"m\��,��.h,=�G4B!a�|<2��틡�Kr����r�m�kw�vE	ɫq��R�� 	L":y��ij�7��U�^�V���J��#P��O�/+�PF��뾈((fI��5�E#Hȝ##�����ϙ݃����&�Z2󌕍˭GŲd~SA4l5�P�G5���( I�9��\;~���    ��Uc��VF*���V�o|�k���؋�<�K� �ɿ�ݙ�%o�t��B��г��NU|�����~�����	I��$����-�GKg�b9L
� pP�W�rfv���eW�|<�`C���ۛ��ǻ��i�8��vMa�QL'AL�c��	���o�m��-PlU�R�b����� !Z����[��|���*H:o.��7O��G"�>ȵ�'��z�J��]���;�'��rV@]6���Q�7�zz�N,w�Y����%f��l���e��;!�O�N�mn�/h��<�����~����N��Cr6�<b@����~��R�ڀ8hĞ
���p���2�
�6 �R���a�]�%b���?�r>=4l31�rM����a�Ht2�/U������i��ǻ���V�< g��W���_)�4�Hrh�0��Q�����ư��N�ސ��������Z�c`ⱺ-��,,P�-�3
φ,L��,��M��O�(G��a'��l`{c�:���Q:��j�<)����
JBir3��<�ѱq��&�釦�Q�]r��R7|}��e�0�Fג�xG2���a!ƍ�O����s���J��M`�rb�#���� v|W�s���ne����V�;�W�(E�ɇ�|�4����",��dۼy�~ S�l\����bZ`@Q\���G`���!P.ud��֭�R�|^�]��VN7�jw�
�g�?K����F���z��|=G�$؜�9�>�濲(�#�X�9Ѥ��&
�*�V��D�ܖL���͡�d�l�����z)(B�}�0�m���emò:�A�Y���|��~������m{�@���5������Q>���b�q��[u,�5�@����
ܣŦ� ����Dd�E��A�r����Į;^w�����e�A�ZDmv$O����i�o��l�HE�bf3AK������.��\[�@��h��?�X_�;�E��qD�o�'��\P7t�S�Bzs�Y�|\�Z����g��>��^=FGV�u��s�F"E��=���,���Y�/뭴6��+]���r��.U�>4�̇� ������^�}c>ar������N��G��*)R�Bk�C/(	W�~�C�t�\�J�rޛ�d:������_�
H�u?Hc4~��o���7���$or
�#7���\$���Q�����b���	��&s��k|�l�\'�Et���_?�<ZI/ {�V���,�|Y��m7���d��� }���5K���� F=DM������O��V6�h�ɮ��:��݊��=H�v��wp��s�Xߧ�Hq�P��W��6?.T312 ������MgYC�|[eD��ggΩ�)��#�;�ù��m�n���y�[�\"@'��IW��0ì/w��,Ǝ�v�N9��v��*;��^>l/P<ݓ��8[S�G�%8��鄤�qu�{��>�����g�RXW wMtbtqa_rt��F캖(�<	X��Q�0�R��l�D����`�F���ӎ�$.G�K;7����O.�9�����E��|=}M�|l{-���bb����%���y�_B=؇��rp���-��{"&�R��VTc��\�%Zl��f� �<�G�T|�Ԭn$C�1YcOB���`�#C��?���/*2�$8*��䨱�h?<�D��ʒ*��ݘ���5���V���ܹq��ޏ1i��z�f�ґ��#0��:��۷���5A����D��ŵ�O��_4טB�\���H3f�1���Z࡞<;��Cne������\���]�/�D��B!��kf���Pj1�檝�  W:�;��/���f�����Q��:�=]����_�uO�S�|�\�.U�~�ė%u�}=�V0��e�aW�f�W�:���;6-u�.N9�^ǖ�4�c��E�{8���N($&T�z�]���i`C�g��n��.���kן%E��Oϒ�a���0�����:t�ګ����)��O��\�^m�Ha��~2�LN*Eӗ'g��J��@�US,�`f�y2L;�U;��M�e#=���H��|̵b��^X=rű�3�B�n6Z�0�i+\_b���~`����E�<D�*�^�pg*�{,\�$��܍�1*ͪ�E�&Ѣ���"�PϾ&�ʕ�<ԙ,Jׂ��f�t`��ʛ�E�`d���0��nON�T�]J�|W8,tu#�$�ߡ�J���ľm���8-Uh]���S�9r�:8j�`�*�yB%�'}����l��GY�l4Ў�]+]y_���|�mč��>� �o$i|v�������4,O"]�d)_ڞ,��~N� ������|������:�� c|�%��/Qu���\(��XlΐB��ɉZ�8�=9�^B+6�ޤ:�7.�n���Mti��I�ᦥ$����cÛ����v��70��Du���f�?n.3�����0븦5zk*�h���̏���'�E`}q"���r���[��D����T�v������=�j�?��[�O�{�߉�f��P<}k�f��߁���+us������P�|p��`Qh��h:��Mh��ƁBM�2�5�ո=�{����=�R�%�i�L���oT��8ȷ0�>:�<w���oQ���
�A�}'d%�K���6����VH76�7�v��6�^ʘWsd*l ���%�;%1�-z��֣?`L9R�=�.������������j�/�9��24[6�@�'�%����k�q�wY�Pn2ц�S�rh���5�b����O�$j��BQ$rJ}n���G��M_J�ƕ������@?4�3]bD^`I���tb4������c�Yx"$X�]���+-�p-�٤��m��#D��(7�:Q����F��'��⍖�K�R�O�Ft�*���
ϗ}��߫&�Ї��GO_�v����wu�Ø�U�� ��2�N:�"���]��G2��t]���(���ey�}�u�*k1_ӻ���^�!�� �9]�)&�ױ�{�'2�<
��-As����r��̗Z�4'��x$��x�fIݒ6�wΪ'o�V�.>��z�PvC+�B�~�A7��6Zo�)ꍛ�KY֘7���7�c���솛�QOz�� &{ǐ|���GI�#Mi����1�Nz�	,]*�Tq���\=�C�ן�T w�!���8j�o���0O|g������҈�r���OS-��~A�#+���Ҽj�Q��0l�����8�kR��M��lZ\_�����X��]<}~|�>.f�����d7������V����|�)���3����}�G��K��|UC8�	BmI_9�N솠�dO��k���
F�@�X�C�__�R/a�b�s���k�A���ƥ�����U��z��{ĳ4ǚ�Ɠ
9L$HQHEW����G����8�����k�?ib�P��<��R���h|����=�����2j,W_ޖ��X��:,��ŷ7�"�����8�҄Ss�%R���݅����|6=�m��v�a�V2-�_�~2���k]!��D`cfŉ�H����(�ԕ��P�~�R�ꈧ�fV��#_)�Y�����n�`���P�̕N^��Oՙ;��r{`ĹRbD�Q=A=�`�.�4�l9?:��Ŏ��u��}�qo~��r���N��5?r{��Z\��3Y���ӯ��f�K;؅�k�/���(���U��1����aR�q+/j�����Jޚ{�d�����@(���#������y��۵��7��`�VRp���^\=ѻ���+�3v�|�i6�JP��6�pQL�u�6�>���9�<��eyv�X�Z�G��VKh"'��
5��rϕ�

7�1�'����̶�Y������e���s�N�������{FV��e���r�020�}0�:��R�X�X�En.En�..?�K��cO��� ���펾j6�����p����M�to�u�f�Љ( mr�aN6kJR�!N�7�=Rer��|�.M_ w^�赻�P>H]2�A�+�G"�i>�چ��B�K������h<T�S�2X�����d��V�� ����T�i�ҿƴ�@�;!��4�)
��&�v9 �  ��w�f>������Ekn�T��o���(0e�i8M6Y�2�������߃���
l�3�t��.��Uד�~�N��=��CJ��=��е�SH��c�jذn��C�j��wB֯�{����*�~ΡA�B����6���G<t|���f;~2&�����/I�K��1	�j �Nol�L@!ܕC���� m�eE���]�8"6l�k��r���-�|.=�<��}0O~](z<U��|[G�s��:�|P/�+0쵉�D�=�)\,*'��i�������ޥ �ゴ��
������������:K�s��#E�d���g+cA�����~PE�Od
��%�sل�-\J���1���k��ry�#`�D��3�&�sp�L|W&�&�he�gty�J��i[S?,�77�_){��BF�`�g�ӱN>p��I�6eD ���H���W�a���^���.�P1+���*�����7A%IZ�FL��� ��`�DC�~��h^͓҇LM]�pA�l���~����M���52[V�i%�����hg�9�5�&�>�b��C�Y�����r���n��K���Ӳdz	�����������aп��:X(%#)�.���	T{}H�x`�[gc��1�c������\k6�};�:����A�ƌ���(�G��x���c�k|	r�y2+�H;ٓd3�d|YF�#U�i��!�,�婽����A��*鄡~��ZW_Q�^޾�'Z�y��p����߷׷M���'���y�z�����\���ޡUg+����w"���
���&����6�֜d�7d��r|�Vȼ��%�B�ɰY�����z�����G<�~�8rࢻJO�f��o�!�凐�����g;J����Lv��v�#�2��6v�XI~�ٳ�`K�.�h��(t~�������4)���zI15��ܣR�*�\��Ɨ��n>��́�3GN2�_(�X�w�F)
�g�"��vL]�}�-�����E�Da����/Wz������Β!��������mc}���i+鱓�ŋ���5��&8쇟�L��~�̑4�|W�,0��0v��aQU��x�6�s.Q��U�i�`��$��K`�1�6���\_�¼A�|�7��zz�`4��o������)�      �      x��}[s7��s�W�����a�ߚI�x;$�9���H[�$RKQ�=��7�* ��l�mkMŌl��Y@"/_~��	&��;\̙�evW˅eN(9���x�s���a��/�^����]���|��������z�|���÷�hnf�;�ͮ������٬�P�w���^ݽ�9_��盻�N&g��-X���������������������loy�v~�r��|}�<:]��߾����jv𣘁���fo_�8�x�|���������bv�<ڟ%����×g
�b��]�V(A.�=��v5;A�Y����^���W��/���i�������O?�~��VJXj�0��������$���H�S(�`�ߢf���~���}��}�A��[��4o���w/�Җ��z�?�Em�t��:{������`9��d����=5p���Bɜ��Y=޵jP�j��d�Y8�-\����Z0�㧵�����O��Q8Vm� `ػ�ػzW�].�����	�:�&۳q���]���t}��t��m^m�|����� }�Z�N�r�J.�2Ɩ�W�� ��5Ź��k;��6�#�L{!���k�zmQB� OǗ{4���J�p~=h`��5������(4��i����2�l����/_/����P�+EA�V�IvW��`��;x���c����o���ޣ
�����4�7�������㷇�L��8M�[���Þ?�zwq8+d�7�zo^J\��
��6�vG���ck��`�F�-���L/����Dا�ɢ[ɽ��E�=ѵ�_ϔ�>��[>�T����Q?Wx��ծ4��/���z�arP���"�v�Ծ��	
<"��0��ܜ���fW7w�g��A��w�x����ƺ�.�^���_=]�.�^]�	�J�Y��u֭����y�u��-|�!�0mIJ!�EӅo��[(#f�R����~�^��*�}��ל5=���Ռ�����'9�]�|y�i��e{�����Z�}���5_�������\��������Bɞ�#�//�NO��z���U�-0<�J�ٗ/���_��T~詯A2˅{�gbVi
L�Yߺ6_������ݟgno��\.���e
�U�~����K8ƥ�M��ns�����	��xL�''���Q9����$�U0�D5�*�r��Z@����zEӂ+c)��@�嫳�W��j#M��4���@��{#]����x�A�b���aEv��w/~�iw/��[�:;`�cV�K=���HT9���'{i�Y�L��X?.��u�%�,*bn<h�?h�i�_���_ȁ ���m4���Q��Q�!v�X�hԃ�Ɏ���o��F͒1s᪃eֆթ	�'�ƪ���q�BV�$�q��慄W��Qb��"i����~a��`�]aF��*�5��uyZdӄ �B>�KH1]]BQ�`X��afW��e��O���|,7�|qii̳�����ծ��BL�������5fz]p/^�,�\v��_��`:���~g�V�>���oR�1�	OQ���ӊ�̌!i������
=�o���
����<�g���^���_5���Ө���G��sᦆ@z�^#��93Z;I��ag��M������W�*Ʉf,�I���9����q����{�W{>��.x;>���vP+�s�"�؋�80K�����;#�w^�B!�-��JW�C�*����B�l�����vӆ���{��W�|��X^����*8?���������J��R�*tRgsЃ���FǥlR��!��Z@h1���-d=�S�Z>Q����z�-Ġb��sd���rS
p�lQo˩j�ɢjA�E暼��[��W_N(s8{��	���Y���R��C�z��`�����D]�A�Q�����
���뢨����	u�L�7�W��ʚ��d�����ل#\��q�˫�$�H[�j�B-�9�0�Ft�}�y|���vG���0���:�CI���[��8�N]�S�j��:����J�����G�d�����49aI�G�%�͔���mp�'b�R�q��7��\-��XO��R�2ۅ߳6����k���u��9u��\z��Њ����KV�����vcY���?�v�RZ.֮�Ó��We��N�����/�ڙ��3�r��u
���p���)�;��pFB�֫�I�F�4?v>LpQ�w:�qXH
?���aXE0�CD���8��^�����A�lWU��eGݶG]�b=K�`�,���_��6Z����vw}������> ,ʹ6�{?�c&�J���3�e�e�޲�ޕ<3f�Z�������1�����f!���	����4Cl�?o���,�R0W�[�v��UuD}�������C�����`Ԭ�u-�����E7"���e���d�h�mTt�47BLj�e_v��di�cE�m-�(2cTv�=�s/7���j7H/�B+�{ى"�3�i��B�gt_d �����y)�~���mXW�%6���v`�-�ëRb��� �,���Y����_����o?v�;
�E}@{��@�r�<0�)fF�S��U"}�P��� �%&�s̠���qm�xzy�\0Z��j��@�4�eDB�����t���TH�+!E���HK�	fD���`�(,��㫃4�@��B���~/�`0QƱ:o�˷��\6����D �1^�Ӿ��rjr���cq�w4�R�e7;C��~�D'+F2k7�OUw B�	+���os(kwd<?�B֪�ƼG1�0� ޘ�SB=@�!\�Zm-$.$?�|Pn	 �k-A��{�-c��ϵ�F?k+�Ӡt�]��Vp�fÍ�0���Wfv�z�>|�Ⱥ���O�4����-nv��m)��@/S�<]28���j�e�|W[x�j�ˌ	�ˤV�^fϴ%	����W�*a?{ƙ������=��S�Xۃ�4�w�=].��m~��L�����������t��'�g&)�\r���jf���I��˭���s*?�ʻ�+F�M�J����4�I_\�������9C<�J9t��f@	iD�|p���f�@�ۺ@2����F��9i3����#v�����(�1ـ��W��YԶ-��e��Xs��1�Ԋ6��[�`��5%�'�����(�"�j�ԅ{Q���=�D�ӀO$����
D2������3 ���(���2��B|������l�PN�
~�����B���ճ�����^Kk
| ��Ia�JL _7��uC�0(�l;�PA�|���B��#vm�1q�Ƞ,i�:�k�M�܌z�=����p��l���&�����{�c#��
f�4'+�W�OJiL���&��S�A��:W~�%�������`�	n��K��vD�i�����.:7��+��?&W��&_��!���� �AlXF��P~7�"lV�Ps�w��#��~1��P����ל�.���9�"�י��/����	�H�"j�ݏ�{Z��)�`�J�:�Lq�vA�-8�r%HJ�R?1��LP�
A�2�ge�:,<B>Y�'��8��� �9���k���K����a�"5�9Q��vxP\�����br�94��_��$;p���CW�<#�-�6�G��MVںF�}��٧��W麠�����l�7
r�
M��"������������6]D�\�	c�cpb�F/��*��,rr�ER.6	��k3r�y��kaP��<�z��Uאb_p2$|g���́Q� U�?Ш |���)d��B��+6�(��,+)�1#�����C�5��NUT�j�R-��B�T*����3�rj���Hv�9���)��4�-a�ʸ��ͯw�l��t�������^7?��7��B��e27]����lVv�#Û�9��&j��mvV�;��Ĩ���Y��	�$H��+�D��VT(ʪ]!��h�Ӡh��!Ʊ�cqg^�9|�    �%Y_�Y2�?��Z|9͏���1��7��=�!��%ӌ�\z9���Q�q�5�>�K���Y�Td�MO�q��z�5��.�s1�v���%�ȷe��;�cc^�[�w;8:�������z�ؖ����x���"(g�ejq;L઄��&W�t�񱟕@W��I������Dl_�S��*�o��ZF���[kg�h~�����ŋ�7�-	+�Pi��Z���� 
��v�����>�h�:tw�]�>�7�k�q�P� �C��6�fyz͢�G	�H�
�elm�;I��teˍÎ������	?�gC�=ꍷ��oG����l��U4����n��lQ�y��UQ�W�֘��8A�9��WE��
ud��~�
�,��J�a�����B�t�"/7���+j����<U�$�]�w��a�@&�u�{���!�����^(-�`���dy񶋍H��tj���5�a�)=�Nİv�:N6!Bdn���1��\(VG̶�I��-JeE1L"qn�w���J��:I$GT�TX�6��d��5��O�t����x��i�r�C�X�2�x��O^{-�z��J�6��HSh���yx���4V����p��#�X��W�ؙD&:Vi�7ռ7˓�w?�������'G�(�����s�g�cjoO��ǀ��NVw7}��uޞ���D��Z���l#o�����i���ʹ��ƭ�{[+�+BZ���o�?P}�Y��Ak�~�6�VhǱK��;��H��s�ŕ�W����Q	��x��ط�+W���xU �VF<^�F��K��(�R�P��W
6N,�5������кT�P�Ψ�B��6
�ߝ�Y��<:��TjQ��QP��<w����!�偺*��ՙq��_ڝ���p4|�c�sZh[�^UV���6C�Œ�C�	��3d%wߑ��z�l���%���a�P��q�K�+� �p�8��+�n��Xj#���g�lY�O�t�귗杳���`��y�~?q�x�u/��� 7O���H�
<���T�����bի���z8���ϖ�@R�P��Y,,xu�w&BV�~��H�8Kt��i���򻣫�{��0�+a��-?��7k\��Eky�+�[��� YI�vh�3����]/�\�����:�E�jiH04Q�$���y���u܈�	){��ǒ�Y����C"��pS<>x��ƥ��|�<>�Hl��|�)؛��ޠ�y��QLJx���x[��d���o'�ǣW��vq�sq��jCIAy�r�M.(��
B����ޅ
R��1�	���ӨI�Ӄw���'=������&�&�ф�4�$�]��S�c{�~ZZ�iA�F;���N��<�����<����'�F���M��!�&��bM�:���"����k��y**J�b�OfN��~�|�����<��h��1p�R{����1�U����<y�7�&�[�I�5jj��4�Kl)�`���==h�*s��zЃz��}XQ��K=B�M�%�ǎ;�I��m_+��6� 9���>8q��܃Bu�Fa�I�}]Ln�:[��z0�ve���|�����̢�	Oh���z�sGѰ0�y�\1������Q���K�Q	������#�ޛ��^��ֽ~�L\��j�������~Xխ]�*8��v[�<[s+ 
s#�">~������s�=�B�]"H3?>�?�>�?�>��]?��?�>,�țWe�����I�A/���-r�����Ex"*���
)>϶H?�Мo}�.��G��5��A��{�	9xT�P�I�Ǿ���df�2׃�'�`_I�&�9�J/�>6QvЋWg ��%��8:�s�]��ɌC]� Wr����"Io�����OBK_[Q�Y�I6�2Ҽ�]��ql���0�K1�\.[��ذ'�l�OV���/�h�J�@(������j͜%K�P
�,����"���q6�c��u4�l�e_����+�}0c�.��WD!�2m��P��I�������!WKN�!a�0�^�/���h�3�`?���Y�����3S�-��J�:��L�Z��9�U��@e�Rz��,���4�o1��,PX*H�Y�&�kBט^--��Y6Wds�w���6���Pl$XH��E����`����_�?sv"�e7P!�S��t�L����8���k�JӰn�m%Tkd3N]�A�@��?��܎Ϙ�JX��@�B	�@��b�;MI r��"�~���!��i=ٸlA��g'.G7�W�"%崰��W�R6m�/.�m�M�Q�\�l��m��Ll��6{���ڷ?,Q���KX����6̸�Q�����3��+���7���Wn$�[����|�ʍĵ��Z�L��ynK\��y�cgO�jC����l;��\5/������Ph�^�L�1,ǥ�x�`��qF(���/���VX�����3[�	����.�� ��RiL[D�[��Kc�C9�N�P&SN�=�Qz/0�$��%�db��}z0턣�S@��r�Z������B�Gs s�z���h�#_�����QQ{��'�'ߞ]-�ⷂm�X�4?�:X�U��d58,K�R����t����%�v�]��[���ٵ�m�����m�9-D���bͧ��1�\sL��V
҄>-��1�%�Ӣ��i0�����3���V{R�/ 
7`o��QY�����	��'�����W�����X ;�R"ئ�*�4�;Z��mRv۴��{�i1�3�`�v�x�^��B�ʯ}���f]�G�I����fD�4p*�<����%i�Y��H2#IK7��m�W<���,�9}�u����K ,�-M�m�0J�*ZO)k.�w �,�dM0�������e��")b�~��\��?��3���RoR����ntW�­	T��F�>ㆰ��*������W��l3����gp?Xo�^Y��F3m�(;S���&�K0wo�F�`��$��$
�ٮ�����D#5*`r��Dd�?��J�fJ	2�,�7Fن��7���CJn��gv}����擨@н�%���?(��Z�j1Iĩ�@���?�'�ݶ@ꁔ�pLp_���j��o'#� ���莭l'�����	�=�@��ʮh���@���nx�s��s:�l��L�`!/^��+v�,���WZ���+e�=&x���\"!I:_v I"�;��;�	B�j����2Xfl-�}Ե�6	�%|D�l&pMK�	'G�qC."�X�D��F3��g̘+�;l4�5��|=iC��E�+aH+F�7T����D#Û��z0�-�&y��k`}&&j��P\��DV.6��J)&�˻���9�G�rjq�ό4�?wR)���p1ѭ��l��k��U$Z�aE�C8�(*xb�[GDƇ��#���Y�A��Ւ�֙��r��铨��[��g3ی���������q~��\g?��w$q�o�F�_3Y�Ķ�0��k�bޜ�	�^��-��}�5u�Fsg�>��>�ˣ��g��Fb��Vok�6��w��Ͽ}�.���G�c��S��\kɤ4�����4�}��=Xɗ˛�*_��X0��:do[ål�+{!����{1߃k��%d�va�v��k ?�n��T!:�R�_?����7`�`��;$������e�T�|���l��/P�[O�T�s��}�<J�R)S[�(|�T-���p�
��Ώ���[����r{�����Ƕ��+��u4�RK-�D��f��ݎy��M�w�ۻ+j��."4!�<��m�y��w?�����
��H.l"㔦���^��ϗ{G`O����1�������JqX��:�$�tyZ�mZ��������C֞FA�Xb9z��*�Ul~tt4��_<QM�fx�N��`�Z-��i�Ysi�E3�#0��t/�7�e��>��2.���e`O�U2�&�%o����y��Z"{�!HN�]��������ΟQ��"CU�����>l""�P!�Ÿdk� B�п�ޞ�j�5��~!��D]<+�C�6gH�霴�� �r��,+y���dځ<Zlj_.��j�!~�%�    0Ĉ��]��+�x'^7,VicI��mb!x��r(D�)�9�f�:.���@�.U%����%_�.���Qz��?;8�e��6��Ȗ���D�%�<on�'d!�cNS�Z�3a�68�b��&h���g������`y�<��<:��c2l��EeetX��Ұ+� �p���Е��J�LD˦��r�8���x����$���ۗ�L�	%��y�����:F�H��(�Ve�X�:!��b����"3�/]H�qD��T�ar���Ð����Y;�E�=K��a�}�#����8Rx�sO`o_`F�.�����}�<<~9���kG�CDcR�-Ǯ������w�In6l-r������<�|�k�����W���cە|�pƞ,YA�%4� �e0m��$BS�g�w_p��Bx't������#(��a�LkwpNZ8��-+p�5��+,6�H��#�`�l�ɍZ�ȅ�5٬�4;�!6٦3a�W�f��ν��<S��J�$!�礍T��$,}�Ln�w�KQ w1{:	�C��2�H�7o�?�Ws���������1��p�)��<n����h9@	�W���u��԰n�3���F7���o�����Pڴ+����ʑ�a(�L)�̓����ʢjZEH��dw�ͳ�z�%����
nR�{��NC�)�,��������ng�����I�$�LU:kwU�3)�>�N��]%��3�������<lܬ�:j73�4����/.�����eE�����A��a:�5f�-�2�A|��}�p�5��Ԗ�D@��byǱ�rGɣVNV��>�Z���PjEFLO]��1���q$hDi�F��9��(0�ΐ�7`���3
d����n��0�i=(��[�ǎ�-��Ws
��a!9o2h^ƣp���n2�BPl��O��^X�ZX��\}~�?ܼ�7�,��FG���k!�$ԅKڦ���ٔ$lHaf��y��巏��m��\qzT�J�g��fo�[e���S!wOL��OSon@ZE��E���p��.��!�`yB����?�v)��Ӓ$�(���'��OD����LI1rYWj��
�x�@�J��k7����Ǘ��y^�x D���+B(��h�/�.�����q{nx���v�xl8΅$<V�O'OM2�E�tdŦ���ԆQ�~���l`V��FXm�����C4*�RO\C�>	m(|ϓ#��ܫ��z�&�O�'���&FR� U���zl��������Y�����5!A�{=QM�|���VE4���������_�ϻ�m~5uI)$(��M���9�5�z�Ku��9��T����u�mj7u�FiZI+��'FR������ߟ
De[���A�g\!�����<�`wy+���uC%t[��C%�ӆJ���8Syɒ��0W+EVi�+�5 ?���j����;f(��oB���&Og���Z��g��u�O�P���� ,SN�w� ��'oO���|�ˆ�RDg������b�I0^��:B9��:e�X3:ή�ޅ����f-��psIrL5E�T�|�I�Ee�|�}��@!��)�s�5C�X]n@�hcc/3���g�z�wZP����3�:y?� 1�:�Ώ�4����l�7�uB+."�dٜ��hQ�AnzzT[*O�&�r�����/T����@bgF',R���-gE�lW�/al�D��{	.�>ۃ,�2��q��|�ݜ�\�LF����B�cw��7�����ܱ�y�:�����r>VΤ^/(/���Đ�V�b2��!TV�� J97��H#ћni�o���M%�[���ItT�D�q��Q-�|T����"��*A8x���D�O������F??B$��u�\�8mGO�6(k(�i�m��k��(}T�<S��6���Q�Jy�$�c~2��SvO<ND�O�{�lf��8�V���-y3���JR����3��$8]��QD�<AGt�JEqQE��g����M��H� ���}m=��>zuq����r.������ë*jh���G �� ܛ��J!�:XQ��z�/�q!�D��1>h]�8sWȜM��8R��32�̦�x��rO��k4С����\�͕���$��35n.�%B��~K9͚v77r�q�S)S�:b<��0�������nN�W�����i�%a6x�!-�wI�ʍ�*��lq��nwU�w����4p�P�OM05�}0�@�A�qN�v��fܵ�2ѡw;|hTc�YA�͘!z{�?�:88��dGu�RgA���I �L�����rsK�O6����`Ky��W#��M�+l������!��$��B��q��1h���<�4^��'dUz�`�ێ"
�e��D��ģ@�A-�U����Y�h�� �/�U?��&��{U�4JIݑ;L�Ix�2�T��F�	;�j�8T�U�����&^�Ɋ�f��VR���h�h�S<����m���k��zd_=bWJl��&����H��`ֱ�QtG���B�bDL�G�Wya-�|H+�肺�lx�r���_Ƨj�f��4�ٓ�MF&/q�63�R-�~�BaV�<�����8�mւ�i�)�!���L>����g�9�}%����k�U�B�bz�<nA������K^���G�"��^�loֶ�H�΁�ěѧ��O]q���xڗ�\&H�TK�HI��n��?�c���\n��P�B!Sl#����ѫ������C��m^���y�d���?�\[|� A>b���$HJJ�(���}��LN�~}����6��ᑂg�,$���k���g6��`#��ڛ�b�B�8c#�jB.�0���5]%~���ҔR�&�I�rĂ[�LT:���5���R�x5�n�H��q������8��('�9�5��d����6Hd����OF���u� �0�$����3F�	V���z�i9u2�Z��6L�K�e��������	��jy�B	�������X���F1f�#�@�~Τo[{S[�|Ѵ����U���
"�8��D�j�sV��Y3�#��C�T��VoQ�f������u�_;?��|�xs=J��j�а�1#{ZD����I�`"y�I��2�J�g �:�����%�%|�dNm02�&�%�6O�j2G�?-I�J[-�r�a!����l��/�~�D}uI�PF�N���_��::9�:��{����^6u���y�n$Ïx/��\Y]$��q���F��Eυ}���	r���fNF�j����mwM ,H5d�����'�WX]/��6_�XMߝ�Vc�Հ&��P\�S�˩������ّ�*�@�?/���9�0;�{��r_�%��p2,�S��(��] �!���axIZ,�����uu/�g{I�Mk�aI��aE>a�B���4��Ck{#���>���V�u����gp�2d�t	>>;^�&P�Y�^C;p|~A�������ݻ����2:$z6�)-�#�f�Ce�]�1�;~UA�.�$4���M�%�b��x��d��9����M�(��y(]N&9M���|#<�n�瓊D�64�t-�b].m�#�J�dR��塥��n��w��WBC]���W[�2��
�%Hda%�F�g�2=6�$d\��w~J�|K�($������4E�KImh�1�+%d�N1���bC�a<��*�H�5ΌK�e6�7�?b�EMp�r�ok�Q뷁�<��=�l֮C�4�]V�t�m����#f>9"C	���h즀��9"��!��3W��K��W>�/�����/�w7�;� |�_�o{�o1[H����B����r�C�Ì|p#�.��j?���E�-g�3�!B9F!/�W�^R������z[�q���*��
�ͮ�ᄁh������e�fʆ����K��?|��d ;x�?5~|ݹA�k���)���_@�T�$&G5���C\�q|�l��c$Z����Y�[����P�I��h�TZR%���4��g8]�n�\�� �~�V�*a�^�Z����7�&�Y����o���ЁՑ>    G��b\^�u�fWT!��D�-��~(?I`P�giCp�W�@�؂AH�y��z"A�ϊ!�ֹ�dϨ�)��i8�;����"��Xb��`���?�GW�:���2�Nx�$<�3��/�� N�*�4t�	�N�d�넧M� �����?��F���p��҉b=^�N�@bφ�Ssm�42�����m�5�:^�;>�<�����я�1��tu��	�Gh4t�DD�p�9{}:?8<�h��G����P6�Uj�k�jj��h�������2Q�!V�-�Ysw��d�M��:	�i~��免��<6��^"�ò���=�Ա�v yPxnlX�R�KI�>a��h�Yɪ�܈��8�B�|�n�꧘�R��m�s�
=y2b����h�2Z
�i�"(yo�/O�9r��+���m�ڱ��i ��0��Cؕ]1�A�Y��(�dMSr`ݛ�Bҽ�������h���~�KTB�G7��B1F1م������h>Ui>�U�i� [����ݜ����dU�W�P\MPT;�GU}���2V���tힿ� {gɠ�Y�t����x*#���;�(�H�S�����l�+�r8d���쨃j�	Qp�E돽:;�,H�3�_E�W?��$yC�O���ז<��'4PNȎ�릟�cJ���� �A��s&G�~��Q����S��g���o>�x8:'>��U�t����]���RUyT�qD�,�9�2�Ug�TD&,XFfNݰ���E�R��RaFo�b��U�S����y
+� ��R�PF8*c������/�f����|�g;lu*t���0���X��ػO�wSaT�(c�$q0��6�R,�f�"Zq�����16T�5���o�n3����5J�r��vr��ػ�+�.���B�T��F�3����W�J7���׏��\����q���b8*����Co�Ӄ7% ��!������±���g�s�z O�ڿ�i�t�����xl/[�f+���:��s��n������bBP"�9�	�:z��֋�kB۩�7� �Z��.���7.����K�h���/�KsOa�!�GF�`�>�\-BnL -�
x���n�1��y���ֵ�OȐ��s�z ��0O��Ѥ�ɔL�PPYAA�`�:��w�R7Sg��69'�ϟ�;��)T�6�͹e�0�iV�\�
-<���-�g������	�46&���
���M�0\֭V�T��,���d����L���<��S2�"i�8��`��hQ� Wȅ�M���y��`����b�1x<6j%0�yL�3�\��o��몙�g�:�'��-.߶�jԅ��Ę:l�R���ifIS`\q��ۂ���ic��(A��f�/��	���\��r�������.���%�Â�����}�<���p;�zO���������`$�i�'�:�Ģ�,� ''���i��YѲZ�,�\�������(WdU�p��ckhq:a�6��.ݰy{RN���ۓtnS,q���=��X�Vy�ڬYǛ:�j���M	.@�1�Cv_�� �p�y��1����EȘ��d���Ë��ۻ�:��t����F��6?��S�m��@�
<��my�B����o_�|�odc����RH.4pw��y��J��l8vL��4Ӆ��(7��wI���F��v='\��ѱ#9���L3D� 1�>�-3W���vg���#Mz����ec���ʶ��.��r�����`�|�g�Yl�²f[��c�ͺ�-�M��-�&Y�W�sr�`�8Ɛƭ�s����[	��^��^�e�m��7RK铧���1M�g�@L��wu1?=۝�dS��
;f��������o�s��l
nn�ׇa��Kx�&ûhe�����w;#l�z�b�tg�^ ����HB#�>Sm6Ծk݈) �pi�?Z*f���_���B9¦�y����W��]��ј 1o`�	��"��.ߝ����N��9\2�$�&Ƹt�T����U�{T/�Ӊ)�ʜ�
|j�������`YT����k��3���t�0H�H�=��Y�9y�����H��{]5m~���͘��Nk_����ZWw~�;k�&�z<HEمU��e�ڒc�]��(7^���TKd���%s|;�"�C0��l�`e��U�����}���7��D-�ૣ��߾�ɾ�XɪR(r�w{?�޷����W��%r@U>� �7�O3;�	�����j��>Ό{�������f��|��.x������b O���v`���K��q@\� - �	�2�z��a#^�˽~� ���_W^�~��@���<O3�����yt�³���"��5\h� f�)e�֋�U�1��&��eI��kb��%Z�P��7>.^ְ�����=�p����ϰ1�b4D����0���jF���A�8�+�f�6�8ݫ���q&9a�)���������������x�b����1�m-����B\I�:������j���)p[�4�8�?��<��:'����\�d�U6
3j�)����D������Ұ��PI�f��GӇ�����P�̲�������O���*Ƶ�9^���vJ�/\q��ͻ��$�7b�^�{�&-n��}����a���@�/�p`��Ρ,��)R�p妔1�lKȤP��Hú�ƦȻ��>>��i�1f����lV�Q�:�,�5��M��\KU�=�"�h�Jv���;��ۺ�p`Hk�n��C���%�5���Y�!°��gky,��:��߬�V}@����2�1�2&&/�k8xĤ���l��afՌWm���x�d�H�nz�	1ݤ:�7x��Fr[���iY��ٽ�gg'G簝����;k�֤����2R0�0�5�I/%zs�e�t��O�`���rr﯋�#�_���%���5��	i|B�+f���D������������ͺ�ޔ��&�Մ{���o����/1U|qv2���S�������J�H����-��0~|�y�'��]�a��++[��M��_�?�ֶ�u���� 6�k"�'Ū��C�ٯ	=B&�x=�1 ��媪Ϫ$J��<Xށ�C��a2<)�o�^�ov�Z&5C�!K�z1�����ĜV�>$�|�6%�'6���)��{��m|v*L�B(ZbzH=)~k��=DM�,D�s�ƹ�/��?��J9��"	b}���۽���k �,��
���$I)v����p=��YI�W07x��,�%#f����!��l����_�x~w�u������)���M����֖5Ygk��~b���ӚBb�g)�<i��u716���P}��T]�k�o�7?:9�Ŀ	[R�nT�d(dg8���r*��7T\E�YO\����i1u_p��m�m�~�&u_��%�
/t;���l<�zf�DV�rH���g�K�n}��}��XAՄ@��^I'>�w�� ��ɸ��r{t�b\�T:?ؓ�w�ٕn�K_W��ۧ��!a�l�uA$9y�	]C�~lN�ُ���K��cl�YAAc�a*B7�F�ׁ� ��*��2� �I*��܂����:	�δ�2�gR]�M%+�W�
OP���ȑ8������>���UGI��	y&a6Yye��l2�������#!D�y��9�V/l[�ɧtʧ��[�b�*�W,4똬j�8�	G�.�p�������F���]R���^5d�M�]g<zs3���Gf��!/��XdB)��m�������x1�o���q�$M��a�X�8�8J�D�+4�\8��!�Xd�`�cLk	q`[p�0�d���9q�Y�܅S�Y۩z��շq�8�B>�o�W�Wn�V��>f
Xi
��!Ӧ�@������ �	n:��?g3L%���_�?	#b:�ȵ���j�v�f���LWU2�J⠛���� y{���
h���wQ��<oIz⮈p�o%��:�tq����X���Fu$�M��Y�~��wA�P�    "�HX�B�
=���}l\�o
�DH\�<���p<�`q>޸�gT�]׻^`"�<[|��S���w�nڰ7�1�y"!�8>k��(sh�lu����	�����KQ�X&U�~����L�@���J�	� ���by�qӭ��B��� c;p����)�Fz��4>d��5>�� �]� ��c		n���~Sa�xD�i'7@�����t"1@c f���[� �����	��;ߩk�9��;:e�iI�7����(�;=:;�ZP�F:ŅD�m�9������e6S^����`[y!�9M��H�N'�b9N��i'�l1����]�F�q�A� ����I�h�9�� �� z���nK��<A>2�%$Ȼ(s��T������yǶ�H�I A�`V�4=g�ף�q[&~�bBf\g���[�'#&Y��L(C�1�r��h���/�T��d��/-��c�Oh�U��| 9��\�����Z`�8��3�zS���<R�v�J���p���zp������܉�6�6_��4dl�$" ��.��.�n���_���y�;$�d�b�E~��HIc�&�R8&�kv��}���*�];N�5���6e�OP�������+����	aYa�a�8ޥ�4��r����u�O���}�>-��CN�a��vZ�໑Qƚ�d�1�쵅7����ڣlG����7���j�p���Έ� �L_\Qg�c�j��j��ydHz�^tP�In���FlTA�-e��@Z+�l��پ�h!�A������.�ӻ����Gsr�F�̋:����� `�ιD��"�S�X�9����//�ڜ��VkF�������=�g'y�M6��7���AX�3��Z70�������8�n�gJM�x��	�8�r�.�8��
�w�p�G�� n<S��*0�Q��ƫ?|����L�Bʈ�r�xo������&b�@��&��Z�o���,���(u��6U��ɗ{�	)�Є�*�`�4P֖,p�1�rbw�x.-v5��/3�Y�Eg<���>_h�L���mk翭��Ȧ��I=s�kGP�Z�^��S�:�d��im�_�HG�x����ӊ�<鸥2��aS��U�u�M�:��T�i��cE�c+��Z������<Vװ�f���c��re���s#-[�r�1鬡�;,�����Ĕ1�p�.�Ū����xy�_�&�o��ib*�\yM��uR�Ji�;�Y�����3�Np��+��\5��J�����`��ryV�(-�������x.�����,��a��&�E6�6����0��(�$pO��Ӛ'r�|��N<tpS؁~�!a��z����=qx;��ڻ"j0Z\T��Sa9�9���Ѷwyp>}uG�n�5��Ś�� �kǜc�Tm>�ʐ���3�u��̈́͐6���p�Ol#[^N�JG������)���A���K�=NmD��$��D?�i��ħf����S'�F[��}7`����⤍3���'Q�qQ���:�:o�·�cO�	E�LZ����N�|�9�'�ɑD�����l���pK��P� �Pl�'�@�Q�n	��8h�%��Z�<�ßc���$]�?͠z2c��Ӄ�Ųks��+��!- @�e�-&A��蠟��AkRF�ѧ{q��l �l��i#������㯄G�'t��c0UZ5�H=
�,�É���&b�ʛ��U5�^���i��(P�/�w�Y�0�0���7��(����ыÓ���hW%κ�:�R�}�I�:0":�z�����W�a����ƈ���p7�������0#T;�U��֦#�9��"ԃ4�H�qb^�#����ǁ��?&ǅOh��ooE��N}�����N��޾�{�'���������c_���j�����&j>�H�S�n"9]����c������CJ�S�n8�Eo��g<;�+�&���J�5�f����X�|ZV���v���է�4��[��㪃��]d� ޯ(�=m�|T=
�Q� �i'��r����>�>�~�.���?��
��z�ρ�j�[E�=ճ6W]��~�V�pϲ���.N9�.5o�+R%~� ��Jt�}�#V�������,�\qD�+ZZ����1�I�oZ��X����7�L$�K���iǟݭ�|��(/)\qgG��W�<h��g'��qbՃ}%��m����!�ºH�SdY}S(ߐ N�{�8��'���1r ��/`����_�ݱ醉�
R{�bܚ��Z���A��H�K�%Y���G�YTp~�HlF�+:�z�$;���W���� ��4?����/�F'_`�w�o�ļ8�zD�j�x��\�ٞ�o�ܔXυ'Է���Kg���H9G�t[;{~m��U�%.���� ���/��ޘ����EZ�乷���`�*Ǩ��YrC���S!u�D)¿�KiD��P��8Ps�˷z�X�'E��(�1O7�Ni�4���A�4�u}��X��b,PN����s������>^Ld�p/�~�=ӣ��+aJ(v@; qJ!�X͠[��S���h�2=���} h&�>����&�R�ƝP�0k�$���:ޏrX���VY�|��q�N�*���%6Mzk[\�cy�|3wV��y2���:^<��s#��'u��i!!���fq��z N�I�a�9�%O�[I�S!G��^u33�;�}:����AX,tMwɒ���b& �*%�r#*�� ��N����t�<��2�����J�c��o�����J�[S���*��ã�uo��8�m�Ș�U��f9��L�FHM*�D׬�gM�������vu��?��g�j%�7���(6h%���D5��k����{����Υ��NB#φ4زPD18����C랄���ɒؘA��,]@�R�M�<b恄�@�#�"v9�#J	\��|��伶!���(�L@�K��o�*�����QА0��9���}kB�8��L��y�SiE/aXw�=<�Hb�`�m��o� �_�¦��)��MEG�Q��xw�f����QɉCz
���;yq<���j>�`��TA�R9�P92�,ɉ߬�|���js�/�}�4�]�������\ku�� �1׏�<y[Y���P�)C"�l|~-��c��kI2f;~쿝̕�����}1+%�]���q�i��K).)6}�Tp�x-A0�D#h��W���ٿ�9&���4���!�dF㐏-���*�̭YkJc3�}i/u�Q�nmJmmJ��)5��u��K���;���h؜n/����ZB�o��U2M�������9�Ö�F~t�=�M�%�;�0!�ܜR���a6�1���p��å��bjSb1�>ٳW� p9&�-��SWB���������)�N�o|FJ�i��.�G�w�ʘ/����d��ɇ����d�I������;d�Ҕ�n�yR�>OJ.��֨�<��<U#�7?Oϕ_vsE���.��=c�;9�������@Y6y[M �Lp5��m�ā��-ey��F��-�v'�z�S=b,��V"#��H�����AhR���SՉ����	Ѳ�*����c��CwR�T�Ҫ�/��L���]!�D�t��Z�[q ��J�ڐO�wJ3z#;|J�7�L��쩉�c��� f��S:��E�î�%MvJ�N_��ᔖ�F^T{J;$xuJI�A&rQ����5�:�|�*8�iVr�1积NFK�'��a�Xß���s�!�8"��Nm6�e<[��8⩄�eKA�S�6� l��enw(��u9	?��ǗyNfN^��jm��-؂2�8wj���,�gk�@�Y�(x�h��4D�`P�\7ؽ�nk�h���������������jgg�`"�4X�i�����ya�B���`�W�4���a#1�a�3?�,�'��=g�z�Dn�O2�2a!�@������`�yn 䀁�\�+D6y\V��xEX�2���䐁h�D�i',7l'J��@�)
DJ|�� �  	��i��Ǜ��43)`�"*0�ʷ��H��A$2���C|a���$�O65˞�|{ �����t$��*�������Xe�=����~��D�{@hP�Bi�@������mn�6�pBF,�� .\��W�Xi�M+�sz�ߣ9����	C�^�
q��� ���j��w���,p����*�1�d��s
'~8ĺ����C|p��$�m.���$Χa;�凅�#���d0뉴�ꡢ�qn�z6	_[˶�,���2a�d���<LEe�Br������lA�������y���«
�Ct�
����$8
��^�QP���;
=F�N��(d��YV���-e,x�1E#�Ԫ��1�'X!�K���c�iF�UF&�$�1ic�3WFS&�`�KʭoC{\��B�N�y1�3/y�({4/bҼL���A�H.60/$��a�E�epѼ���Y���닽vӬG�1�Nn{���/���z�����?�+�L˥M�3����z|Y�Qv�d�3�6'�"�'�w�~ ���ͱ�_#�]����!�:7�0ILQ����jt|��ĥD��&M���ՙ���y6VF�kL)�E��� �����d�7���19�+�"Z���!*�j� �3����`r�)_�R���.`���ImExh������,43��D"wO�;�j#*�-L����O_Q�WX���)(�i��a3��@�p�������V?�Oÿ��L����{���5�'�=��?���v���-0ڝ��x!,���2��5�d�C!��O· �Q�hw�Rr�xnwFn�`wzJB۝�.k��dW�Ddcӯ��ΐr��ݑ����M�N*H�>�_Ӻa3Jv'vp_fƇ�"z������h��9��CJ��Cd���4��"�^�V���� x<Dn��O&����
�4p��^������H-V�]|N��P��-0��&/oJ�Asy�ӗ�����d��0PMMT�T�a���C���m���!�G<��N��ޥ)��B)�۝�o��|�Y�y �h��p؟�j:������(w<0vp�쭾>���k�)�]��c�N;����h��W{�Q�xx���������)���CL�l�����T���J�ۺ&�/h'0{)x�F�G�66p!	�������'�_n�n�A�=�z�����7_G�e�����O��ӛO_'X�p��)+����Љ
7�&'j��\?J����a���cf&��^��L�1D��� +c3D�J��8�OTM��`Od~}O)�˖��f�#��l��h��p�>?� �%��L	�<����+I�� IR $�����S1��������4��H*&�2p�d�بvB�ږ	�w'��Q�x����,����ezN8A�^p4��D� �(���<]^,�;pd�آ������s�R^�i��"l���&:u�j��3�<�ʁW�j"7,��X%�rB?q[��9��q���x��ρ���Z�[��[��M��k�w��p���!"��nٱ�����%��=M!*"^C�$qZl��X�>���͠�O�@�N:�2�0���c�8a�[&*G��^�fv��������\�H��n��KUB3���)�B��>@�n18�w�z�[�b8�M�R�g��i"���3�}g~7a� �����j(, 6�%�5��jȗ�a�_{�J�zxu�'o��7�~A_�@�1�q��ӕ!�8
9CC|1�+�X��~���2��d��\*E�Ѣ�����+;|bכ�E�.)�ɮ'Q��MZ�)�~�w}�7ɻm�$�T�Y��]+���H�#,���~�5���D��w��G�&Ž�`Lׁh�]�7�ɟ�$!�6��萚$Ԅ5=�I)�vQu8������وI`r{�ް�LRx��k��?�?��z      �      x������ � �      �   �   x�e�Q�0D��S�	����g�L��]�Ʋ%K!r{������f�E�IOaF�T�ғd�>a�ohh7����a$u�h.J�3�̉T����a�,cv�H�mR27}�*y♂k5�%|��:I���^�L*aL�z��ߖ��r���i�JK���xsF����>	-ߎ��q�3o�͑�콲־ Ƀt8      �   ,   x�3�tK,�U�MM�H��,N,����2��J�rS22�b���� ��      �   5   x�3��/-JMNU0�2������lc.8ۄ��6�2��͸��ls�=... �{�      �   �   x�]�K
�0���=��
�7m�ґ�%��B��~Ӂ���|p�����~������F�3�l}�P/����p,�L� �G/j�P� �p`b��)���-&?����嫎4�%Dէ��!��q?� hhQj      �   /   x��J�I��L���􂱸��r�sS�3���Ē��<N7_�=... �x�      �   3   x�3�I�PHK-I�PH+��U�,I͍/(�LN��M,P(IL�I����� E�      �      x����n[ǖ������P�pg&l'�r���8@A�"-�H*i���+�&7iߝ ��UUk������w��W��&x��)�S�Me��0��r�_��9U#sm��ڋ�ٹ^��훺�����_���o��x7_�w��^�������s�{��s�������a��}�����en���f�¾|���ϋ��l��j���_��������۹�����_�gK�O��~{�����\����/gK���ߋ9g�vЁse��������x��-�����~�����as���-�o/߾����Ì�]���; ����j�v���GP��k�����|����ۗ�R�o�i��Ō����-�:c�w�ٛ��|����}�p�߿���v`�|��j��oon_����?�x���h8��'�LY88�,
�O�C���uAsu6esx.��ņg�/1�v�
<����;����<���"�<��*��@�E�y��u�U�U���u�����s��u��H�:�\T~wNY�E��4�U�Y���2Sׁ�b�/�o6y-zt>�|xFiyFc�E���U��'Q�]O��2��[���Mٮ�鲵j�)5o�n:x�B^I]��!�l�S>��Kƻ`��_wF}��mS��o�:���a��a��?Y�)|�R*+mJV�]Ͼ�f�1*e��c�9�'��Q��Tj��rZ�>m6�rS�v=F6m�wl<�jrrBWST��8��7]TN#mL5��Y�F�z024�9�>-��t�6e��7�w�5t�"(�թj�L��Qe�5Io���*H�{�_JPև�+�׸O�l��Oi������ԕ���8B�l˂��_ �!Z�6v��8�o^[�O9J�}ڤ?�C+�ݪ������#��R��+�-u�:q�"l誖f�h1�(�)�uc��X[��E���p�uT�se��W�Z�:�e�j֋"g]�U�8�r�����ԅt�����i�=$�$z�:
���~�SRi�rڞ$��M�,������-��Fі�?G_����o�Zo���]�����(�Ĉ�����$ъ4���+-��s�(��9�t&x��i&����pO&͔��6�i��۬؟�B!l���'oو�Ktv�|	LJ�t��wZ���&H��hzY-�[�>�J�
-��5T�K��J�f]�xaY�v�u[�]���q�ڷ��Ӊ��Eר�]@}����9��=��z{uZ����EB?Wa}�o74�}��'6��o"UE���P��uI�VZ��r���LԄ��-E��J�9��.ݧ�2=��m^=4��M֑^�(����}U�z�Η����
E�]���dL�����>��K��t�N�զ��d‥D��PL�1R���@��I�=Kc�-��f7Z2������~�^���/w�CL����O`al�@|��l�/Bs�v�S�^�5�g�T�dB3��pE�n׭p���x�N�>�>�X�fD/k趩���Vkv��" �̌��fF����&/��Gγkm����d�2��gs%d��˨�Z1--�V�H���Rt�4�N�K��.��'{��ZnҦNgI�f��[�#��Q9�Е�`)%9�*����!��J�է��		'�v��lK����pT+��)����!�ЅNv���q�՞c����q�������z
 0@�^���k�����F7^��e���yI#��cT��M��l1���A#����H�:z@�P�@�ޤm�a�ag"!zX�kD���q½���\�ꔻ���@�RX��@�4����C��*I�h�qʂDh�D˴K��=t�T��꽲C[`�T��@��&�&B��H�R��W<�
s:�C~H�����ˡ��=ec��{&5�����d�C�E�h�6�aP[�?��$̜{i���y��iPkU��A6��v*[a3ՅW���6/�)a<pE�*�g���}8��_��C��;����=��1e�Z$~b�*"�Ӌ�n*G����)K��c��!��8��c?����~��m�;0����Y�Q�߂���G�ӕ�b�
�ESYւ
��� DT�AMH��_��|��6`�����4�S6a(��l���[*�hA�(NН2FՓ��E�X�4 ����<ȤnTtY�?K5�%��WM뒢�<�b�ʁ����3hӋC��NvX�u�em�BB|�E� @�)���Y@q���I�r�l��R�Ju���ڤ�0�n�T5d�h55�GnJcD�D��ʯ5:Y��Q�Y�Ig6#"hVN��!�%�갼��fGv��Yh�J�ZЉ���̸;�ԁ�(�B�
���b��	v�I�ѧv�M����a��J�3�Mu�np�1Jm�V�rF�	�hA'bhd<��3��7���T�<�u �BT�`b!�50:�J��v(-ꔝFZ^0�@a��z���E/�j.E~�8�n[���&#�	��(�ZV� j�5s�FWǡ*Z���]����H��)l��ߖ�gea�s�D#y5��Mg���6�8�Τ�pޭ>�gJ(Z���(]8�t)�����CC�L�Ԑ-h�胢kAt����y"��x16�ڶ!�0l�C��\'���9D  @�����`��<�,�����:i��xĄ#!�:q1���̰DYh�Q��Td��l/j����[ ��	W���Y%N �H^��I<��ly�T������9A���9M��lK�Pǐ�΀��TBz��D���@��+���r���L3B���5�;<��D�VLP9_1<el�>�!�ǧ�90�N)�x�(/����A�|���6������g���%{C9�۪���{T�������,b�A�� ��O@�ŀ�\��"茘9S`������t}D�X���|#F��Ib��Vt1�`mQY�ߌ����!O�"���cZ<��28U�QUS�����㷝�!�q�[U�	g7u]�c�pOWЇ�1��0n"Dtc����Z��M���f��ӎfݒJ\Nh��ƶ���C�@��E��҉8�B�I����T4��!$n����{��kK����	G�)�� 51n`"�fȤ�P�Ev0j86��QjI�~���mm�Mo����r��˩0)&��/ʡ| wb�Jxav�w�ҰoX�/��?jb:�C+�ϜD�n�༯%�l�[�D6�Z�k���#��$��<�Փ4c��Pf�?Q��������],���� ��,��q2��Z��ր�)��wJx$H��H�z��6��M*eD(v�����hL3�TQ�j�$�D���'�m2f��]� �9�^�&N�������91�NҺS�h]�m�(ֵSQ�F��Y+k�D5!�B�hG���ZSDg����&`L>~�>w���\,�Ga	�ƍt]W�E�-vʑA�;���D�E��I,v\᧢*j`�� -�(��jw���$-P�u�椌NmI@�M�!�CX�x��6u�>]bTT�ťVL+j��	[������"�p�K1_�!B���z���� Cʑ�R���D�ͳ�J�q�iǝjF���piZ#\��kO��-��i�/�ڎ�[=������K�򇁉�u;�PE�9��jvH��T���w�sa��<U��a��KS��v��y��.*Ka1^C��LE���F5Y�1!�]�U{@��OkO�{�=�+�?���Z�!���W�2OAz�5�Q�va��I)�#��pK ��C<�(�������F�B<�'���_^ε���!�?�v���e�0�.X�Xb�qA�m��9�Fi�k'���X�
zC�ӓ@�g�aV�(�����fM�������Ȥ�Kk���[F�;ۓ���@��~�E/�3H�
�Fs�������S�������a{?�ps�,��	]��^>�F�[�@��)������A1�@Xe��H�l	��
��QV�;�(���dU'a8�J�9_������V!�p�X�� Ό�˚�١�X�Q�����ƮE9�tgd�aχI;,W7��aze&��n��\�n8?j+�:X
G��T� -0��K N�vZ����:�N�����Z� u  nzT&}eT2Z��_k�j�X�=���N������|�x�f���x�v�旛~}����q�9��
�`�-B��b|��X�CW�?�ּ������u�[�Cť	ȘT�l���P)������<.��r�d�D�&����?�WV�jያ�h�`������<ӆY-�����h�1"�漏k�`ʸ"o_��O����`�*�Н�J��.�j|��}�� ,`��Ue>����i'��WG���i����pԪ:viK%4J-˙����f9P��DJ#���ǌ~bŻ�ޏދ�-[�� DB:\��?Ơ�����P�HҮ��}B٣?	7��}�ۇO���A�2.T���(ԇC�dR��%�����i��*kS��a��<e�(A6DV�;�o�nbk�!��FTk Ur�Tk�R�������L]ʪ�T$�4y)8|d�W_y�r�uZqrܖ��5�\`��f�L��uS��A�6 #bu����O���i��C{6��Q#K9�*��	^�v��X?<�8>6�1=&��r�.cs|���ܹ��^j @t�8F ��P �d�ݤ���ߏ�hәi��R�M?�L>��7�wZ���Q����~�o�2�"���#T�j��}zr�_�������S$�a�.*���T��\������i��o��� �J��1"r{h��V����ꊇ@�x��3����x�v��Ӎ����aM��GD�����9	U,>��x��W~�@[r!�N�f�h3h-��^��˙�����i�������CE��臽�5�!B�~�j�Ns�������8ո�����R�}zh��w������8~�qL܀z,� �T�ZA-B`�*�;��Mʜ ��!�>��;*)�#H�`��3&_��D�%@)du|��. �R��9n*`z���v�������~��q��a�J>�[Xz�#L4��kO��k��@ {@>�D��i�]�p���~�T�͟Em�Ǿ�L
�ٌ�SG�d }<���ͧ��m�v���dR��;��o���6�.H��?P=D[)IH\]*L'�V�;(�[%��d1��+ް�y��'�i��慨 2J0�é��Y醦:1��+yl2�8A�4{#$k��on���d��8RG&#p �imDN=�_E�[�P/�֑&%O4����q?<m�]�M���~�W�B��>��B�؈����DQ)п4ڀ���$�pH���I��fU���O��k/z%H)��U���$���m|)�N�i9	�����$�wۏ�?��|���
��3��E��g9R��u�G�(C/x��;85�'[׹�/t.�X�eys�C/.4:%W�m���u����=��%ב*hGݪ@�2��9�w���c�/_?NL�q�B���g�_��00^J R��r����P���p�mo��6�"yG\���4*�1|~<����ޙn�7�N� ��!�"��,W�{�´��&��ErZ��LL�F-%�T�_����E2Iu���n��=#���ۧ��{g,�4��B���B6�b���T��>��!8�hjU��l���@/�~�`M��I���]�=�_5�G��i�x���F�QF�~	&����=8ɛ�<>�JW�v��D�*��q�6����^�
��
f�����i�&��g,zH��O�>�Y���.$3�S4�W6��`	�y����xw� �Z��|����1k�8Du~FDgn�?.�xE�����-�$ ��@#���^�W�{C�q�h��WlYd,���]:>��|�Sq0�l��5_��Z��;�@$\S���6���+&�n|xr~3I�����Q����h��V=� Si����/J�7���:

�I���~¦�����o�IT,     