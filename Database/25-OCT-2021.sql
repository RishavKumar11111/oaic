PGDMP             	        	    y            oaic    13.2    13.3 <              0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    28636    oaic    DATABASE     O   CREATE DATABASE oaic WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'C';
    DROP DATABASE oaic;
                postgres    false                        1255    28637    UpdateAccountantAddress()    FUNCTION       CREATE FUNCTION public."UpdateAccountantAddress"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."acc_master"
	SET "acc_address"=NEW."dm_address", "UpdateOn"=CURRENT_DATE, "UpdateBy"=NEW."UpdateBy"
	WHERE "dist_id"=NEW."dist_id";
	
	RETURN NULL;
END;
$$;
 2   DROP FUNCTION public."UpdateAccountantAddress"();
       public          postgres    false            !           1255    28638    UpdateDeliveredQuantity()    FUNCTION     �  CREATE FUNCTION public."UpdateDeliveredQuantity"() RETURNS trigger
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
       public          postgres    false            "           1255    28639    create_po_no()    FUNCTION       CREATE FUNCTION public.create_po_no() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	--NEW."PONo"= (SELECT "DistCode" FROM dist_master WHERE dist_id=NEW."DistrictID") || '/PO/' || NEW."FinYear" ||'/' || nextval('po_no_increment');
	RETURN NEW;
END
$$;
 %   DROP FUNCTION public.create_po_no();
       public          postgres    false            #           1255    28640    update_invoice_number()    FUNCTION     R  CREATE FUNCTION public.update_invoice_number() RETURNS trigger
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
       public          postgres    false            $           1255    28641    update_mrr_id()    FUNCTION     �  CREATE FUNCTION public.update_mrr_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."POMaster"
	SET "MRRID"=NEW."MRRNo",
	"IsReceived"='true'
	WHERE "PONo"=NEW."PONo" AND 
	"OrderReferenceNo" = NEW."OrderReferenceNo";
	
	UPDATE public."InvoiceMaster"
	SET "ReceivedDate"='NOW()',
	"IsReceived"='true',
	"MRRNo"=NEW."MRRNo"
	WHERE 
	"InvoiceNo"=NEW."InvoiceNo" AND
	"PONo"=NEW."PONo" AND 
	"OrderReferenceNo" = NEW."OrderReferenceNo";
	RETURN NULL;
END
$$;
 &   DROP FUNCTION public.update_mrr_id();
       public          postgres    false            %           1255    28642    update_order_po_intiate()    FUNCTION     �   CREATE FUNCTION public.update_order_po_intiate() RETURNS trigger
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
       public          postgres    false            �            1259    28643    CustomerBankAccount    TABLE     :  CREATE TABLE public."CustomerBankAccount" (
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
       public         heap    postgres    false            �            1259    28649    CustomerBankAccount_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerBankAccount_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CustomerBankAccount_id_seq";
       public          postgres    false    200                        0    0    CustomerBankAccount_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."CustomerBankAccount_id_seq" OWNED BY public."CustomerBankAccount".id;
          public          postgres    false    201            �            1259    28651    CustomerContactPerson    TABLE     �  CREATE TABLE public."CustomerContactPerson" (
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
       public         heap    postgres    false            �            1259    28657    CustomerContactPerson_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerContactPerson_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."CustomerContactPerson_id_seq";
       public          postgres    false    202            !           0    0    CustomerContactPerson_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."CustomerContactPerson_id_seq" OWNED BY public."CustomerContactPerson".id;
          public          postgres    false    203            �            1259    28659    CustomerDistrictMapping    TABLE     �   CREATE TABLE public."CustomerDistrictMapping" (
    "CustomerID" character varying(255) NOT NULL,
    "DistrictID" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL
);
 -   DROP TABLE public."CustomerDistrictMapping";
       public         heap    postgres    false            �            1259    28665    CustomerInvoiceMaster    TABLE     n  CREATE TABLE public."CustomerInvoiceMaster" (
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
    "PackageSize" character varying,
    "PackageUnitOfMeasurement" character varying,
    "PackageQuantity" integer,
    "ItemQuantity" integer,
    "TaxRate" integer,
    "RatePerUnit" numeric(20,2),
    "PurchaseInvoiceValue" numeric(20,2),
    "PurchaseTaxableValue" numeric(20,2),
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
    "UnitOfMeasurement" character varying
);
 +   DROP TABLE public."CustomerInvoiceMaster";
       public         heap    postgres    false            �            1259    28671    DivisionMaster    TABLE     �   CREATE TABLE public."DivisionMaster" (
    "DivisionID" character varying(255) NOT NULL,
    "DivisionName" character varying(255) NOT NULL
);
 $   DROP TABLE public."DivisionMaster";
       public         heap    postgres    false                       1259    29308    CustomerInvoiceViews    VIEW     
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
       public          postgres    false    205    205    205    205    205    206    206    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205            �            1259    28697    customer_id_increment    SEQUENCE     ~   CREATE SEQUENCE public.customer_id_increment
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.customer_id_increment;
       public          postgres    false            �            1259    28699    CustomerMaster    TABLE     /  CREATE TABLE public."CustomerMaster" (
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
       public         heap    postgres    false    208            �            1259    28706    CustomerMaster_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerMaster_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."CustomerMaster_id_seq";
       public          postgres    false    209            "           0    0    CustomerMaster_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."CustomerMaster_id_seq" OWNED BY public."CustomerMaster".id;
          public          postgres    false    210            �            1259    28708    CustomerPrincipalPlace    TABLE     �  CREATE TABLE public."CustomerPrincipalPlace" (
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
       public         heap    postgres    false            �            1259    28714    CustomerPrincipalPlace_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerPrincipalPlace_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public."CustomerPrincipalPlace_id_seq";
       public          postgres    false    211            #           0    0    CustomerPrincipalPlace_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public."CustomerPrincipalPlace_id_seq" OWNED BY public."CustomerPrincipalPlace".id;
          public          postgres    false    212            �            1259    28716    InvoiceMaster    TABLE     *  CREATE TABLE public."InvoiceMaster" (
    "InvoiceNo" character varying(255) NOT NULL,
    "PONo" character varying(255) NOT NULL,
    "OrderReferenceNo" character varying(255) NOT NULL,
    "WayBillNo" character varying(255),
    "WayBillDate" character varying(255),
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
    "InvoiceDate" timestamp without time zone,
    "IsReceived" boolean,
    "ReceivedDate" timestamp without time zone,
    "EngineNumber" character varying,
    "ChassicNumber" character varying,
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
       public         heap    postgres    false            �            1259    28724    ItemPackageMaster    TABLE     7  CREATE TABLE public."ItemPackageMaster" (
    "DivisionID" character varying(255) NOT NULL,
    "Implement" character varying(255) NOT NULL,
    "Make" character varying(255) NOT NULL,
    "Model" character varying(255) NOT NULL,
    "PackageSize" character varying(255) NOT NULL,
    "UnitOfMeasurement" character varying(255),
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
       public         heap    postgres    false            �            1259    28730    ItemPackageSizeMaster    TABLE     s   CREATE TABLE public."ItemPackageSizeMaster" (
    id integer NOT NULL,
    "PackageSize" character varying(255)
);
 +   DROP TABLE public."ItemPackageSizeMaster";
       public         heap    postgres    false            �            1259    28733    ItemPackageSizeMaster_id_seq    SEQUENCE     �   CREATE SEQUENCE public."ItemPackageSizeMaster_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."ItemPackageSizeMaster_id_seq";
       public          postgres    false    215            $           0    0    ItemPackageSizeMaster_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."ItemPackageSizeMaster_id_seq" OWNED BY public."ItemPackageSizeMaster".id;
          public          postgres    false    216            �            1259    28735 	   MRRMaster    TABLE     U  CREATE TABLE public."MRRMaster" (
    "MRRNo" character varying(255) NOT NULL,
    "InvoiceNo" character varying(255) NOT NULL,
    "PONo" character varying(255) NOT NULL,
    "OrderReferenceNo" character varying(255) NOT NULL,
    "FinYear" character varying(255) NOT NULL,
    "ItemQuantity" integer,
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
    "MRRAmount" character varying,
    "NoOfItemReceived" character varying,
    "ReceivedQuantity" integer
);
    DROP TABLE public."MRRMaster";
       public         heap    postgres    false            �            1259    28677    POMaster    TABLE     r  CREATE TABLE public."POMaster" (
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
    "PurchaseInvoiceValue" numeric(20,2),
    "PurchaseTaxableValue" numeric(20,2),
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
    "PackageSize" character varying,
    "PackageUnitOfMeasurement" character varying,
    "RatePerUnit" numeric(20,2),
    "PackageQuantity" character varying,
    "DeliveredQuantity" character varying,
    "PendingQuantity" character varying
);
    DROP TABLE public."POMaster";
       public         heap    postgres    false            �            1259    28742    MRRViews    VIEW     �  CREATE VIEW public."MRRViews" AS
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
       public          postgres    false    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    206    206    207    207    207    207    207    217    217    217    217    217    217    217    217    217    217    217    217    217    217    217    217    217    217    213    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207            �            1259    28747    id_increment    SEQUENCE     u   CREATE SEQUENCE public.id_increment
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.id_increment;
       public          postgres    false            �            1259    28749    NonSubsidyPODetails    TABLE     d  CREATE TABLE public."NonSubsidyPODetails" (
    id integer NOT NULL,
    "OrderReferenceNo" character varying(255) DEFAULT ('ORN'::text || nextval('public.id_increment'::regclass)),
    "PONo" character varying(255) NOT NULL,
    "DivisionID" character varying(255),
    "Implement" character varying(255),
    "Make" character varying(255),
    "Model" character varying(255),
    "CustomerID" character varying(255),
    "OrderReferenceNumber" character varying(255),
    "UnitOfMeasurement" character varying(255),
    "HSN" character varying(255),
    "TaxRate" integer,
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
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255),
    "IsReceived" boolean,
    "IsDeliveredToCustomer" boolean
);
 )   DROP TABLE public."NonSubsidyPODetails";
       public         heap    postgres    false    219            �            1259    28757    NonSubsidyPODetails_id_seq    SEQUENCE     �   CREATE SEQUENCE public."NonSubsidyPODetails_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."NonSubsidyPODetails_id_seq";
       public          postgres    false    220            %           0    0    NonSubsidyPODetails_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."NonSubsidyPODetails_id_seq" OWNED BY public."NonSubsidyPODetails".id;
          public          postgres    false    221            �            1259    28759    StateMaster    TABLE     y   CREATE TABLE public."StateMaster" (
    "StateCode" integer NOT NULL,
    "StateName" character varying(255) NOT NULL
);
 !   DROP TABLE public."StateMaster";
       public         heap    postgres    false                       1259    29323    StockMaster    VIEW     Q  CREATE VIEW public."StockMaster" AS
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
       public          postgres    false    286    286    286    286    286    286    286    286    218    218    218    218    218    218    218    218    218    218            �            1259    28767    approval    TABLE     H  CREATE TABLE public.approval (
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
       public         heap    postgres    false            �            1259    28773    approval_desc    TABLE     �   CREATE TABLE public.approval_desc (
    approval_id character varying(30) NOT NULL,
    permit_no character varying(50) NOT NULL,
    serial integer NOT NULL,
    mrr_id character varying
);
 !   DROP TABLE public.approval_desc;
       public         heap    postgres    false            �            1259    28779    item_price_map_1    TABLE     �  CREATE TABLE public.item_price_map_1 (
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
    "InsertedDate" timestamp without time zone,
    "InsertedBy" character varying,
    "UpdatedDate" timestamp without time zone,
    "UpdatedBy" character varying,
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
    "DivisionID" character varying
);
 $   DROP TABLE public.item_price_map_1;
       public         heap    postgres    false            �            1259    28785    mrr_desc    TABLE     z   CREATE TABLE public.mrr_desc (
    mrr_id character varying(30) NOT NULL,
    permit_no character varying(40) NOT NULL
);
    DROP TABLE public.mrr_desc;
       public         heap    postgres    false            �            1259    28788    orders    TABLE     �  CREATE TABLE public.orders (
    permit_no character varying(50) NOT NULL,
    permit_issue_date timestamp without time zone,
    permit_validity timestamp without time zone,
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
    permit_validity_1 character varying(30),
    permit_issue_date_1 character varying(30),
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
       public         heap    postgres    false            �            1259    28794    VDF    VIEW     �  CREATE VIEW public."VDF" AS
 SELECT ap.sl_no,
    ap.invoice_no,
    ap.fin_year,
    ap.dist_id,
    ap.dl_id,
    ap.status,
    ap.approval_id,
    ap.indent_no,
    ap.approval_date,
    ap.ammount,
    ap.transaction_id,
    ap.deduction_amount,
    ap.pay_now_amount,
    ap.payment_status,
    ap.remark,
    ap.dl_remark,
    ap.paid_amount,
    ap.pp_id,
    ap.pp_status,
    ap.dm_approved_on,
    ap.bank_approved_on,
    ap.items,
    ord.permit_no,
    f."Implement" AS implement,
    f."Make" AS make,
    f."Model" AS model,
    f.p_taxable_value,
    f.p_cgst_6,
    f.p_sgst_6,
    f.p_cgst_1,
    f.p_sgst_1,
    f.p_invoice_value,
    f.s_taxable_value,
    f.s_cgst_6,
    f.s_sgst_6,
    f.s_invoice_value,
    f.p_igst_12,
    f.s_igst_12,
    f.add_date,
    f.update_date,
    f."InsertedDate",
    f."InsertedBy",
    f."UpdatedDate",
    f."UpdatedBy",
    f."Division",
    f."HSN",
    f."UnitOfMeasurement",
    f."GSTApplicability",
    f."Taxability",
    f."TaxRate",
    f."PurchaseInvoiceValue",
    f."PurchaseTaxableValue",
    f."PurchaseCGST",
    f."PurchaseSGST",
    f."PurchaseIGST",
    f."PurchaseSGSTOnePercent",
    f."PurchaseCGSTOnePercent",
    f."SellCGST",
    f."SellSGST",
    f."SellIGST",
    f."SellInvoiceValue",
    f."SellTaxableValue",
    g.mrr_id
   FROM ((((public.approval ap
     JOIN public.approval_desc apd ON (((apd.approval_id)::text = (ap.approval_id)::text)))
     JOIN public.orders ord ON (((ord.permit_no)::text = (apd.permit_no)::text)))
     LEFT JOIN public.item_price_map_1 f ON ((((f."Implement")::text = (ord.implement)::text) AND ((f."Make")::text = (ord.make)::text) AND ((f."Model")::text = (ord.model)::text))))
     LEFT JOIN public.mrr_desc g ON (((g.permit_no)::text = (apd.permit_no)::text)));
    DROP VIEW public."VDF";
       public          postgres    false    223    225    225    225    225    225    225    225    225    225    225    227    227    227    227    226    226    225    225    225    225    225    225    225    225    225    223    223    223    225    225    225    223    223    223    225    225    225    225    223    223    223    225    225    225    225    223    223    223    225    225    225    225    223    223    223    225    225    225    225    223    223    223    225    224    224    223    223    223            �            1259    28799    VendorBankAccount    TABLE     j  CREATE TABLE public."VendorBankAccount" (
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
       public         heap    postgres    false            �            1259    28805 #   VendorBankAccount_BankAccountID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorBankAccount_BankAccountID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public."VendorBankAccount_BankAccountID_seq";
       public          postgres    false    229            &           0    0 #   VendorBankAccount_BankAccountID_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public."VendorBankAccount_BankAccountID_seq" OWNED BY public."VendorBankAccount"."BankAccountID";
          public          postgres    false    230            �            1259    28807    VendorContactPerson    TABLE     �  CREATE TABLE public."VendorContactPerson" (
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
       public         heap    postgres    false            �            1259    28813 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorContactPerson_ContactPersonID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 @   DROP SEQUENCE public."VendorContactPerson_ContactPersonID_seq";
       public          postgres    false    231            '           0    0 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE public."VendorContactPerson_ContactPersonID_seq" OWNED BY public."VendorContactPerson"."ContactPersonID";
          public          postgres    false    232            �            1259    28815    VendorDistrictMapping    TABLE     �   CREATE TABLE public."VendorDistrictMapping" (
    "VendorID" character varying(255) NOT NULL,
    "DistrictID" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL
);
 +   DROP TABLE public."VendorDistrictMapping";
       public         heap    postgres    false            �            1259    28821    VendorMaster    TABLE       CREATE TABLE public."VendorMaster" (
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
    "Password" character varying,
    "Turnover1" character varying,
    "Turnover2" character varying,
    "Turnover3" character varying
);
 "   DROP TABLE public."VendorMaster";
       public         heap    postgres    false            �            1259    28830    VendorPrincipalPlace    TABLE     �  CREATE TABLE public."VendorPrincipalPlace" (
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
       public         heap    postgres    false            �            1259    28836 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 B   DROP SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq";
       public          postgres    false    235            (           0    0 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq" OWNED BY public."VendorPrincipalPlace"."PrincipalPlaceID";
          public          postgres    false    236            �            1259    28838    VendorServices    TABLE     �   CREATE TABLE public."VendorServices" (
    "VendorID" character varying(255) NOT NULL,
    "Service" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255) NOT NULL
);
 $   DROP TABLE public."VendorServices";
       public         heap    postgres    false            �            1259    28844 
   acc_master    TABLE     b  CREATE TABLE public.acc_master (
    acc_name character varying(30),
    acc_id character varying(30) NOT NULL,
    dist_id character varying(2) NOT NULL,
    dist_name character varying(30),
    acc_address character varying(1000),
    acc_mobile_no character varying(15),
    "UpdateOn" timestamp without time zone,
    "UpdateBy" character varying
);
    DROP TABLE public.acc_master;
       public         heap    postgres    false            �            1259    28850    approval_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.approval_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.approval_desc_serial_seq;
       public          postgres    false    224            )           0    0    approval_desc_serial_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.approval_desc_serial_seq OWNED BY public.approval_desc.serial;
          public          postgres    false    239            �            1259    28852    approval_status_desc    TABLE     ~   CREATE TABLE public.approval_status_desc (
    status_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
 (   DROP TABLE public.approval_status_desc;
       public         heap    postgres    false            �            1259    28855 
   components    TABLE     �   CREATE TABLE public.components (
    comp_id character varying(10) NOT NULL,
    schema_id character varying(10),
    comp_name character varying(30)
);
    DROP TABLE public.components;
       public         heap    postgres    false            �            1259    28858    dept_expenditure_payment_desc    TABLE     �  CREATE TABLE public.dept_expenditure_payment_desc (
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
       public         heap    postgres    false            �            1259    28861    govt_share_config    TABLE     �   CREATE TABLE public.govt_share_config (
    sl integer NOT NULL,
    fin_year character varying(10),
    head character varying(30),
    govt_share_ammount integer
);
 %   DROP TABLE public.govt_share_config;
       public         heap    postgres    false            �            1259    28864    dept_money_config_sl_seq    SEQUENCE     �   CREATE SEQUENCE public.dept_money_config_sl_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.dept_money_config_sl_seq;
       public          postgres    false    243            *           0    0    dept_money_config_sl_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.dept_money_config_sl_seq OWNED BY public.govt_share_config.sl;
          public          postgres    false    244            �            1259    28866    dist_dealer_mapping    TABLE     �   CREATE TABLE public.dist_dealer_mapping (
    fin_year character varying(10) NOT NULL,
    dl_id character varying(30) NOT NULL,
    dist_id character varying(2) NOT NULL
);
 '   DROP TABLE public.dist_dealer_mapping;
       public         heap    postgres    false            �            1259    28869    dist_master    TABLE     �   CREATE TABLE public.dist_master (
    dist_id character varying(2) NOT NULL,
    dist_name character varying(20),
    "DistCode" character varying
);
    DROP TABLE public.dist_master;
       public         heap    postgres    false            �            1259    28875    dl_item_map    TABLE     �   CREATE TABLE public.dl_item_map (
    fin_year character varying(10) NOT NULL,
    dl_id character varying(30) NOT NULL,
    implement character varying(50) NOT NULL,
    make character varying(100) NOT NULL,
    model character varying(200)
);
    DROP TABLE public.dl_item_map;
       public         heap    postgres    false            �            1259    28878    dl_item_map_1_old    TABLE     /  CREATE TABLE public.dl_item_map_1_old (
    fin_year character varying(10) NOT NULL,
    dl_id character varying(10) NOT NULL,
    implement character varying(70) NOT NULL,
    make character varying(70) NOT NULL,
    model character varying(70) NOT NULL,
    model_id character varying(70) NOT NULL
);
 %   DROP TABLE public.dl_item_map_1_old;
       public         heap    postgres    false            �            1259    28881 	   dl_master    TABLE     |  CREATE TABLE public.dl_master (
    dl_id character varying(255) NOT NULL,
    dl_name character varying(255),
    bank_name character varying(255),
    dl_ac_no character varying(255),
    dl_mobile_no character varying(255),
    dl_email character varying(255),
    dl_address character varying(255),
    add_date timestamp with time zone,
    modify_date timestamp with time zone,
    dl_ifsc_code character varying(255),
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
    "Password" character varying(255),
    "ApprovalStatus" character varying(255),
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255),
    "IsDeleted" boolean,
    "ApproveOrRejectDate" timestamp with time zone,
    "ApproveOrRejectBy" character varying(255),
    "WhetherSSIUnit" character varying(255),
    "WhetherMSME" character varying(255),
    "SSIUnitRegistrationCertificate" character varying(255),
    "MSMECertificate" character varying(255),
    "CoreBussinessActivity" character varying(255) NOT NULL
);
    DROP TABLE public.dl_master;
       public         heap    postgres    false            �            1259    28887    dl_master_old    TABLE     �  CREATE TABLE public.dl_master_old (
    dl_id character varying(20) NOT NULL,
    dl_name character varying(70),
    bank_name character varying(100),
    dl_ac_no character varying(30),
    dl_ifsc_code character varying(30),
    dl_mobile_no character varying(20),
    dl_email character varying(100),
    dl_address character varying(200),
    add_date date,
    modify_date date
);
 !   DROP TABLE public.dl_master_old;
       public         heap    postgres    false            �            1259    28893 	   dm_master    TABLE       CREATE TABLE public.dm_master (
    dist_id character varying(2) NOT NULL,
    dist_name character varying(30),
    dm_id character varying(30) NOT NULL,
    dm_name character varying(50),
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
    DROP TABLE public.dm_master;
       public         heap    postgres    false            �            1259    28899    farmer_receipt    TABLE     J  CREATE TABLE public.farmer_receipt (
    sl_no integer NOT NULL,
    receipt_no character varying(30) NOT NULL,
    fin_year character varying(10),
    farmer_name character varying(30),
    farmer_id character varying(30),
    full_ammount character varying(30),
    permit_no character varying(50),
    implement character varying(30),
    payment_mode character varying(30),
    payment_no character varying(50),
    source_bank character varying(30),
    date timestamp without time zone,
    dist_id character varying(5),
    office character varying(30),
    payment_date date
);
 "   DROP TABLE public.farmer_receipt;
       public         heap    postgres    false            �            1259    28902    farmer_receipts_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.farmer_receipts_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.farmer_receipts_sl_no_seq;
       public          postgres    false    252            +           0    0    farmer_receipts_sl_no_seq    SEQUENCE OWNED BY     V   ALTER SEQUENCE public.farmer_receipts_sl_no_seq OWNED BY public.farmer_receipt.sl_no;
          public          postgres    false    253            �            1259    28904    head_master    TABLE     u   CREATE TABLE public.head_master (
    head_id character varying(10) NOT NULL,
    head_name character varying(30)
);
    DROP TABLE public.head_master;
       public         heap    postgres    false            �            1259    28907 !   jalanidhi_dept_expnd_payment_desc    TABLE     �   CREATE TABLE public.jalanidhi_dept_expnd_payment_desc (
    serial integer NOT NULL,
    transaction_id character varying(50),
    scheme_id character varying(10),
    scheme_name character varying(50),
    comp_id character varying(10)
);
 5   DROP TABLE public.jalanidhi_dept_expnd_payment_desc;
       public         heap    postgres    false                        1259    28910 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 C   DROP SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq;
       public          postgres    false    255            ,           0    0 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq OWNED BY public.jalanidhi_dept_expnd_payment_desc.serial;
          public          postgres    false    256                       1259    28912    jalanidhi_payment_desc    TABLE     N  CREATE TABLE public.jalanidhi_payment_desc (
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
       public         heap    postgres    false                       1259    28915 !   jalanidhi_payment_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jalanidhi_payment_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.jalanidhi_payment_desc_serial_seq;
       public          postgres    false    257            -           0    0 !   jalanidhi_payment_desc_serial_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.jalanidhi_payment_desc_serial_seq OWNED BY public.jalanidhi_payment_desc.serial;
          public          postgres    false    258                       1259    28917    jn_expenditure_desc    TABLE     �   CREATE TABLE public.jn_expenditure_desc (
    transaction_id character varying(70) NOT NULL,
    item_name character varying(50) NOT NULL,
    item_price numeric(10,5) NOT NULL,
    quantity integer NOT NULL,
    serial integer NOT NULL
);
 '   DROP TABLE public.jn_expenditure_desc;
       public         heap    postgres    false                       1259    28920    jn_expenditure_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jn_expenditure_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.jn_expenditure_desc_serial_seq;
       public          postgres    false    259            .           0    0    jn_expenditure_desc_serial_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.jn_expenditure_desc_serial_seq OWNED BY public.jn_expenditure_desc.serial;
          public          postgres    false    260                       1259    28922 	   jn_orders    TABLE     ~  CREATE TABLE public.jn_orders (
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
       public         heap    postgres    false                       1259    28925    jn_stock    TABLE     �  CREATE TABLE public.jn_stock (
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
       public         heap    postgres    false                       1259    28931    lgd_block_master    TABLE     �   CREATE TABLE public.lgd_block_master (
    dist_code character varying(500),
    block_code character varying(20) NOT NULL,
    block_name character varying(200)
);
 $   DROP TABLE public.lgd_block_master;
       public         heap    postgres    false                       1259    28937    lgd_dist_master    TABLE     |   CREATE TABLE public.lgd_dist_master (
    dist_code character varying(20) NOT NULL,
    dist_name character varying(200)
);
 #   DROP TABLE public.lgd_dist_master;
       public         heap    postgres    false            	           1259    28940    lgd_gp_master    TABLE     �   CREATE TABLE public.lgd_gp_master (
    dist_code character varying(20),
    block_code character varying(20),
    gp_code character varying(20) NOT NULL,
    gp_name character varying(100)
);
 !   DROP TABLE public.lgd_gp_master;
       public         heap    postgres    false            
           1259    28943    log    TABLE     �  CREATE TABLE public.log (
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
       public         heap    postgres    false                       1259    28949    log_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.log_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.log_sl_no_seq;
       public          postgres    false    266            /           0    0    log_sl_no_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.log_sl_no_seq OWNED BY public.log.sl_no;
          public          postgres    false    267                       1259    28951    mrr    TABLE     g  CREATE TABLE public.mrr (
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
       public         heap    postgres    false                       1259    28954    mrr_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.mrr_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.mrr_sl_no_seq;
       public          postgres    false    268            0           0    0    mrr_sl_no_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.mrr_sl_no_seq OWNED BY public.mrr.sl_no;
          public          postgres    false    269                       1259    28956    new_item_price    TABLE     ?  CREATE TABLE public.new_item_price (
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
       public         heap    postgres    false                       1259    28962    opening_balance    TABLE     e  CREATE TABLE public.opening_balance (
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
       public         heap    postgres    false                       1259    28968    payment    TABLE     .  CREATE TABLE public.payment (
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
    system character varying(50)
);
    DROP TABLE public.payment;
       public         heap    postgres    false                       1259    28971    payment1_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment1_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.payment1_sl_no_seq;
       public          postgres    false    272            1           0    0    payment1_sl_no_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.payment1_sl_no_seq OWNED BY public.payment.sl_no;
          public          postgres    false    273                       1259    28973    payment_desc    TABLE     �   CREATE TABLE public.payment_desc (
    transaction_id character varying(70) NOT NULL,
    reference_no character varying(70) NOT NULL
);
     DROP TABLE public.payment_desc;
       public         heap    postgres    false                       1259    28976    payment_desc_2_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_desc_2_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.payment_desc_2_sl_no_seq;
       public          postgres    false    242            2           0    0    payment_desc_2_sl_no_seq    SEQUENCE OWNED BY     d   ALTER SEQUENCE public.payment_desc_2_sl_no_seq OWNED BY public.dept_expenditure_payment_desc.sl_no;
          public          postgres    false    275                       1259    28978    payment_invoice_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_invoice_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.payment_invoice_sl_no_seq;
       public          postgres    false    223            3           0    0    payment_invoice_sl_no_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.payment_invoice_sl_no_seq OWNED BY public.approval.sl_no;
          public          postgres    false    276                       1259    28980    payment_purpose_desc    TABLE        CREATE TABLE public.payment_purpose_desc (
    purpose_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
 (   DROP TABLE public.payment_purpose_desc;
       public         heap    postgres    false                       1259    28983    po_no_increment    SEQUENCE     x   CREATE SEQUENCE public.po_no_increment
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.po_no_increment;
       public          postgres    false                       1259    28985    schem_master    TABLE     x   CREATE TABLE public.schem_master (
    schem_id character varying(10) NOT NULL,
    schem_name character varying(30)
);
     DROP TABLE public.schem_master;
       public         heap    postgres    false                       1259    28988    source_master    TABLE     {   CREATE TABLE public.source_master (
    source_id character varying(10) NOT NULL,
    source_name character varying(30)
);
 !   DROP TABLE public.source_master;
       public         heap    postgres    false                       1259    28991    subheads    TABLE     �   CREATE TABLE public.subheads (
    subhead_id character varying(10) NOT NULL,
    head_id character varying(10),
    subhead_name character varying(30)
);
    DROP TABLE public.subheads;
       public         heap    postgres    false                       1259    28994    system_desc    TABLE     u   CREATE TABLE public.system_desc (
    system_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
    DROP TABLE public.system_desc;
       public         heap    postgres    false                       1259    28997 
   tax_config    TABLE     r   CREATE TABLE public.tax_config (
    tax_mode character varying(2) NOT NULL,
    "desc" character varying(100)
);
    DROP TABLE public.tax_config;
       public         heap    postgres    false                       1259    29000    users    TABLE     �   CREATE TABLE public.users (
    user_id character varying(225) NOT NULL,
    password character varying(300) NOT NULL,
    role character varying(20) NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false                       1259    29006    vender_master    TABLE     '  CREATE TABLE public.vender_master (
    "VendorId" character varying(5) NOT NULL,
    "VendorRegNo" character varying(150),
    "DateOfReg" character varying(150),
    "Name" character varying(150),
    "FarmName" character varying(200),
    "IsVerified" character varying(200),
    "IsReject" character varying(200),
    "RejectRemarkStausId" character varying(200),
    "UserName" character varying(200),
    "Password" character varying(300),
    "Type" character varying(200),
    "IPAddress" character varying(200),
    "FinancialYear" character varying(200),
    "UpdatedOn" character varying(200),
    "UpdatedBy" character varying(200),
    "DeletedOn" character varying(200),
    "DeletedBy" character varying(200),
    "IsUpdated" character varying(200),
    "IsDeleted" character varying(200)
);
 !   DROP TABLE public.vender_master;
       public         heap    postgres    false                       2604    29012    CustomerBankAccount id    DEFAULT     �   ALTER TABLE ONLY public."CustomerBankAccount" ALTER COLUMN id SET DEFAULT nextval('public."CustomerBankAccount_id_seq"'::regclass);
 G   ALTER TABLE public."CustomerBankAccount" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    201    200            �           2604    29013    CustomerContactPerson id    DEFAULT     �   ALTER TABLE ONLY public."CustomerContactPerson" ALTER COLUMN id SET DEFAULT nextval('public."CustomerContactPerson_id_seq"'::regclass);
 I   ALTER TABLE public."CustomerContactPerson" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    203    202            �           2604    29014    CustomerMaster id    DEFAULT     z   ALTER TABLE ONLY public."CustomerMaster" ALTER COLUMN id SET DEFAULT nextval('public."CustomerMaster_id_seq"'::regclass);
 B   ALTER TABLE public."CustomerMaster" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    210    209            �           2604    29015    CustomerPrincipalPlace id    DEFAULT     �   ALTER TABLE ONLY public."CustomerPrincipalPlace" ALTER COLUMN id SET DEFAULT nextval('public."CustomerPrincipalPlace_id_seq"'::regclass);
 J   ALTER TABLE public."CustomerPrincipalPlace" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    212    211            �           2604    29016    ItemPackageSizeMaster id    DEFAULT     �   ALTER TABLE ONLY public."ItemPackageSizeMaster" ALTER COLUMN id SET DEFAULT nextval('public."ItemPackageSizeMaster_id_seq"'::regclass);
 I   ALTER TABLE public."ItemPackageSizeMaster" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215            �           2604    29017    NonSubsidyPODetails id    DEFAULT     �   ALTER TABLE ONLY public."NonSubsidyPODetails" ALTER COLUMN id SET DEFAULT nextval('public."NonSubsidyPODetails_id_seq"'::regclass);
 G   ALTER TABLE public."NonSubsidyPODetails" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    221    220            �           2604    29018    VendorBankAccount BankAccountID    DEFAULT     �   ALTER TABLE ONLY public."VendorBankAccount" ALTER COLUMN "BankAccountID" SET DEFAULT nextval('public."VendorBankAccount_BankAccountID_seq"'::regclass);
 R   ALTER TABLE public."VendorBankAccount" ALTER COLUMN "BankAccountID" DROP DEFAULT;
       public          postgres    false    230    229            �           2604    29019 #   VendorContactPerson ContactPersonID    DEFAULT     �   ALTER TABLE ONLY public."VendorContactPerson" ALTER COLUMN "ContactPersonID" SET DEFAULT nextval('public."VendorContactPerson_ContactPersonID_seq"'::regclass);
 V   ALTER TABLE public."VendorContactPerson" ALTER COLUMN "ContactPersonID" DROP DEFAULT;
       public          postgres    false    232    231            �           2604    29020 %   VendorPrincipalPlace PrincipalPlaceID    DEFAULT     �   ALTER TABLE ONLY public."VendorPrincipalPlace" ALTER COLUMN "PrincipalPlaceID" SET DEFAULT nextval('public."VendorPrincipalPlace_PrincipalPlaceID_seq"'::regclass);
 X   ALTER TABLE public."VendorPrincipalPlace" ALTER COLUMN "PrincipalPlaceID" DROP DEFAULT;
       public          postgres    false    236    235            �           2604    29021    approval sl_no    DEFAULT     w   ALTER TABLE ONLY public.approval ALTER COLUMN sl_no SET DEFAULT nextval('public.payment_invoice_sl_no_seq'::regclass);
 =   ALTER TABLE public.approval ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    276    223            �           2604    29022    approval_desc serial    DEFAULT     |   ALTER TABLE ONLY public.approval_desc ALTER COLUMN serial SET DEFAULT nextval('public.approval_desc_serial_seq'::regclass);
 C   ALTER TABLE public.approval_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    239    224            �           2604    29023 #   dept_expenditure_payment_desc sl_no    DEFAULT     �   ALTER TABLE ONLY public.dept_expenditure_payment_desc ALTER COLUMN sl_no SET DEFAULT nextval('public.payment_desc_2_sl_no_seq'::regclass);
 R   ALTER TABLE public.dept_expenditure_payment_desc ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    275    242            �           2604    29024    farmer_receipt sl_no    DEFAULT     }   ALTER TABLE ONLY public.farmer_receipt ALTER COLUMN sl_no SET DEFAULT nextval('public.farmer_receipts_sl_no_seq'::regclass);
 C   ALTER TABLE public.farmer_receipt ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    253    252            �           2604    29025    govt_share_config sl    DEFAULT     |   ALTER TABLE ONLY public.govt_share_config ALTER COLUMN sl SET DEFAULT nextval('public.dept_money_config_sl_seq'::regclass);
 C   ALTER TABLE public.govt_share_config ALTER COLUMN sl DROP DEFAULT;
       public          postgres    false    244    243            �           2604    29026 (   jalanidhi_dept_expnd_payment_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc ALTER COLUMN serial SET DEFAULT nextval('public.jalanidhi_dept_expnd_payment_desc_serial_seq'::regclass);
 W   ALTER TABLE public.jalanidhi_dept_expnd_payment_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    256    255            �           2604    29027    jalanidhi_payment_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jalanidhi_payment_desc ALTER COLUMN serial SET DEFAULT nextval('public.jalanidhi_payment_desc_serial_seq'::regclass);
 L   ALTER TABLE public.jalanidhi_payment_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    258    257            �           2604    29028    jn_expenditure_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jn_expenditure_desc ALTER COLUMN serial SET DEFAULT nextval('public.jn_expenditure_desc_serial_seq'::regclass);
 I   ALTER TABLE public.jn_expenditure_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    260    259            �           2604    29029 	   log sl_no    DEFAULT     f   ALTER TABLE ONLY public.log ALTER COLUMN sl_no SET DEFAULT nextval('public.log_sl_no_seq'::regclass);
 8   ALTER TABLE public.log ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    267    266            �           2604    29030 	   mrr sl_no    DEFAULT     f   ALTER TABLE ONLY public.mrr ALTER COLUMN sl_no SET DEFAULT nextval('public.mrr_sl_no_seq'::regclass);
 8   ALTER TABLE public.mrr ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    269    268            �           2604    29031    payment sl_no    DEFAULT     o   ALTER TABLE ONLY public.payment ALTER COLUMN sl_no SET DEFAULT nextval('public.payment1_sl_no_seq'::regclass);
 <   ALTER TABLE public.payment ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    273    272            �          0    28643    CustomerBankAccount 
   TABLE DATA           �   COPY public."CustomerBankAccount" (id, "CustomerID", "BankAccountID", "bankAccountNo", "accountType", "bankName", "branchName", "ifscCode", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    200   �      �          0    28651    CustomerContactPerson 
   TABLE DATA           �   COPY public."CustomerContactPerson" (id, "CustomerID", "ContactPersonID", "AuthorisedName", "AuthorisedMobileNo", "AuthorisedEmailID", "Designation", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    202   w      �          0    28659    CustomerDistrictMapping 
   TABLE DATA           _   COPY public."CustomerDistrictMapping" ("CustomerID", "DistrictID", "InsertedDate") FROM stdin;
    public          postgres    false    204         �          0    28665    CustomerInvoiceMaster 
   TABLE DATA           N  COPY public."CustomerInvoiceMaster" ("CustomerInvoiceNo", "MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo", "POType", "FinYear", "DistrictID", "VendorID", "InvoiceAmount", "NoOfOrderDeliver", "DeliveredQuantity", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "CustomerID", "DivisionID", "Implement", "Make", "Model", "HSN", "PackageSize", "PackageUnitOfMeasurement", "PackageQuantity", "ItemQuantity", "TaxRate", "RatePerUnit", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "TotalPurchaseInvoiceValue", "TotalPurchaseTaxableValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "TotalSellCGST", "TotalSellSGST", "TotalSellIGST", "TotalSellInvoiceValue", "TotalSellTaxableValue", "UnitOfMeasurement") FROM stdin;
    public          postgres    false    205   �      �          0    28699    CustomerMaster 
   TABLE DATA           �   COPY public."CustomerMaster" (id, "CustomerID", "LegalCustomerName", "TradeName", "PAN", "BussinessConstitution", "GSTN", "ContactNumber", "EmailID", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    209   �      �          0    28708    CustomerPrincipalPlace 
   TABLE DATA           �   COPY public."CustomerPrincipalPlace" (id, "CustomerID", "PrincipalPlaceID", "Country", "StateCode", "DistrictOrCity", "Pincode", "Address", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    211         �          0    28671    DivisionMaster 
   TABLE DATA           H   COPY public."DivisionMaster" ("DivisionID", "DivisionName") FROM stdin;
    public          postgres    false    206   �      �          0    28716    InvoiceMaster 
   TABLE DATA           I  COPY public."InvoiceMaster" ("InvoiceNo", "PONo", "OrderReferenceNo", "WayBillNo", "WayBillDate", "TruckNo", "FinYear", "DistrictID", "VendorID", "Status", "PaymentStatus", "InvoiceAmount", "InvoicePath", "POType", "NoOfOrderInPO", "NoOfOrderDeliver", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "InvoiceDate", "IsReceived", "ReceivedDate", "EngineNumber", "ChassicNumber", "MRRNo", "TotalPurchaseTaxableValue", "TotalPurchaseInvoiceValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "TotalPurchaseIGST", "SupplyQuantity", "SupplyPackageQuantity", "Discount") FROM stdin;
    public          postgres    false    213         �          0    28724    ItemPackageMaster 
   TABLE DATA           W  COPY public."ItemPackageMaster" ("DivisionID", "Implement", "Make", "Model", "PackageSize", "UnitOfMeasurement", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    214   N,      �          0    28730    ItemPackageSizeMaster 
   TABLE DATA           D   COPY public."ItemPackageSizeMaster" (id, "PackageSize") FROM stdin;
    public          postgres    false    215   .      �          0    28735 	   MRRMaster 
   TABLE DATA           '  COPY public."MRRMaster" ("MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo", "FinYear", "ItemQuantity", "VendorID", "DistrictID", "DMID", "AccID", "PaymentStatus", "POType", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "MRRAmount", "NoOfItemReceived", "ReceivedQuantity") FROM stdin;
    public          postgres    false    217   j.      �          0    28749    NonSubsidyPODetails 
   TABLE DATA           )  COPY public."NonSubsidyPODetails" (id, "OrderReferenceNo", "PONo", "DivisionID", "Implement", "Make", "Model", "CustomerID", "OrderReferenceNumber", "UnitOfMeasurement", "HSN", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "ItemQuantity", "ItemQuantitySold", "EngineNumber", "ChassicNumber", "IsDelivered", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsReceived", "IsDeliveredToCustomer") FROM stdin;
    public          postgres    false    220   �1      �          0    28677    POMaster 
   TABLE DATA           �  COPY public."POMaster" ("FinYear", "PONo", "OrderReferenceNo", "CustomerID", "CustomerOrderRefence", "VendorID", "DistrictID", "DMID", "AccID", "DivisionID", "Implement", "Make", "Model", "UnitOfMeasurement", "HSN", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "TotalPurchaseInvoiceValue", "TotalPurchaseTaxableValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "TotalSellCGST", "TotalSellSGST", "TotalSellIGST", "TotalSellInvoiceValue", "TotalSellTaxableValue", "POAmount", "NoOfItemsInPO", "ItemQuantity", "ItemQuantitySold", "EngineNumber", "ChassicNumber", "IsDelivered", "IsReceived", "IsDeliveredToCustomer", "Status", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsApproved", "ApprovalStatus", "ApprovedDate", "ApprovedBy", "IsDeleted", "DeletedDate", "DeletedBy", "IsCancelled", "CancellationStatus", "CancelledDate", "CancelledBy", "POType", "VendorInvoiceNo", "MRRID", "PackageSize", "PackageUnitOfMeasurement", "RatePerUnit", "PackageQuantity", "DeliveredQuantity", "PendingQuantity") FROM stdin;
    public          postgres    false    207   :3      �          0    28759    StateMaster 
   TABLE DATA           A   COPY public."StateMaster" ("StateCode", "StateName") FROM stdin;
    public          postgres    false    222   ?E      �          0    28799    VendorBankAccount 
   TABLE DATA           �   COPY public."VendorBankAccount" ("VendorID", "BankAccountID", "AccountNumber", "AccountType", "BankName", "BranchName", "IFSCCode", "BankDocument", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    229   �F      �          0    28807    VendorContactPerson 
   TABLE DATA           �   COPY public."VendorContactPerson" ("VendorID", "ContactPersonID", "Name", "FathersName", "MobileNumber", "EmailID", "Designation", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    231   1H      �          0    28815    VendorDistrictMapping 
   TABLE DATA           [   COPY public."VendorDistrictMapping" ("VendorID", "DistrictID", "InsertedDate") FROM stdin;
    public          postgres    false    233   J      �          0    28821    VendorMaster 
   TABLE DATA           �  COPY public."VendorMaster" ("VendorID", "LegalBussinessName", "TradeName", "PAN", "PANDocument", "BussinessConstitution", "GSTN", "GSTNDocument", "IncorporationDate", "ContactNumber", "EmailID", "ApprovalStatus", "ApplyStatus", "InsertedDate", "InsertedBy", "IsDeleted", "ApproveOrRejectDate", "ApproveOrRejectBy", "WhetherSSIUnit", "WhetherMSME", "SSIUnitRegistrationCertificate", "MSMECertificate", "CoreBussinessActivity", "Password", "Turnover1", "Turnover2", "Turnover3") FROM stdin;
    public          postgres    false    234   �J      �          0    28830    VendorPrincipalPlace 
   TABLE DATA           �   COPY public."VendorPrincipalPlace" ("VendorID", "PrincipalPlaceID", "Country", "StateCode", "DistrictOrCity", "Pincode", "Address", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    235   �O      �          0    28838    VendorServices 
   TABLE DATA           _   COPY public."VendorServices" ("VendorID", "Service", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    237   �P      �          0    28844 
   acc_master 
   TABLE DATA           ~   COPY public.acc_master (acc_name, acc_id, dist_id, dist_name, acc_address, acc_mobile_no, "UpdateOn", "UpdateBy") FROM stdin;
    public          postgres    false    238   �Q      �          0    28767    approval 
   TABLE DATA           $  COPY public.approval (sl_no, invoice_no, fin_year, dist_id, dl_id, status, approval_id, indent_no, approval_date, ammount, transaction_id, deduction_amount, pay_now_amount, payment_status, remark, dl_remark, paid_amount, pp_id, pp_status, dm_approved_on, bank_approved_on, items) FROM stdin;
    public          postgres    false    223   'U      �          0    28773    approval_desc 
   TABLE DATA           O   COPY public.approval_desc (approval_id, permit_no, serial, mrr_id) FROM stdin;
    public          postgres    false    224   [      �          0    28852    approval_status_desc 
   TABLE DATA           A   COPY public.approval_status_desc (status_id, "desc") FROM stdin;
    public          postgres    false    240   u\      �          0    28855 
   components 
   TABLE DATA           C   COPY public.components (comp_id, schema_id, comp_name) FROM stdin;
    public          postgres    false    241   �\      �          0    28858    dept_expenditure_payment_desc 
   TABLE DATA           �   COPY public.dept_expenditure_payment_desc (sl_no, reference_no, transaction_id, source_id, schem_id, comp_id, head_id, subhead_id, head_name, subhead_name, sd_path) FROM stdin;
    public          postgres    false    242   T]      �          0    28866    dist_dealer_mapping 
   TABLE DATA           G   COPY public.dist_dealer_mapping (fin_year, dl_id, dist_id) FROM stdin;
    public          postgres    false    245   �`      �          0    28869    dist_master 
   TABLE DATA           E   COPY public.dist_master (dist_id, dist_name, "DistCode") FROM stdin;
    public          postgres    false    246   a      �          0    28875    dl_item_map 
   TABLE DATA           N   COPY public.dl_item_map (fin_year, dl_id, implement, make, model) FROM stdin;
    public          postgres    false    247   <b      �          0    28878    dl_item_map_1_old 
   TABLE DATA           ^   COPY public.dl_item_map_1_old (fin_year, dl_id, implement, make, model, model_id) FROM stdin;
    public          postgres    false    248   �b      �          0    28881 	   dl_master 
   TABLE DATA             COPY public.dl_master (dl_id, dl_name, bank_name, dl_ac_no, dl_mobile_no, dl_email, dl_address, add_date, modify_date, dl_ifsc_code, "LegalBussinessName", "TradeName", "PAN", "PANDocument", "BussinessConstitution", "GSTN", "GSTNDocument", "IncorporationDate", "ContactNumber", "EmailID", "Password", "ApprovalStatus", "InsertedDate", "InsertedBy", "IsDeleted", "ApproveOrRejectDate", "ApproveOrRejectBy", "WhetherSSIUnit", "WhetherMSME", "SSIUnitRegistrationCertificate", "MSMECertificate", "CoreBussinessActivity") FROM stdin;
    public          postgres    false    249   �      �          0    28887    dl_master_old 
   TABLE DATA           �   COPY public.dl_master_old (dl_id, dl_name, bank_name, dl_ac_no, dl_ifsc_code, dl_mobile_no, dl_email, dl_address, add_date, modify_date) FROM stdin;
    public          postgres    false    250   P�      �          0    28893 	   dm_master 
   TABLE DATA           �   COPY public.dm_master (dist_id, dist_name, dm_id, dm_name, dm_address, dm_mobile_no, "UpdateOn", "UpdateBy", "EmailID", "BankName", "BranchName", "AccountNumber", "IFSCCode") FROM stdin;
    public          postgres    false    251   ��      �          0    28899    farmer_receipt 
   TABLE DATA           �   COPY public.farmer_receipt (sl_no, receipt_no, fin_year, farmer_name, farmer_id, full_ammount, permit_no, implement, payment_mode, payment_no, source_bank, date, dist_id, office, payment_date) FROM stdin;
    public          postgres    false    252   ��      �          0    28861    govt_share_config 
   TABLE DATA           S   COPY public.govt_share_config (sl, fin_year, head, govt_share_ammount) FROM stdin;
    public          postgres    false    243   ��      �          0    28904    head_master 
   TABLE DATA           9   COPY public.head_master (head_id, head_name) FROM stdin;
    public          postgres    false    254   ��      �          0    28779    item_price_map_1 
   TABLE DATA           r  COPY public.item_price_map_1 ("Implement", "Make", "Model", p_taxable_value, p_cgst_6, p_sgst_6, p_cgst_1, p_sgst_1, p_invoice_value, s_taxable_value, s_cgst_6, s_sgst_6, s_invoice_value, p_igst_12, s_igst_12, add_date, update_date, "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "Division", "HSN", "UnitOfMeasurement", "GSTApplicability", "Taxability", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "PurchaseSGSTOnePercent", "PurchaseCGSTOnePercent", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "DivisionID") FROM stdin;
    public          postgres    false    225   &�      �          0    28907 !   jalanidhi_dept_expnd_payment_desc 
   TABLE DATA           t   COPY public.jalanidhi_dept_expnd_payment_desc (serial, transaction_id, scheme_id, scheme_name, comp_id) FROM stdin;
    public          postgres    false    255   �      �          0    28912    jalanidhi_payment_desc 
   TABLE DATA           �   COPY public.jalanidhi_payment_desc (transaction_id, farmer_id, farmer_name, implement, make, model, serial, project_id) FROM stdin;
    public          postgres    false    257         �          0    28917    jn_expenditure_desc 
   TABLE DATA           f   COPY public.jn_expenditure_desc (transaction_id, item_name, item_price, quantity, serial) FROM stdin;
    public          postgres    false    259   �                0    28922 	   jn_orders 
   TABLE DATA           {   COPY public.jn_orders (fin_year, dist_id, cluster_id, farmer_id, dist_name, farmer_name, status, date, system) FROM stdin;
    public          postgres    false    261   �                0    28925    jn_stock 
   TABLE DATA           �   COPY public.jn_stock (fin_year, dist_id, dl_id, system, po_no, cluster_id, farmer_id, farmer_name, implement, make, model, engine_no, chassic_no, status, receive_date, deliver_date, dl_name) FROM stdin;
    public          postgres    false    262   �	                0    28931    lgd_block_master 
   TABLE DATA           M   COPY public.lgd_block_master (dist_code, block_code, block_name) FROM stdin;
    public          postgres    false    263   �
                0    28937    lgd_dist_master 
   TABLE DATA           ?   COPY public.lgd_dist_master (dist_code, dist_name) FROM stdin;
    public          postgres    false    264   �                0    28940    lgd_gp_master 
   TABLE DATA           P   COPY public.lgd_gp_master (dist_code, block_code, gp_code, gp_name) FROM stdin;
    public          postgres    false    265   �                0    28943    log 
   TABLE DATA           �   COPY public.log (sl_no, date_time, user_id, action, status, ref_url, route, ip, browser_name, browser_version, fin_year, remark) FROM stdin;
    public          postgres    false    266   �                0    28951    mrr 
   TABLE DATA           v   COPY public.mrr (sl_no, mrr_id, dist_id, invoice_no, fin_year, dl_id, date, items, indent_no, mrr_amount) FROM stdin;
    public          postgres    false    268   :/      �          0    28785    mrr_desc 
   TABLE DATA           5   COPY public.mrr_desc (mrr_id, permit_no) FROM stdin;
    public          postgres    false    226   32      
          0    28956    new_item_price 
   TABLE DATA           �   COPY public.new_item_price (implement, make, model, purchase_price, taxable_value, cgst_6, sags_6, invoice_alue, selling_price, sl_taxable_value, sl_cgst_6, sl_sgst_6, sl_invoice_value) FROM stdin;
    public          postgres    false    270   �3                0    28962    opening_balance 
   TABLE DATA           �   COPY public.opening_balance (fin_year, date, system, dist_id, transaction_id, ammount, remark, purpose, reference_no, "from", "to", head, subhead, payment_type, payment_date, payment_no, test) FROM stdin;
    public          postgres    false    271   7K      �          0    28788    orders 
   TABLE DATA           �  COPY public.orders (permit_no, permit_issue_date, permit_validity, farmer_id, farmer_name, farmer_father_name, dist_name, block_name, gp_name, village_name, implement, make, model, status, permit_validity_1, permit_issue_date_1, fin_year, dist_id, engine_no, chassic_no, ammount, remark, expected_delivery_date, delivery_date, c_fin_year, date, system, paid_amount, order_type, "FullCost", "PendingCost") FROM stdin;
    public          postgres    false    227   7O                0    28968    payment 
   TABLE DATA           �   COPY public.payment (sl_no, date, reference_no, transaction_id, "from", "to", remark, payment_type, payment_no, fin_year, purpose, payment_date, ammount, status, system) FROM stdin;
    public          postgres    false    272   �m                0    28973    payment_desc 
   TABLE DATA           D   COPY public.payment_desc (transaction_id, reference_no) FROM stdin;
    public          postgres    false    274   *�                0    28980    payment_purpose_desc 
   TABLE DATA           B   COPY public.payment_purpose_desc (purpose_id, "desc") FROM stdin;
    public          postgres    false    277   G�                0    28985    schem_master 
   TABLE DATA           <   COPY public.schem_master (schem_id, schem_name) FROM stdin;
    public          postgres    false    279   �                0    28988    source_master 
   TABLE DATA           ?   COPY public.source_master (source_id, source_name) FROM stdin;
    public          postgres    false    280   M�                0    28991    subheads 
   TABLE DATA           E   COPY public.subheads (subhead_id, head_id, subhead_name) FROM stdin;
    public          postgres    false    281   ��                0    28994    system_desc 
   TABLE DATA           8   COPY public.system_desc (system_id, "desc") FROM stdin;
    public          postgres    false    282   +�                0    28997 
   tax_config 
   TABLE DATA           6   COPY public.tax_config (tax_mode, "desc") FROM stdin;
    public          postgres    false    283   j�                0    29000    users 
   TABLE DATA           8   COPY public.users (user_id, password, role) FROM stdin;
    public          postgres    false    284   ��                0    29006    vender_master 
   TABLE DATA              COPY public.vender_master ("VendorId", "VendorRegNo", "DateOfReg", "Name", "FarmName", "IsVerified", "IsReject", "RejectRemarkStausId", "UserName", "Password", "Type", "IPAddress", "FinancialYear", "UpdatedOn", "UpdatedBy", "DeletedOn", "DeletedBy", "IsUpdated", "IsDeleted") FROM stdin;
    public          postgres    false    285   ��      4           0    0    CustomerBankAccount_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."CustomerBankAccount_id_seq"', 7, true);
          public          postgres    false    201            5           0    0    CustomerContactPerson_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."CustomerContactPerson_id_seq"', 6, true);
          public          postgres    false    203            6           0    0    CustomerMaster_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."CustomerMaster_id_seq"', 14, true);
          public          postgres    false    210            7           0    0    CustomerPrincipalPlace_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public."CustomerPrincipalPlace_id_seq"', 8, true);
          public          postgres    false    212            8           0    0    ItemPackageSizeMaster_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public."ItemPackageSizeMaster_id_seq"', 19, true);
          public          postgres    false    216            9           0    0    NonSubsidyPODetails_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."NonSubsidyPODetails_id_seq"', 11, true);
          public          postgres    false    221            :           0    0 #   VendorBankAccount_BankAccountID_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public."VendorBankAccount_BankAccountID_seq"', 9, true);
          public          postgres    false    230            ;           0    0 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE SET     X   SELECT pg_catalog.setval('public."VendorContactPerson_ContactPersonID_seq"', 15, true);
          public          postgres    false    232            <           0    0 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE SET     Z   SELECT pg_catalog.setval('public."VendorPrincipalPlace_PrincipalPlaceID_seq"', 17, true);
          public          postgres    false    236            =           0    0    approval_desc_serial_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.approval_desc_serial_seq', 99, true);
          public          postgres    false    239            >           0    0    customer_id_increment    SEQUENCE SET     D   SELECT pg_catalog.setval('public.customer_id_increment', 10, true);
          public          postgres    false    208            ?           0    0    dept_money_config_sl_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.dept_money_config_sl_seq', 1, true);
          public          postgres    false    244            @           0    0    farmer_receipts_sl_no_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.farmer_receipts_sl_no_seq', 486, true);
          public          postgres    false    253            A           0    0    id_increment    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.id_increment', 13, true);
          public          postgres    false    219            B           0    0 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE SET     [   SELECT pg_catalog.setval('public.jalanidhi_dept_expnd_payment_desc_serial_seq', 12, true);
          public          postgres    false    256            C           0    0 !   jalanidhi_payment_desc_serial_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.jalanidhi_payment_desc_serial_seq', 24, true);
          public          postgres    false    258            D           0    0    jn_expenditure_desc_serial_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.jn_expenditure_desc_serial_seq', 36, true);
          public          postgres    false    260            E           0    0    log_sl_no_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.log_sl_no_seq', 3009, true);
          public          postgres    false    267            F           0    0    mrr_sl_no_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.mrr_sl_no_seq', 209, true);
          public          postgres    false    269            G           0    0    payment1_sl_no_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.payment1_sl_no_seq', 1097, true);
          public          postgres    false    273            H           0    0    payment_desc_2_sl_no_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.payment_desc_2_sl_no_seq', 94, true);
          public          postgres    false    275            I           0    0    payment_invoice_sl_no_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.payment_invoice_sl_no_seq', 107, true);
          public          postgres    false    276            J           0    0    po_no_increment    SEQUENCE SET     =   SELECT pg_catalog.setval('public.po_no_increment', 6, true);
          public          postgres    false    278            �           2606    29033 ,   CustomerBankAccount CustomerBankAccount_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."CustomerBankAccount"
    ADD CONSTRAINT "CustomerBankAccount_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."CustomerBankAccount" DROP CONSTRAINT "CustomerBankAccount_pkey";
       public            postgres    false    200            �           2606    29035 0   CustomerContactPerson CustomerContactPerson_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."CustomerContactPerson"
    ADD CONSTRAINT "CustomerContactPerson_pkey" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public."CustomerContactPerson" DROP CONSTRAINT "CustomerContactPerson_pkey";
       public            postgres    false    202            �           2606    29037 4   CustomerDistrictMapping CustomerDistrictMapping_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CustomerDistrictMapping"
    ADD CONSTRAINT "CustomerDistrictMapping_pkey" PRIMARY KEY ("CustomerID", "DistrictID");
 b   ALTER TABLE ONLY public."CustomerDistrictMapping" DROP CONSTRAINT "CustomerDistrictMapping_pkey";
       public            postgres    false    204    204            �           2606    29302 0   CustomerInvoiceMaster CustomerInvoiceMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CustomerInvoiceMaster"
    ADD CONSTRAINT "CustomerInvoiceMaster_pkey" PRIMARY KEY ("CustomerInvoiceNo", "OrderReferenceNo");
 ^   ALTER TABLE ONLY public."CustomerInvoiceMaster" DROP CONSTRAINT "CustomerInvoiceMaster_pkey";
       public            postgres    false    205    205            �           2606    29041 "   CustomerMaster CustomerMaster_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."CustomerMaster"
    ADD CONSTRAINT "CustomerMaster_pkey" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public."CustomerMaster" DROP CONSTRAINT "CustomerMaster_pkey";
       public            postgres    false    209            �           2606    29043 2   CustomerPrincipalPlace CustomerPrincipalPlace_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."CustomerPrincipalPlace"
    ADD CONSTRAINT "CustomerPrincipalPlace_pkey" PRIMARY KEY (id);
 `   ALTER TABLE ONLY public."CustomerPrincipalPlace" DROP CONSTRAINT "CustomerPrincipalPlace_pkey";
       public            postgres    false    211            �           2606    29045 "   DivisionMaster DivisionMaster_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."DivisionMaster"
    ADD CONSTRAINT "DivisionMaster_pkey" PRIMARY KEY ("DivisionID");
 P   ALTER TABLE ONLY public."DivisionMaster" DROP CONSTRAINT "DivisionMaster_pkey";
       public            postgres    false    206            �           2606    29047     InvoiceMaster InvoiceMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."InvoiceMaster"
    ADD CONSTRAINT "InvoiceMaster_pkey" PRIMARY KEY ("InvoiceNo", "PONo", "OrderReferenceNo");
 N   ALTER TABLE ONLY public."InvoiceMaster" DROP CONSTRAINT "InvoiceMaster_pkey";
       public            postgres    false    213    213    213            �           2606    29049 (   ItemPackageMaster ItemPackageMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."ItemPackageMaster"
    ADD CONSTRAINT "ItemPackageMaster_pkey" PRIMARY KEY ("DivisionID", "Implement", "Make", "Model", "PackageSize");
 V   ALTER TABLE ONLY public."ItemPackageMaster" DROP CONSTRAINT "ItemPackageMaster_pkey";
       public            postgres    false    214    214    214    214    214            �           2606    29051 0   ItemPackageSizeMaster ItemPackageSizeMaster_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."ItemPackageSizeMaster"
    ADD CONSTRAINT "ItemPackageSizeMaster_pkey" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public."ItemPackageSizeMaster" DROP CONSTRAINT "ItemPackageSizeMaster_pkey";
       public            postgres    false    215            �           2606    29053    MRRMaster MRRMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."MRRMaster"
    ADD CONSTRAINT "MRRMaster_pkey" PRIMARY KEY ("MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo");
 F   ALTER TABLE ONLY public."MRRMaster" DROP CONSTRAINT "MRRMaster_pkey";
       public            postgres    false    217    217    217    217            �           2606    29055 ,   NonSubsidyPODetails NonSubsidyPODetails_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."NonSubsidyPODetails"
    ADD CONSTRAINT "NonSubsidyPODetails_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."NonSubsidyPODetails" DROP CONSTRAINT "NonSubsidyPODetails_pkey";
       public            postgres    false    220            �           2606    29057    POMaster POMaster_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."POMaster"
    ADD CONSTRAINT "POMaster_pkey" PRIMARY KEY ("PONo", "OrderReferenceNo");
 D   ALTER TABLE ONLY public."POMaster" DROP CONSTRAINT "POMaster_pkey";
       public            postgres    false    207    207            �           2606    29059    StateMaster StateMaster_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public."StateMaster"
    ADD CONSTRAINT "StateMaster_pkey" PRIMARY KEY ("StateCode");
 J   ALTER TABLE ONLY public."StateMaster" DROP CONSTRAINT "StateMaster_pkey";
       public            postgres    false    222            �           2606    29061 (   VendorBankAccount VendorBankAccount_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."VendorBankAccount"
    ADD CONSTRAINT "VendorBankAccount_pkey" PRIMARY KEY ("BankAccountID");
 V   ALTER TABLE ONLY public."VendorBankAccount" DROP CONSTRAINT "VendorBankAccount_pkey";
       public            postgres    false    229            �           2606    29063 ,   VendorContactPerson VendorContactPerson_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public."VendorContactPerson"
    ADD CONSTRAINT "VendorContactPerson_pkey" PRIMARY KEY ("ContactPersonID");
 Z   ALTER TABLE ONLY public."VendorContactPerson" DROP CONSTRAINT "VendorContactPerson_pkey";
       public            postgres    false    231            �           2606    29065 0   VendorDistrictMapping VendorDistrictMapping_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_pkey" PRIMARY KEY ("VendorID", "DistrictID");
 ^   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_pkey";
       public            postgres    false    233    233            �           2606    29067    VendorMaster VendorMaster_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."VendorMaster"
    ADD CONSTRAINT "VendorMaster_pkey" PRIMARY KEY ("VendorID");
 L   ALTER TABLE ONLY public."VendorMaster" DROP CONSTRAINT "VendorMaster_pkey";
       public            postgres    false    234            �           2606    29069 .   VendorPrincipalPlace VendorPrincipalPlace_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_pkey" PRIMARY KEY ("PrincipalPlaceID");
 \   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_pkey";
       public            postgres    false    235            �           2606    29071 "   VendorServices VendorServices_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."VendorServices"
    ADD CONSTRAINT "VendorServices_pkey" PRIMARY KEY ("VendorID", "Service");
 P   ALTER TABLE ONLY public."VendorServices" DROP CONSTRAINT "VendorServices_pkey";
       public            postgres    false    237    237            �           2606    29073 "   acc_master accountants_master_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.acc_master
    ADD CONSTRAINT accountants_master_pkey PRIMARY KEY (acc_id, dist_id);
 L   ALTER TABLE ONLY public.acc_master DROP CONSTRAINT accountants_master_pkey;
       public            postgres    false    238    238            �           2606    29075     approval_desc approval_desc_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.approval_desc
    ADD CONSTRAINT approval_desc_pkey PRIMARY KEY (serial);
 J   ALTER TABLE ONLY public.approval_desc DROP CONSTRAINT approval_desc_pkey;
       public            postgres    false    224            �           2606    29077 .   approval_status_desc approval_status_desc_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.approval_status_desc
    ADD CONSTRAINT approval_status_desc_pkey PRIMARY KEY (status_id);
 X   ALTER TABLE ONLY public.approval_status_desc DROP CONSTRAINT approval_status_desc_pkey;
       public            postgres    false    240            �           2606    29079    components components_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.components
    ADD CONSTRAINT components_pkey PRIMARY KEY (comp_id);
 D   ALTER TABLE ONLY public.components DROP CONSTRAINT components_pkey;
       public            postgres    false    241            �           2606    29081 (   govt_share_config dept_money_config_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.govt_share_config
    ADD CONSTRAINT dept_money_config_pkey PRIMARY KEY (sl);
 R   ALTER TABLE ONLY public.govt_share_config DROP CONSTRAINT dept_money_config_pkey;
       public            postgres    false    243            �           2606    29083 &   dist_dealer_mapping dist_dl_map_1_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.dist_dealer_mapping
    ADD CONSTRAINT dist_dl_map_1_pkey PRIMARY KEY (fin_year, dl_id, dist_id);
 P   ALTER TABLE ONLY public.dist_dealer_mapping DROP CONSTRAINT dist_dl_map_1_pkey;
       public            postgres    false    245    245    245            �           2606    29085    dist_master dist_master_1_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.dist_master
    ADD CONSTRAINT dist_master_1_pkey PRIMARY KEY (dist_id);
 H   ALTER TABLE ONLY public.dist_master DROP CONSTRAINT dist_master_1_pkey;
       public            postgres    false    246            �           2606    29087 $   dl_item_map_1_old dl_item_map_1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.dl_item_map_1_old
    ADD CONSTRAINT dl_item_map_1_pkey PRIMARY KEY (fin_year, dl_id, implement, make, model, model_id);
 N   ALTER TABLE ONLY public.dl_item_map_1_old DROP CONSTRAINT dl_item_map_1_pkey;
       public            postgres    false    248    248    248    248    248    248            �           2606    29089    dl_item_map dl_item_map_2_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.dl_item_map
    ADD CONSTRAINT dl_item_map_2_pkey PRIMARY KEY (fin_year, dl_id, implement, make);
 H   ALTER TABLE ONLY public.dl_item_map DROP CONSTRAINT dl_item_map_2_pkey;
       public            postgres    false    247    247    247    247            �           2606    29091    dl_master_old dl_master_1_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.dl_master_old
    ADD CONSTRAINT dl_master_1_pkey PRIMARY KEY (dl_id);
 H   ALTER TABLE ONLY public.dl_master_old DROP CONSTRAINT dl_master_1_pkey;
       public            postgres    false    250            �           2606    29093    dl_master dl_master_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.dl_master
    ADD CONSTRAINT dl_master_pkey PRIMARY KEY (dl_id);
 B   ALTER TABLE ONLY public.dl_master DROP CONSTRAINT dl_master_pkey;
       public            postgres    false    249            �           2606    29095    dm_master dm_master_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.dm_master
    ADD CONSTRAINT dm_master_pkey PRIMARY KEY (dm_id);
 B   ALTER TABLE ONLY public.dm_master DROP CONSTRAINT dm_master_pkey;
       public            postgres    false    251            �           2606    29097 #   farmer_receipt farmer_receipts_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.farmer_receipt
    ADD CONSTRAINT farmer_receipts_pkey PRIMARY KEY (receipt_no);
 M   ALTER TABLE ONLY public.farmer_receipt DROP CONSTRAINT farmer_receipts_pkey;
       public            postgres    false    252            �           2606    29099    head_master head_master_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.head_master
    ADD CONSTRAINT head_master_pkey PRIMARY KEY (head_id);
 F   ALTER TABLE ONLY public.head_master DROP CONSTRAINT head_master_pkey;
       public            postgres    false    254            �           2606    29101 '   item_price_map_1 item_price_map_1_pkey1 
   CONSTRAINT        ALTER TABLE ONLY public.item_price_map_1
    ADD CONSTRAINT item_price_map_1_pkey1 PRIMARY KEY ("Implement", "Make", "Model");
 Q   ALTER TABLE ONLY public.item_price_map_1 DROP CONSTRAINT item_price_map_1_pkey1;
       public            postgres    false    225    225    225            �           2606    29103 H   jalanidhi_dept_expnd_payment_desc jalanidhi_dept_expnd_payment_desc_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc
    ADD CONSTRAINT jalanidhi_dept_expnd_payment_desc_pkey PRIMARY KEY (serial);
 r   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc DROP CONSTRAINT jalanidhi_dept_expnd_payment_desc_pkey;
       public            postgres    false    255            �           2606    29105 2   jalanidhi_payment_desc jalanidhi_payment_desc_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.jalanidhi_payment_desc
    ADD CONSTRAINT jalanidhi_payment_desc_pkey PRIMARY KEY (serial);
 \   ALTER TABLE ONLY public.jalanidhi_payment_desc DROP CONSTRAINT jalanidhi_payment_desc_pkey;
       public            postgres    false    257            �           2606    29107 ,   jn_expenditure_desc jn_expenditure_desc_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.jn_expenditure_desc
    ADD CONSTRAINT jn_expenditure_desc_pkey PRIMARY KEY (serial);
 V   ALTER TABLE ONLY public.jn_expenditure_desc DROP CONSTRAINT jn_expenditure_desc_pkey;
       public            postgres    false    259            �           2606    29109    jn_orders jn_orders_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.jn_orders
    ADD CONSTRAINT jn_orders_pkey PRIMARY KEY (cluster_id, farmer_id);
 B   ALTER TABLE ONLY public.jn_orders DROP CONSTRAINT jn_orders_pkey;
       public            postgres    false    261    261            �           2606    29111    jn_stock jn_stock_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.jn_stock
    ADD CONSTRAINT jn_stock_pkey PRIMARY KEY (po_no, cluster_id, farmer_id, implement, make, model);
 @   ALTER TABLE ONLY public.jn_stock DROP CONSTRAINT jn_stock_pkey;
       public            postgres    false    262    262    262    262    262    262            �           2606    29113 &   lgd_block_master lgd_block_master_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.lgd_block_master
    ADD CONSTRAINT lgd_block_master_pkey PRIMARY KEY (block_code);
 P   ALTER TABLE ONLY public.lgd_block_master DROP CONSTRAINT lgd_block_master_pkey;
       public            postgres    false    263                        2606    29115 $   lgd_dist_master lgd_dist_master_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.lgd_dist_master
    ADD CONSTRAINT lgd_dist_master_pkey PRIMARY KEY (dist_code);
 N   ALTER TABLE ONLY public.lgd_dist_master DROP CONSTRAINT lgd_dist_master_pkey;
       public            postgres    false    264                       2606    29117     lgd_gp_master lgd_gp_master_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT lgd_gp_master_pkey PRIMARY KEY (gp_code);
 J   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT lgd_gp_master_pkey;
       public            postgres    false    265                       2606    29119    log log_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (sl_no);
 6   ALTER TABLE ONLY public.log DROP CONSTRAINT log_pkey;
       public            postgres    false    266            �           2606    29121    mrr_desc mrr_desc_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_pkey PRIMARY KEY (mrr_id, permit_no);
 @   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_pkey;
       public            postgres    false    226    226                       2606    29123    mrr mrr_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.mrr
    ADD CONSTRAINT mrr_pkey PRIMARY KEY (mrr_id);
 6   ALTER TABLE ONLY public.mrr DROP CONSTRAINT mrr_pkey;
       public            postgres    false    268                       2606    29125 "   new_item_price new_item_price_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.new_item_price
    ADD CONSTRAINT new_item_price_pkey PRIMARY KEY (implement, make, model);
 L   ALTER TABLE ONLY public.new_item_price DROP CONSTRAINT new_item_price_pkey;
       public            postgres    false    270    270    270            
           2606    29127 $   opening_balance opening_balance_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.opening_balance
    ADD CONSTRAINT opening_balance_pkey PRIMARY KEY (transaction_id);
 N   ALTER TABLE ONLY public.opening_balance DROP CONSTRAINT opening_balance_pkey;
       public            postgres    false    271            �           2606    29129    orders orders_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (permit_no);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    227                       2606    29131    payment payment1_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment1_pkey PRIMARY KEY (transaction_id);
 ?   ALTER TABLE ONLY public.payment DROP CONSTRAINT payment1_pkey;
       public            postgres    false    272            �           2606    29133 1   dept_expenditure_payment_desc payment_desc_2_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.dept_expenditure_payment_desc
    ADD CONSTRAINT payment_desc_2_pkey PRIMARY KEY (sl_no);
 [   ALTER TABLE ONLY public.dept_expenditure_payment_desc DROP CONSTRAINT payment_desc_2_pkey;
       public            postgres    false    242                       2606    29135    payment_desc payment_desc_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.payment_desc
    ADD CONSTRAINT payment_desc_pkey PRIMARY KEY (reference_no, transaction_id);
 H   ALTER TABLE ONLY public.payment_desc DROP CONSTRAINT payment_desc_pkey;
       public            postgres    false    274    274            �           2606    29137 !   approval payment_instruction_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.approval
    ADD CONSTRAINT payment_instruction_pkey PRIMARY KEY (sl_no);
 K   ALTER TABLE ONLY public.approval DROP CONSTRAINT payment_instruction_pkey;
       public            postgres    false    223                       2606    29139 .   payment_purpose_desc payment_purpose_desc_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.payment_purpose_desc
    ADD CONSTRAINT payment_purpose_desc_pkey PRIMARY KEY (purpose_id);
 X   ALTER TABLE ONLY public.payment_purpose_desc DROP CONSTRAINT payment_purpose_desc_pkey;
       public            postgres    false    277                       2606    29141    schem_master schema_master_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.schem_master
    ADD CONSTRAINT schema_master_pkey PRIMARY KEY (schem_id);
 I   ALTER TABLE ONLY public.schem_master DROP CONSTRAINT schema_master_pkey;
       public            postgres    false    279                       2606    29143     source_master source_master_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.source_master
    ADD CONSTRAINT source_master_pkey PRIMARY KEY (source_id);
 J   ALTER TABLE ONLY public.source_master DROP CONSTRAINT source_master_pkey;
       public            postgres    false    280                       2606    29145    subheads subhead_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.subheads
    ADD CONSTRAINT subhead_pkey PRIMARY KEY (subhead_id);
 ?   ALTER TABLE ONLY public.subheads DROP CONSTRAINT subhead_pkey;
       public            postgres    false    281                       2606    29147    system_desc system_desc_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.system_desc
    ADD CONSTRAINT system_desc_pkey PRIMARY KEY (system_id);
 F   ALTER TABLE ONLY public.system_desc DROP CONSTRAINT system_desc_pkey;
       public            postgres    false    282                       2606    29149    tax_config tax_config_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.tax_config
    ADD CONSTRAINT tax_config_pkey PRIMARY KEY (tax_mode);
 D   ALTER TABLE ONLY public.tax_config DROP CONSTRAINT tax_config_pkey;
       public            postgres    false    283                       2606    29151    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    284                       2606    29153     vender_master vender_master_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.vender_master
    ADD CONSTRAINT vender_master_pkey PRIMARY KEY ("VendorId");
 J   ALTER TABLE ONLY public.vender_master DROP CONSTRAINT vender_master_pkey;
       public            postgres    false    285            9           2620    29154    POMaster po_no    TRIGGER     m   CREATE TRIGGER po_no BEFORE INSERT ON public."POMaster" FOR EACH ROW EXECUTE FUNCTION public.create_po_no();
 )   DROP TRIGGER po_no ON public."POMaster";
       public          postgres    false    290    207            :           2620    29155     POMaster updateDeliveredQuantity    TRIGGER     �   CREATE TRIGGER "updateDeliveredQuantity" BEFORE UPDATE ON public."POMaster" FOR EACH ROW EXECUTE FUNCTION public."UpdateDeliveredQuantity"();
 =   DROP TRIGGER "updateDeliveredQuantity" ON public."POMaster";
       public          postgres    false    289    207            <           2620    29156    InvoiceMaster update_invoice_no    TRIGGER     �   CREATE TRIGGER update_invoice_no AFTER INSERT ON public."InvoiceMaster" FOR EACH ROW EXECUTE FUNCTION public.update_invoice_number();
 :   DROP TRIGGER update_invoice_no ON public."InvoiceMaster";
       public          postgres    false    213    291            =           2620    29157    MRRMaster update_mrr_id    TRIGGER     v   CREATE TRIGGER update_mrr_id AFTER INSERT ON public."MRRMaster" FOR EACH ROW EXECUTE FUNCTION public.update_mrr_id();
 2   DROP TRIGGER update_mrr_id ON public."MRRMaster";
       public          postgres    false    292    217            ?           2620    29158    mrr update_mrr_id    TRIGGER     n   CREATE TRIGGER update_mrr_id AFTER INSERT ON public.mrr FOR EACH ROW EXECUTE FUNCTION public.update_mrr_id();
 *   DROP TRIGGER update_mrr_id ON public.mrr;
       public          postgres    false    268    292            ;           2620    29159    POMaster update_order    TRIGGER     ~   CREATE TRIGGER update_order AFTER INSERT ON public."POMaster" FOR EACH ROW EXECUTE FUNCTION public.update_order_po_intiate();
 0   DROP TRIGGER update_order ON public."POMaster";
       public          postgres    false    293    207            >           2620    29160 (   dm_master updateaccountantaddresstrigger    TRIGGER     �   CREATE TRIGGER updateaccountantaddresstrigger AFTER UPDATE ON public.dm_master FOR EACH ROW EXECUTE FUNCTION public."UpdateAccountantAddress"();
 A   DROP TRIGGER updateaccountantaddresstrigger ON public.dm_master;
       public          postgres    false    288    251                       2606    29161 ?   CustomerDistrictMapping CustomerDistrictMapping_DistrictID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomerDistrictMapping"
    ADD CONSTRAINT "CustomerDistrictMapping_DistrictID_fkey" FOREIGN KEY ("DistrictID") REFERENCES public.dist_master(dist_id) ON UPDATE CASCADE;
 m   ALTER TABLE ONLY public."CustomerDistrictMapping" DROP CONSTRAINT "CustomerDistrictMapping_DistrictID_fkey";
       public          postgres    false    246    204    3556                        2606    29166 <   CustomerPrincipalPlace CustomerPrincipalPlace_StateCode_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomerPrincipalPlace"
    ADD CONSTRAINT "CustomerPrincipalPlace_StateCode_fkey" FOREIGN KEY ("StateCode") REFERENCES public."StateMaster"("StateCode") ON UPDATE CASCADE ON DELETE SET NULL;
 j   ALTER TABLE ONLY public."CustomerPrincipalPlace" DROP CONSTRAINT "CustomerPrincipalPlace_StateCode_fkey";
       public          postgres    false    3520    222    211            +           2606    29171    acc_master DISTID_F_KEY    FK CONSTRAINT     �   ALTER TABLE ONLY public.acc_master
    ADD CONSTRAINT "DISTID_F_KEY" FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 C   ALTER TABLE ONLY public.acc_master DROP CONSTRAINT "DISTID_F_KEY";
       public          postgres    false    3556    246    238            0           2606    29176    dm_master DIST_ID_F_KEY    FK CONSTRAINT     �   ALTER TABLE ONLY public.dm_master
    ADD CONSTRAINT "DIST_ID_F_KEY" FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 C   ALTER TABLE ONLY public.dm_master DROP CONSTRAINT "DIST_ID_F_KEY";
       public          postgres    false    251    3556    246            1           2606    29181    dm_master UPDATEBY_USERID_F_KEY    FK CONSTRAINT     �   ALTER TABLE ONLY public.dm_master
    ADD CONSTRAINT "UPDATEBY_USERID_F_KEY" FOREIGN KEY ("UpdateBy") REFERENCES public.users(user_id) NOT VALID;
 K   ALTER TABLE ONLY public.dm_master DROP CONSTRAINT "UPDATEBY_USERID_F_KEY";
       public          postgres    false    3612    284    251            ,           2606    29186     acc_master UpdateBy_UserId_F_KEY    FK CONSTRAINT     �   ALTER TABLE ONLY public.acc_master
    ADD CONSTRAINT "UpdateBy_UserId_F_KEY" FOREIGN KEY ("UpdateBy") REFERENCES public.users(user_id) NOT VALID;
 L   ALTER TABLE ONLY public.acc_master DROP CONSTRAINT "UpdateBy_UserId_F_KEY";
       public          postgres    false    238    284    3612            $           2606    29191 1   VendorBankAccount VendorBankAccount_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorBankAccount"
    ADD CONSTRAINT "VendorBankAccount_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 _   ALTER TABLE ONLY public."VendorBankAccount" DROP CONSTRAINT "VendorBankAccount_VendorID_fkey";
       public          postgres    false    234    3538    229            %           2606    29196 5   VendorContactPerson VendorContactPerson_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorContactPerson"
    ADD CONSTRAINT "VendorContactPerson_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 c   ALTER TABLE ONLY public."VendorContactPerson" DROP CONSTRAINT "VendorContactPerson_VendorID_fkey";
       public          postgres    false    231    234    3538            &           2606    29201 ;   VendorDistrictMapping VendorDistrictMapping_DistrictID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_DistrictID_fkey" FOREIGN KEY ("DistrictID") REFERENCES public.dist_master(dist_id) ON UPDATE CASCADE;
 i   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_DistrictID_fkey";
       public          postgres    false    3556    233    246            '           2606    29206 9   VendorDistrictMapping VendorDistrictMapping_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 g   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_VendorID_fkey";
       public          postgres    false    234    3538    233            (           2606    29211 8   VendorPrincipalPlace VendorPrincipalPlace_StateCode_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_StateCode_fkey" FOREIGN KEY ("StateCode") REFERENCES public."StateMaster"("StateCode") ON UPDATE CASCADE;
 f   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_StateCode_fkey";
       public          postgres    false    235    222    3520            )           2606    29216 7   VendorPrincipalPlace VendorPrincipalPlace_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 e   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_VendorID_fkey";
       public          postgres    false    3538    235    234            *           2606    29221 +   VendorServices VendorServices_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorServices"
    ADD CONSTRAINT "VendorServices_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 Y   ALTER TABLE ONLY public."VendorServices" DROP CONSTRAINT "VendorServices_VendorID_fkey";
       public          postgres    false    234    3538    237            !           2606    29226    approval approval_status_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.approval
    ADD CONSTRAINT approval_status_fkey FOREIGN KEY (status) REFERENCES public.approval_status_desc(status_id) NOT VALID;
 G   ALTER TABLE ONLY public.approval DROP CONSTRAINT approval_status_fkey;
       public          postgres    false    240    223    3546            4           2606    29231    lgd_gp_master block_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT block_master FOREIGN KEY (block_code) REFERENCES public.lgd_block_master(block_code) NOT VALID;
 D   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT block_master;
       public          postgres    false    3582    265    263            -           2606    29236    dist_dealer_mapping dist_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.dist_dealer_mapping
    ADD CONSTRAINT dist_id FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 E   ALTER TABLE ONLY public.dist_dealer_mapping DROP CONSTRAINT dist_id;
       public          postgres    false    246    245    3556            5           2606    29241    lgd_gp_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 C   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT dist_master;
       public          postgres    false    265    264    3584            3           2606    29246    lgd_block_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_block_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 F   ALTER TABLE ONLY public.lgd_block_master DROP CONSTRAINT dist_master;
       public          postgres    false    3584    264    263            .           2606    29251    dist_dealer_mapping dl_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.dist_dealer_mapping
    ADD CONSTRAINT dl_id FOREIGN KEY (dl_id) REFERENCES public.dl_master_old(dl_id) NOT VALID;
 C   ALTER TABLE ONLY public.dist_dealer_mapping DROP CONSTRAINT dl_id;
       public          postgres    false    245    250    3564            /           2606    29256 $   dl_item_map dl_item_map_2_dl_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.dl_item_map
    ADD CONSTRAINT dl_item_map_2_dl_id_fkey FOREIGN KEY (dl_id) REFERENCES public.dl_master_old(dl_id) NOT VALID;
 N   ALTER TABLE ONLY public.dl_item_map DROP CONSTRAINT dl_item_map_2_dl_id_fkey;
       public          postgres    false    247    250    3564            2           2606    29261 +   jn_stock jn_stock_cluster_id_farmer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.jn_stock
    ADD CONSTRAINT jn_stock_cluster_id_farmer_id_fkey FOREIGN KEY (cluster_id, farmer_id) REFERENCES public.jn_orders(cluster_id, farmer_id) NOT VALID;
 U   ALTER TABLE ONLY public.jn_stock DROP CONSTRAINT jn_stock_cluster_id_farmer_id_fkey;
       public          postgres    false    261    3578    261    262    262            "           2606    29266    mrr_desc mrr_desc_mrr_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_mrr_id_fkey FOREIGN KEY (mrr_id) REFERENCES public.mrr(mrr_id) NOT VALID;
 G   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_mrr_id_fkey;
       public          postgres    false    226    268    3590            #           2606    29271     mrr_desc mrr_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 J   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_permit_no_fkey;
       public          postgres    false    226    3530    227            6           2606    29276    mrr mrr_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr
    ADD CONSTRAINT mrr_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 >   ALTER TABLE ONLY public.mrr DROP CONSTRAINT mrr_dist_id_fkey;
       public          postgres    false    268    3556    246            7           2606    29281 ,   opening_balance opening_balance_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.opening_balance
    ADD CONSTRAINT opening_balance_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id);
 V   ALTER TABLE ONLY public.opening_balance DROP CONSTRAINT opening_balance_dist_id_fkey;
       public          postgres    false    3556    246    271            8           2606    29286 -   payment_desc payment_desc_transaction_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.payment_desc
    ADD CONSTRAINT payment_desc_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.payment(transaction_id) NOT VALID;
 W   ALTER TABLE ONLY public.payment_desc DROP CONSTRAINT payment_desc_transaction_id_fkey;
       public          postgres    false    274    3596    272            �   �   x��ͻ
�0 ���+�%�Ds�Y�Z����$b�_ӭNR���K#���!�R
������:7� �	7m�~0���)�)Lc�3R�<a���2ԙ�R�\���p>�1jkRlX���-�w���/��d��o֘�`�\l�
�r-�T�|}�)!�PtZb      �   �   x�}�1!����W�'��':�4$��"�\j��� �����`9Kp��WHӽK>���7x�Y�g2���z�F_�t+���u�T��n��Z�2�NG�g�l[�V����?��F
�Q�k�Bޭ>D      �   v   x���;�@C���*ңٞ�k��(�_ �R��k��Fc5A���}avU�#A��u�d�/�5�:�0�DJq�Yᗜ+H�$����!�By^gjx�%��!"���E�[b�/sO!���6      �   �  x���k�0ǟ�E�V�ܝ,��2V���&c��t�7m\�n����;۳��X����F'�N'}?��M���l���3�	��tV���{Y|Υ7��榺ϫ4��W����������ӌغ	}4#���1��9G�d2��-ҋ��B�S0B��������dG��lS4����_�9�^k�5���M§]�Q����Ƅq@�D�dy�+���x��=�aV.�o�V���^6wW���<B� f���g���d:_��=Yd.�kx�W��C�3�`>�¢�� ɒ��0W�C���{\���;J��J�dQ՗��� � �սmF�$��UQ��&���#2��A��Evg�og�yT���j �PꈏN�P����¡iGlq�>�vp<�)(!J'X���A��y���t�>{��P>��v����\ZO�Cy$1�K9�l���i�XE"�ʄ�فFHa��v���ye8��n�_��p
;�K�1Ϋ�w�<��N%n      �   x  x����N�0Eד������mUJ_<�&"Q�D�*	����VM��<�����v��\�r��M���t����U����x�hC�LӪ��U�V�`2_�� 2_����I7u�]��>_o�❼�`��F�!�,gVj�Q�Q�xt{�H�ڟth~���-5Vr"9;j��"�ē�&L�����uZL��Eʛ���e��ҖT[��jstS΍y�C�b����7���@�C�!���2I8�y":SEY�~k��p�r��dNi�[Pt�'��"1��ډ9\�V��k8�k7�D�QQ�;�h��}��ECX��D�_ ��G�mVuVg+!�$��3oKH!A����߲��Y.�1�p8��\�Fq�B� ����      �   �   x��Ͻ� �����^
l�,��qc���M&V�׷lF��'�|9�3A��4��$���Ϸi�АCT��=�\��]�a頒5�Z6��ʓ��%쎧6��J�C�B5�'-�_�J��JjO�o� ���`�} �Vg      �   A   x�s	3�t�K-J�,N,����r	3�tL/�W�ML���T��!B�y�%@�	�[jj
W� �
�      �   ,  x��[WGǟ�O�{���ꮾ�6k�Y���{�/J 9�Y����ߪ����L��������t�TU���  �����?@��B<�g�?>ZAv�&+�Sa���_�������1���;>���������������&�Tv������������W?���jP�xt|~}�K������O�g�ˀ���WXh]�k�Qe����kTQ~ew�g���t9�C�o��7�v������C$zWHPM1���}&(��Cn<,gb
2�%�h�L|��F3�	6�),D�4���*�M�r,�P&'��`����Z�u���r���f��N�������PN
��c2���#S@ȭ5��؝��22:ӆlDQ�u>���V�8��L��&	5H8��XO�{�Pc���:(�l�Ӕ=����)`�N�I+�܁��(�a���)��N����?3�G��.��u}[؅��Ng[vX?��z���I��m�&�#0m�iZ=�} �����.����t����7�N�i)T�ۉRN��'Gr�]i~x���oM8�u8��B��{��5��\P���n.����������?J$m��R����upv3p���_P߲<?�+�:x����C�n�U�DdYqz��+o`UmwmM������(+��M!�������fV� �] S�S0N���S�{`���>�¨�(7���h;`�6FO�ƄDv+8���`����l��7/�� çec�g«"��-?�m�L?-d����!!(�un�k�0��%'�'a�/�2 ��d�N�{���Tn��I�>�Ó�یN�e�����(���<��������zT��UEl�����l�D����F�N"��;��X2���O���a�fe�Ό�� I��
��o�E}����1d������:��Sy�"V�����/ė�1TӐ��*�a_�#�J��rH��r/����Սe؊�.ԗ�ީD�Ŏ��!D��vL*��Ä_��W*��^mǲ'&��#��p���v${b~���I�2d���&�Y�o���W+܊{�{++��N�4�a(@@�q;&fʩxV��yqJ$y�z
�����zͬ��2����h�-R�H)Z��%{�W�/.�������G�R᪁N{�7�e*\-���M���B
��yťXED�!Nį�q�?yxx����������WA�Ъ�X��8(1�?�G`٘n�����Q'�ڦ%��Gg�X�P�+P"%H��Ɨs#���z���$ʇ$BPy�'DKu�ig�������)1$U�V�Y��0��~��Ys~�?�|�:�f�UE��s�+!{�x���Gvσ
%�ɀ|�����&ad��.Y9
q�꧎�x�,eϿ=d�]�cVeܮo[��6`;d�ӬI��������U-Q��.W�ؔ�)2�v���d�N$T���fA�0�`Ĺ�F�@6��h����N*�$���@*���܆u�q�^<1YPmQ+��\{,��z�
�[C����FA����873���И;�������l��|{���y�Z+��w6+g������Y��ݑ|T�u?�s�����tզ��uR�RWgd�Ү�֗�#"�y͍�$�!��ޗ�㎗!1���v���Tii�sF�	�b�rR<�A�M���c�{�	V}}܁�GCK���p�f��e���Q{�}�;��*#��'�͒��%C��X�^�`�M����.���9���op�Ǉ Za���Zi�
��� EǻÓ��ݢ��Y�RQ���#�vΏV6�aHN�Y��4�n�ɦq�#7fd���&�˯T�%�f��7G���j
�	�K�R��������u$edY��jUx5o�b�� !
��TmV�G֍X���)Ȇ6	Z�
M���V���QB��0-��%̦�M��$�yLu乯A��=��j��v�ؠ��6/��
�̫�}N��e~j�@
���G��Z�)� ����׮��QVl�,���U��zu����&a�[��W���{��uv�û_oRW$=&fL�ﳓ�����#��q�ARnBr^8V�RO�t��]/�\���'�����|I�:B+̄*��q9�ѽ��Ӄe}�۠ 6.6�ds��i��Rj�{�%�� w����Բ{�[�W��9�<ʉ"Ɩmʣ�@����C�:�����V]�]}�u�&d'�˰F�2�^���c��Hq=���9A�:���J���c[���6����Z���B�1,��8��j/y��mX��W����S��l���,�+a9E�M�j��ð������rE䤨�r�U�ٿ֗����#*��ֱ%MQA���i�	�D̓G���1j�S5���/_����'��ְ��_�
�ll�q���.�NƲgn��;�u����8'�׃���G	�� p�{'u�s���Z���	P�J9���#P,���N���Á��!}T�l
p �,?��hv*�WA]�2��<TY"�*z���[����O��_�v)z��� �iǖ+�v>�΍��_3��y~�u��[�,h��帿��+�X-�mHU��yO�T����A�ԅe�R�{����/����[J^xW���<��|�_Tr�E��	G�s�yѤ�>�z �q��O�?}�.7���W>|�!U��z���noMK��R������ug��8ʛ�õ̞�H��#���ؿ*�������FsS(��ݒ|D��<�q��+R������ؓlR+30/~��>7Քh��^nI����xz���� ��J3�2P(��	� ���9L��xU��	k_x@ rC��M.�!�\F��d�(�6i�(�%^�֠t����s� ��n��q��|�14��*�e��`��	NG���pܴ9�������g��S��mQm�|���ͣ��ڞ��Ԛ��|Ʌ�G�-ЍF)m-qҮ�Ł��p"%ȵ1��5Q�b�%M����׏��~����Y�m����|��V��s��,����>��>eټ��6�|+�
���^%^���{۽�Cb�#�Cq]��۔�6Pt���4�G�ރX3U[���8d�M7Md��2����]�XY�?�Y��CO�ĺ��*��Ճ�u����2;VY�S��^�˅`��=*��T�oAe�P������2k�5�V��:�J��κ�^!�T^�~����A�� k�\�1�,�Ǣ�>}t�ݒhJ�9�8P���O4D�cQCxa��I���qc�6YЌ<�A��-�r�'K�QjD-W��S�%-"���P�a5�}iZ�BN��༺�}��������|��tH�de��,�T�eu�@sLoQ�)��i��K�A�E�>�J�
�y���6��$@Vgn��-<f�A
�P�-e�p4* Mg�p�2�4����£��4|�]ˡ�y�M�k���W�GպZ5E�";�ei]��T5x��(s�%//a)���t�ܽ��ۢ�����h�c�� ��Okeʡ�ȟ�����<�]ɤ�	{f�rӞSU��&?��ʦ*�f3����6n3��rnT� �1*9n��c�<߱���l�&�w������ic)���w����̀��#��Ic�&�h�[��(�̿����эhn��Lm��#��YvT�Kð�����FK�{�VQ��6-n�b������Ю���[���^GI��/�g�T0h�rS��ݙ��F˒I�	���^��H�`,�_!�iD���?����`�z����b�G 3�&�ϯ�����l{��;NM��qN�`lE �vBE�����{ۓ?�"���?����79��i����R���      �   �  x��SMKcA<w~E�b��3=�Q/�'/P�(����ѸK`�g2�목���8����U�j�����z&"$�RK��k?O��-��+Sf���O��rX�N'�XTN��lss���g��������u�����,�Nŗ�N�BC�����	�D\̻����݀oo���n��&p�) WL�k?�R|���P�=�:�d�|48��
���̺,6��u|��%����KD�P{�@���,H�k?�E|;`�Y��ы{�~)�]n��,�'�|1�,[<���K@���Z�l�@X�ׁ��Ic�<�Յ2Q�H0�c�!���LJD�.2�(����X*�E����?��$a��*�"H�а��8Xs��귳��s��s��\Ăcc,m�'�4�ly4k<���j�U��      �   O   x����0���0=LJBw��s��%�:!���B�72x���
>���d�D�h����p�l����h<��^$?�`      �   :  x�Ř�nAE��W��h��߽#FQ��؂�+o�lE�G���ߧ��L����`#60jqt���j�	DC-�'wȟH�.�Û����z:A�/�(��ċ��`6��<��������y\<<-~���b�����ÿ�yP}��!'�u� ���z�ߨ�5 ��أ��b��L��<�#�H Q����ū��W��������ϙ�����!�)4R]D�&��A[@��
�b]U��z:`��G	�b$�I$�R���)�TGT	��QG���Y��`��3��>2E��&q1_�7=�Oӣ<X�K�Þ=���>��Fe�ց_r�j�qW{W+�/�(�w8Dd_�f߾ ��Ef)n)��p����ke��5�����%%MG�ZIk(�Id����$�L���ޯ&,��x��-�+��A�,��"�3c��-C�%f���J��O��z�������xԦ+� txi�QiIn˸;�oj�Ԋ��	��d����eg<�>pXوA*����m]"v��#�>�
8c����k׈��� z�Hl�'PQc4J:�E\�"kVA<+��B�����W��f"�U�0������ݩT��p�C��Io!5�=}Qi�
�Q���q@�3чރ�F0�����0�2!<�~>9�����ң������p*B(_.+p���°��A��kk�q	�9n�a�"�M�B������!�"���l_��C�	����(,W�K[�3Ow��6�Njj��6�Պ����˯���m���i��8�(�o�6�@��)�MC3-�)̾h
�ɞ�)�ƹ5U���^��g �$      �   v  x���Kk�@ ���W�^\wf߹��B�/)^Dc,�DP��ͮ�s(4����M��$&���l8�O'}�=���A.�(���\�0�a^+X��|��?���GI�do �8�s@4h�Q�Zr��-�U"����x��׽u�f�@~ߩ�[��m�W��1*&4>r�$M{Y2zJ����g�rI/��2�Ө5My�iаsZ��YO��to���д�i��u�-h/3^�2Q��4���EpZ���cql��_�OG�j�\0e�!�9-�k����dR�kKs�%�aS�۔�mu���y���Λ�:l�#���6�9-�J�M���
)���C�D�~�s$:�W���MݯD�R�ԌS��^�Q�hɢ(�n^��      �      x��][s7�~�
>mekK�q�,yw۲K���S�:�cѶ�Xr�r���~�� #͐��h[!+���C7��`���W'O�|��G`�� ~��������W�=Ƙ����7���}O���8�����=�����j��%O���o�/����G�O?ٟ<>z���h��c�Cu�xO��������������_����j�*ť��6��:Qs��5 ��$�w�L�⾳�����1MY�π��~*���-~�/��<3��w����z~Vqg����0>e�c<����������݂�oc������:?�w���#L{x����� �������n��p6M�N�W_�u�����������s&�
�x
����?�]�N@��]�3�����_^��������|~5�k��p��bp�%=;i@)C(�J�R$"@\��֬���Y	�����VlL�t�b��;816��{~|���8��	ӓ�g���xu�aM�:<���W�翟�g~U�x�zu5�UO��|w5��	g�����B�p���?1n��������"ïBĆL"����������6}�mgT{0�� ���"��ڵMiH�7gGL��ѹ�E5@����0�Qu5�g����@ƞf�Ĕ�W��0�G�-����@#J�j�C�ZT�N�x��z���GǓ�=:|t\����^\�9���<����09y?���|r�rO�tIV�l�k��*�qğ��#ᛱ؎ג��9��� �1t5<�i�Ѧ����j�Ab�	���Z#�J3��������Ä��PS�k�J# =��
�qBA��y9ΰ"�kgj je,/o���.U��BJ%��(�M��y��AXw�U����2�l�{Գ%x���������Au���T�z�7��s�g���3 �s��L���,�2�!���Z�����E:\N�����F��A����[�K��l�\���f,���=�V	R�
��K��T�ƾC��6%���!�-���0�wVpޣ�jkl��5����]�T[#�϶���fMA��OL����f�>�_\��WOC�`*]-�ٰ�ַ`/bd��Puj-�gh���Z���_����&��'Ϟ<��dv5�8�x�>3�Q6�;B;�Iڢ!�J�q�hLޒ�h(!+i������*dS\��4�����>���� ����w�1��c��;Zx��dӅ:�tF��/t��ok,^�8�6�� ��;/�?�ƿ���o��:�\��A�+��A΢Fe��R�3r�5�F�o�*��j��"Q$��N��l�OV���~|q~}�]�%�*�Ў�!᝼�]�#�y�lv1ߔ�V�=?|y������Y�L�x�\c�
����#ѰVIS���"tV
mq��*�t.o������������œ!��G�x�����*��#]��TTP�qQĥZlmX"�G�K�����5�E��x�D�-���6XSVO>�y߲&�i=|�|9yx5�8��>�'��+TN��a�D�=���Q���D�ˢ�Br��D4�B�A�����4�{�ʧ
�)��ϡn�842(��-k�ⱘ;k���7k�X�tĘ��R�Ǖr�y)��`-FJ L�e���!}~9�@��ɇ�����o����
;2j��h$���̵�o�l�YRvj+�s��H�ԔA���>\��A[e,n�H���i]+4�� �U��r�OX�W�(�2!��>g�u��l�O�����S��-��M��)�>�V6y�}��f�}��*�q˥��"E j�R�+��u���Pj�B�VZ�+LQ�͋\D�.[�'W��j��F\��3��BZ@(�c�ha��&���o,��Қg.qe����7N�Cn�7��M�;��ʸ�a#DK�T�e��EB�rdy��	^ű�8h���(+�)�����#����[{Į�y6{�w~5��ϫ����q�.K##�`�k)3	a5�E"EM����L&"t�Dc�0aE�Ę���_���Ʋ����~�{�K����0�m�@k�7@dT�Je�DLڌ��ed���l��c�����#��)�ӢF�w
Wa��EUrl�|�RL�q��n$Q�.�~�O@�Th��v,z��@�����'''7�?<�s�N�����?�0���@<�k�Q��"�`ː�&8�	đ���w���xI�g�p�oN[�4��qR�YY���7�L�/�gW��ą�']�v.�v��v���0I��F�*i�@��h4'�o�m6���tA=��%���IJduNmbN�8!�{�(�%�I�^�����R[���m�Kl��%���]K5e8�����j�༫$�n���-�An$8�*]+F�1k�
 �隬��=[������}G�|=�Օ�n�9rP���<���S��&܍&Ja�HϠ�y�RF9%El|��xM[z��}�2�?wq-�+����J���%n����w������7�/r!o}��Ҷ\�hEl���VPs�Q�k�s �C�<3�6d��d��Qv�-����r�-ό�_��q��������,X�f(WH�,�Ih�b�'Hh�QE1�l(�3�8�A�T��0�#6�F�A�A����r�� ����0�8OȚ��R'�0�Ô��� MN��;�fqQ�=���6�"�`*e-��>f�l��ĉB��wG�-�ބo�C�>��6R�/dw ��o�l�:w�,�2C Db�±w�zfvJyij��pn;y��&F��qk�}�h����=�`&��ؗ�ۊ�Wt�``�$�H��?z����;��E��4oξ(r�+�%n��j7���L�2�q>E47����8w��X�Yj*GyE�*u�+�p�EM�*	��2d��֢�|,�5���D� �@<FP��КND)�FQ�L'��T1e����7(Vb\~>	>��$Н����ր<�&HZ5�ZP���Ti�+��kg��������� ����{�ꅵ���h�M��EwhŌD1� $����X&(q8/�s$�: oV�s�!d���מJ��P��8L�J7d0��x�N�ֽ�U���8*�e���ܸ�Un����&��k�JG�v�#�s�֙� A�ac6sI����V����%�[�}��F���!+���b$Y��u����gp�	��$�LӦ�T,{�ܫvl	�[�r~���$��/Ol+p.F����P߻�V��U��c�!�J�.�"�eû5�����]��������P��,P��� �c�GCO�HL8)��-�LW#�[ޗ�@��T]cy��Z�ٱT��h��V�O4�^S���F&R�C�ZB���۹�`&H���oO��b�߇z�R������C�A\�������H(0���u���M�TQ8�Q]��yC�<0�y�m3f6�5���0��w��2���$�s�9���KnI,�_o��T�ں�
�+��_�4�	�6is@H31%J/V]����RB�������,�Ga�4��f�q��:���Fٺ��U���_+C;���}UkG3�`��N�R�n�C��X��1KπA�^�,m�c����-3�*E4��}gV�hQ�Z�FW�Z�ոZ,*����n�.y�!�s�{�ԎÚ3r����L�[1��o}Yz�ïy�&Y�z\�BRAy��p�恌G6G�p�b��g��~^���Gw6����_���a�e4��^��"!10�*Ws[\ol�Z�j�UQֱ�D)wk�s������q��Ѯ�D��ZSr�G�H�#���*���<GP��@�3�X�z7�S*���h�v��e�H�Ֆ"�߈��h�B}��C,P˶�q��a���W�|k#xc�16��4W�+n}�\�r�sys�M�y��������I�l�g�붪`dn*,؜��
�ۅ���-��4�;����yV���ѻ�Hb�s����U�х�����,��Q����5�qA�,&r#$�ED���1��elm�p�8�ژ	=��È>r��Sr�v�A����R�w�ْ����������X�9���m8$Ch�8x�h_6�W�u`��ࢷg �  ���elk���~�#�����Q�A�m�+��Lc�;�6͑�*Us��uS��v�Ŋu����e�W�h���T�
/�(���Bh�#*�#f@�&�r��(wf@PY�=��g)��l�������Ƌ7�\y˵���[GKgo4�Fο]���7Z&��bK��A(V�2C]�jn�-t���\���������ro��`�����ID�`��W�z��9z�Ϊ�:�bm2`]���N5�ݛʁ��InJ���1^�g��F�q�<�Uˑ��i.���_�2��]b��.�����U��E��5�f��H��X�ZV[�	9*�V\�2�I�������Ǻp��R��k�/�E�е��ր}���;����W��F����ݐL7ɍI��:nI�%sDM�ح��A��SOK=�jz���h6�V{� �yՀJ���,V�R�g�����h(��ؓO�ʆ�UCΧF7P0<x]?x��;���      �   >  x�]PIn1;K�����ȉ���K/R���&9��"%S́P,2�$�T��6�N�%���yk���^a]�4����G��2�2�����d�ذ�z�Z�G�,���VB���ۥ��@36>�u�6;Zn`��e���|$��D�|��ъ��K&��*���%n�X_(�tD��]E��D	ѳQR��a��Yʰ��	B��=Q���K���J:n;x
�~nu��vlz�Wt�A����>�zW듍��b�3U�h]ܲR�B�!�1ԑC���`s��Dn�RP�|�ѻ8{�zy�O6z�֧���Ŀ_��̓y�      �   �  x����n�0���Sx_a<�e�]���v�J��1I{H�	
��_sQB���������go#)$�!��s��`\W�g�e�iZ����1`���a�M����|��������qa�@��NކQ��5����L@�6�E�¦8�@���0���^ G���oN����؏�f���g��u_�����]!!�4'����$L�Wڱ	g�g�G��DI������3��P,Y�ŦE�v���U��h3��&eZ�D�!Z�0�I�W�������JyD.4�	;P}P	��/a�8�mq��"+Wl^�"]���}LQ�n��h����Gõ��вM���=˅���˴[�wR�{�͋�z~(�H��I�}�����׆;e��u'1N��t\�?�`0����      �   �  x����o�0ǟ/�S\����6��۪j��j/)jCV`ڔ�~i��
c��������8����y<��+�N�ᶬ�y������%7^O�	��#����/q�J���e�YSV���
�3��}���;.�+�h>o��|a�nw�n�u���'�cΪ�9�"�@Mvv��%�w�6�^e>��@�c��,��4��܇ɔ^:�9s�zm�Jk��S��$�����*l�c�B/=C��(�a�����Aؤ�4��_�gQ�z��á�l������C���>��X|?�+:�X�S�'�(��;��!�0�bA�b���!��{����e�'��XΕ��	;�c��t��xƏ9�	>�St|�9�G�$ʱ;�?�Fs���Í��Ej/�)=mEB������e/�VwK�'��KŬTcr�BM��5�h%��i@z4^hf�}o�[,�`離      �   �   x���;�0��>��"�HɎ�ct�����A��6�E�Ah��b"g �뒶'Nsm�X�	��m�~�����^,I��:��k��LP���\����ډ�~�6��m���u$1�Z&ڿ=z{��o9�+#��>r��	�م2      �   �  x���[S�H���_����2������ /e�y	0*����~gDd�-L�aB�M���y�^`��9�D��Z����.�go�h�������>�'�9�X(t+ug�!h&�$�N3�z�[�~:�h�N���9�94��?�V�1�[���T�+��^7�tg��9�R��A�Z	xy]�ߣq�����t㗸��N<$��Z�p �(��t��F�C��='`�C(�<��a���V��Ss�n��n���!���8�~;�՝�]T��f�O~�-$�ݝX�#��Ȧޙ'Q;+���xM>�&�'΅TP�F�e�O�P�n�T�����I�F�f���O6�O?��QC�]�����h	���J3�aVY�J!�Ac*��q�`)�C���s
E_�a/P��(��a�z���0h.�̕�H�R%оzt��/�������ի�[�j�0l�6 湭��}�B���_�#�(U�>r��/�C<]�F_��v{u�q{�=,\�w�}�?�~�t�3$'�ڰc;lEAp��������yZ����[��ZLK-�t�{\�ԩ=qIBen0}]ʞh�<�C��"�c�іYv�%��F@�0�=!|{{�h�H$���-7k��k�O\J.��r�L���!�0X�a#�.&���N���R��B�xQ5�j�� ���0̍��+�\���H�͏�_��#���٥
���CE`3⚱�$Ǜ��	�2���T��e����P��vѬ~�r��U'R�`�aS��Ț����3����<ޮ��L)���ւ�},��s��rނ+�o���E�*0��RbY���� h��FI"D$G�J���J,�G.ju=����'wH��])l�R����2�dI�������$v�F��6O�.�Y��-C-�`���('�(?��A%$���C;�L�:q�`g�<�\	ץ��)�:f`�W<4p���ܣB������Hì$��)+��<�O�T�r]����K��ʯ˚�n��w}]�<���Vq"����<�j�L^��+{=��+W�����h�D��!�������:q9DA�ܴ����Y��~6wA�{,&%f��OCM���)tPX"G�a�j��@���$Ր�����@u�E��y>ŋ쯘H��'IڍG�"�Gi2�T�y����қScy^(����v�y�<�����˳�w�~�ggg��3      �   V  x�ŔKk�0��ʯ�}mjɒ_��]vY��2�.�0:�l���	i^-��������l����h���qWls ����[�{/�X�J,>���󰛤���tQl�M���(GJH���s��O�)b�ڰ�i��6n\HPM�(F�P/�d�*�Fr˕>ր7�@��5� /�1b��Gj�O�`�I�>�}L��:Cn��v`�������.sʷd�'{���y�Z��&WO���C8@J@�3&l�~�(⸼-��i]��R������>��S�X ��4v�5��r��@�I�C'��N?U�*
�K��N;���� .rr@$�\�e3p�fI��o�Z'      �   �   x����
�0E��Wd/M�I}4;.��R7nB4MI��_�c!�"�r2�{�@�e
h�Rm��;46G/*=d��>"]��ߟ:�F�;�O��ASi���*�+ QƁq��ݜ=R���l�A�kyP�Ш�ΫJ���(�YZ�VZ�����PD2N�����_�[Ӆl�G��JW���ݚ]/N`p�Xq	�������mq�7���B      �   C  x��Uے�8}��
}@L���M��.0����h��f��M���3�-%�NK��V���"?��lqg������5Pz؏*�tôl�· �����+�U��'$|W|���2X��$Bx9�zY�pս���2�>��d�xTF�xA�g�7�灷Հ�1��!�x;aLF�xA�'��A�`��I��%{P��0%��5�h	���A9��I��V�TY#(�pk,ZU0cs�娾�@#��C�'��b:��e�w~�qy��5`��a��l�,� d�0�w�t���(����iF�����4�}�}���������5�
���R�[�+HY4���I�L��{��ٕY-����Dmal���)%�!�N��cY�e~h���Ҋ̊�l���ϗBq�9�L(�l��(�L���J��{��/���MQeJvY�X�IG�L�9�j���v�n9�yؕ�����| u�3�D�S�(��)�O��Ǜe��jO4J�:���6?6K�{>��=�5u-�~�=Cz:��4��� [� u�nx�4�!rq&�n;�m���f�W����)�7��L�J�ކ2Ų��^���y�6`� 1��h�E{��כY7�n3�(�EǏM,��p�H��E��"��2���kʣ _�2��%�k2!~�\5��T���|�p�����*�e8*�R�1L]c/�u��M�1e�b�}="�~U�O}9�?P�g����������W[�EW�Z��޺	ՠ���͖�.BGm_�m���c�Ŵ�.h�������Gq�4�����ʨ?��"�Ό6u�O5S��zK���������      �   �  x��X�n�8}f�B?`�3��Eo�M�-֨�$��
w�6IӤh���;�|�d�v����9<3�w*�h&�Bq�FAP�Sybշ��Bn�W-� 7��h&�&�Vj�5��0(`��z��tQ�ti3p)��d�p�����ۥ�8]46ק�WW7O7�}�)�����R��|�ݛ���DÄ`�	a|n9�G	�_�w����������q=Y��Scȝ��@���_��.��d:����NӲKV�v�&�����nE�=�ć�+�&$�hay�����a��a�-
�Q`P��59r,��8���$v��R�s�?�l}�G��4�}h�݇}8{����=����裡Ѩ�D}�2� ��涪7BT�w��U5��^Vfxt��+������{���X�Ʋ�oo7�.�uZ���ea{g�"j���pϦÍ��^���d
�t�7ؐvZl��aB�#^�H�#�`{�d��&6���N{�@r����ǣ���#�D����E�#��� ��kۿ�~Y�/ ��P�� ���
?����m�m�)��u����|�, ��	$o,V`k�5�"�S@$P��`2�XI>5��j{{����W?����A��B{ߚ�@n����ݗNL�<MۘR\KΓڀIv�b*/�X�sE�߱��=���G^c�m��gb�!��l%Ky$��@�� �C�&�D]p0lj�ve���c�2h�U�T����%�^)y�|����6����a:��̕�>i�,\�0��S>"ĎIPGС�h�4\bG��N��%c�ZPt��%7�ܡ��j2RY���x�¾���X�{��@�-K���lt�{M���hf�(��U|?K	�e���n��@�
�<�˾�ge�fM>��tGp�9�w�H����#�Mބg�|̄��8��)ٝu,N���)U�Ԫq��y�:].��}��������m��Hp/�~���$�P!�k+��(猡��Y��(�1�-���v`�^��.f���T'�����._�\�������eu��b6}��4o�{�!����i��Yo��0�&�Ŏ�����o�����V*�Φ�3��Ioo�o�G`��6R��!)�r�{)^��?�G�
�tP���89�mL�J���?��i�Og���5�f��}�k��~������2;���.]����u���(լ��2���u]��G=jrx-� H?�fdS$������e��;LM�0�a��c��뇇���<�����"��,k��)�P��{
箅���5ܾ"T 5�y�pA	s�$�>�\�\�dŌ�ܱ���䄚J���Z�S��5}�����Y�œ���FiLwajZ�n���uR���"�K���p��u�H��1$�*�:� ���A�;�b�^h��������l�(�^��^����$BJI��zq�R�k�\���I��={�~�����:��      �   `  x���MO�0@��	�ݤq��i�M���K��@�6���`+q�E��۲����a�	&���Y��AD[�;��yE�`�a�`�a�}\��L���3��W�Y�6���L�!���}�ߍ2��ہf4L� L��Hb��e�P^r��!1�� V��y1��w��Я�Q��P !%�T�"��|��Qb����e�C,N����wp���U��A���ZX�ooΏ��%o���|�H���#U�iB�*P
b0�[��� �Q���g"�!��
j���ƒy���BS2���y�/�Tä��nQ���2�Ѱ�_Ǣ�l!a��f�g��3�S��a�޼nw�5Ė�juUU�7.	      �   U   x�+H�K��K�O,�O�����*\|�
rI�y�ȲN@>WAbf
gpirrjqqZiNN�BAbenj^�BI��KjbNjW� I�#=      �   j   x�U�1�P�9>L���ܥsU�?��b|r,+4���]�G�ü�ՙ�c�E#�l\� )%薭��|i�h�GS��U���fk>�&�ϋ�~ ��:E�      �   8  x����N1��g��/���/C�(�-!U�&4�D	y��z����R�\���?c�o�
��q����9�Z
���E������㦾~YԌ1qr��9!����i�K@Lv���,	H<�iT�|y��2m$�I��/1X�� ��"�|Ju:�h�%�Ғ4+��MUEx  �gSv��ͥ,�t��MRv5g�X�Ad�T��T��0=���q�>���xfA�6qz����zGllIxX-���ݗ��=o�|�Z�wE^�x_�J��&��F�/�"��)b=���T�H	��,!��;�HX�Y�J���tV��?�v��A㨼�R���	U��Ҟ��H� 3J(.����x�ݘ��[Р�bD���~�d�J��H&�L�<<%�(m�����j�]�VO�׎�c���3����rYX}�7�#���C*s'R[��, t�kߚ�3Ω�$��|��t��}3��C��a�`
6����܊�Y�����&	"y��a�.�}\<8��t3F"V�����"�gySX���̎-�1y<�FÏ�ۮ�q�cۥFk��\��f:þ�q����q�r]�X�m\�&�8z�\*���C�w���z�Z֎K:��-��F��lhz;5���cO�O��|���=��<� �d7�T��T2�����Ψs�(�Ry#P����;u�XÁ���QP���Q�=�}z� �����DQ��7wƚ(��������������J֧{�3*���ƪ�P�>�����u�S��X8���ʏ����hعr
��!a�Lo�H2f
���ZU�?cq�      �   f   x�e�1�0Cѹ�(v[�����1!��)�I�$6�����
f�����&:S3E���V�a�i�4\�������4���W�_��%a�~�rθ��x }F�      �     x�5Q�n� ;;3�~�i��@�
��I{��X�m�ql0,�]�����K#3(��k�;ƭh�R�dn#��YwO�t���d���q�1����ټ��,���N��(�
$�V��m��^����c�+�R��z螑�'{G���şn�Y4�Ε��*�Z��T)�B���4kz�F޴� g�r�פ��¯^uXI
�?�R�����w8w�t�P]e����c/#���
�s!�D�D�H�ƫ���׊�o�M��N�A��������~ ��a�      �   �   x�u�=�0����W�Q��"����BI\\�@b�Tb��tqq8y���%ˀ	�m%1(�5�;hm�`�0n"h�=WبU<'�6X]l��_��������F�M��55N(
|"/����jgo�ϾA����P�]z��Fb��8�B�7��0$      �      x��}[wW��s���'/��ت�[��H,I�{ּT�Q7�<B����S%������D��v�#"#v\��sڽi��ݛL�����z������������I7�5??�=��ɴ������q�n�m�p�i� h	�z¶Ւ�mN`��-���t�������mS�o-c.���}1]�uL�>�	}{F.��v��������|QKV�|K�~�]�uR�-�A[�`�8���B=3��Ӗuݠ%|Q�u�6�e=3p(j�A[䦡o��������f�KЖ�ڠ��j�A��K�[YSZ3<΄�j���%L씹9[lh�]__�/on�v�4�|�襜������R�4�5�Ɠ�/亭O綽�|������o���_��R���%�j��?i�Pl}8�J5͖��W�Ŷ��>�leӓ�J�	m���ĳ�`����}�Vx��i�y^�-�y��Wz/���5*��>����'t�_��:�;�N[�c�����߄u]_�VXs�iq}�5�����7am@�e0��LZ�}��&v�r����������d��^sp�!��2���K:�I8)�밊�,q�s\�&�qzܱ=�n֠຤-�+�a�u Hqz�V`Xh]R�a�tI	�p�MױD�*	��%���P �*�@�e�D
+��7�T�,�,�[����$�p�\��Um�7K�Y��0�T5c%R%$]q���%���R�[�a.Zy�H	���"����&"	W����_���*�L*VB�TB@!�PHa]�J�H�+���P!�] ��,�b%T��B*喢��[�����^�芓��P!�u�{�BJ���X	R,8��^�8�(D��i�g�T6y�J%Ie�DR,��U���Tٱ�R	ER�J%��]�TB9cER9�D]��uŽ�TBQW�T��")��V	ERW<��J(�`���UBѱD� ��._|s���Շ��������d�7��������t�������~����y����7?}x�`�~7���{���� J�:���R�� ���ay˔:߉�����	˝d�Np]�Fםxk�83��;��]�:�[�Rg;�u'���$�]�ְg��n������"^��S���Ԭ�xk'���d�bg��W��%KUvJ&JegBP*�T2@�����	A]ɌŤ�3!(u'Y0����ǯN�N'�rn6l��d:�V�F���IҰ#$9>�R�6�J�9ם�"����	J���k��]���?9�?i�{���Ѥ��*^7@�v��Q����Em�_7�����*d4�M�7�����OW����
'mNkdt8dN��g�Ns�s�iD��i�bg8��A(	�z<�;8j>����y���MUFל��֐EŨ�NN�#ΚF;Ü�T�pF�4��3��pղ:���J4W�n�D_���#ީw��_5q�^��xtF�#:c�F���Ot�Ne�:�� ����D��_:�N���ʣ����h�x�K�1��5.�1h�۶tư�5��Y:c���p�r��b�,[zB>�L��#���HzG����=�{O����L���t_r�s^]q�;����)݇�"'q'?`P҇E"�"rXp� �L���S�ߐ+��@ȝ�Z�ۦ�6�9��W��v�ɝ
\�snr*pa*�&��ؕ� �s�����BwΫN.t�ȝ
\�S�{� 'q�rթ�9	$�^.��,Kd�9�U���/��7�
N�8��&p�v�S���7��l,p��&d�rڃޜ,`�l�3W	v8��`�sol�9��Y�`�pGh������,-p�貱��B����Ĳ2�f���էͯ?ڐ+��Cȅ�n����%�&9��T�M�e@X�B7�97	��4�s�P�Md�"a���k�^���;�U�P��s�B�6�)ݥ�l���s�*�d����H��A@�%2���l��-�ʏ1{����#1��Mb mp�j�	f��Zb`g�ԒѬ��ZB��$s��l0G+����0-��2أ��@����6��)Zb�a%����Р|ex��}}ټ�T�ǯ�n���`B�����0�*Iu�a(au�.Cñ�G�2ZǱ6u�a`����P洃��.9e�:6��
��a =-�%�Ӵ�l�	��a�a���6��U�*?��������j?�{����jˢ�GY�
X�,%Z.m�T�ݧ�����e�])�=�|ޕBUw++��R�kK��-���.��³5�e�m�������B�wY ӑ,uF7`�/�V�X4�?�����rå�)'����sY8�\�:W�.��ϲ�H�2;����t4B^6����U�t.�J�vY�B�+f���
q�-C��e7�+�P�0;��C>�v+�#*VEc�{Wm^�k��z�b����@����z�ʝ"(ˠ��,3�e��ж;���f�y[zޕ}�|ޕ+��A��YZޖ%o�����g�y�zږaS�Y~�s���2l0�� L����*��_X�*(�Y��|��Ya�m�+��+`d��+,�+�ʯ�ϻҬ�
bV�QX��Wl�r_����Y�[x��+,�-v�WX~�s߬�
K d:��ʯL���R)��,ʏ>Q��[,�����BۢV~�)J�,Z�XxWj��2�w�V�-Ĕ
c�(�o٢�e�}��[��,Z�Xh[��o����V�-� �t$���
�@���:(��,�oSQ}�WY�	Vg�3&X�Em���ꨠۢ�
�b�����E�`u�|}��YԩOG�~�1��,������:�}c�ս0�K}��Y "9`>��v���(�_N�<��tρ���A	V_ %���A	�8�=���LL��q@	�eup�ꈲ�����j�`7�꘴F�j	V[%��`����x���V�%�{�67�����S�YJ�m7/zã���_@�h�0(���j��5U<���J��J��`�b������ ����q/(e�TP����F���qjhP����q�qP[�^��vce6�����R�LFQ�2|� �G�A	V%8�W�jq0{4��ј�K��#��� ��euj�F�%��(� �1i�k�j	V�%��`�lPB}<T�I�k��Y��f������g�\i�{�{�Z�3P�;�,28&�����E��S�`�X�j��T��i>�J���Ʌ�d���i�\FL[x�+�˴�gQړ�Bۢ5 �%�>���b�@�#Ykf�J_ ,�rq�w<�X�� auT�*�p*����Z
��:*�>��΄�YZV�B=bTLT�Q�P,�Z�bQ�V'D��auJTD5f'EE$�E}��:/*"��ՙjvj4�ZQB��巹���l)l�	»�'�;�����=��Tpᓀ'(+ ��;+ �	���<Ap=�0����QVd��Q� |��%aD����8ʪ����	JsR����"i2-i�⿸�4��b�h�Ţ@e�(n�Xh[�I�z�����-ޕZǶ��]�ua1�NZ,J��lQ*�e�}�/Z��,Z��Xh[�޷�S�}��_#�.e��AG��c��
��@�ee��;�.�c[ N�_8�&�� �s �&�(f�q�2"ѱ*�G8b�~� ��;9�E��4��c�Q�;�1d50��0���Ψ�f�r8���+��������ޜ�W�x����{�W[9��5���r����ɱ��ڎ���p|;�����g��I�������3ށ9p-u����O9p�t�I�;��99�Lt%'��pN�S|6p�d�=+߳pN�;�F���]_>}�r����������������&G�j�w�xè���1&
�����U	$�<
N�qUu��������5��FQ>q��!g��΢XD��G��6l�d����&C���A���,
�uG�1PW�-�n��]k|���m��rT�$��a�G`��`��p�z'��$��b��"�j0��"�И�IB*,�Rr1��b�0��$A���6�a���)��CS&)/
�j6�aْ�9�28��{{���S�jE�QTtQT,    DQiXE'Q�X�H��3�(*/D�S�{^��у�F#��Uu�XY�ʋ���"b�'*8���Ұ�0��ĸʫ��F�i�!:ƈ���R�Z���5GGG#yIʹ_�����$h����A��p�X@:A니$�$)-2�oI�i��}�|-�C��um�;��Ђ8�gZ.`�� <�$a�c IY8��� IYq~(�p�˅�(Ȫ��6([�:l^c�[I�鬹���� �0`����;C@%�~
C죧. �_a�$p�bm ��//`;��r쫹�Am$��_j��1����P�5ܷa�vce6��d�P�n,��n	�
�eVN���]�23��Ffw���6û�'�ێDftw��\$��Q�� Aw;�h�{�dfpO�l3�/M��&��}���5��G���f��*�U~��a�G���UY�+�ó��W%��9�eT�y��Uw�[�U�1h#�b.<[z)��p�1 �j� N4 ��lUl	Q`�V���8��h��ɂ�QFp�X`ڈ.�a?Fk��+0���t�V�pA�]�z{z֜]|�x~����i����������]|�p�|�����Es|�l�Ns0�����ezZ��Y��E��<����^�.OV��W��}&����J�~Ф�e��x-�J��U�^]��>я}^��^Vf|%��>O�� R/+�NǕ��쵙���|���ͭ����/?]M���l��ft�?����9�����?�r;�vӏqZ���lS�q�%�!w�qږЁї����v���F����n{�/a[���Ŷ6�8��ڊ������q����7�O���ɦ޹�R!�+�F,��F,�:+E�,��B,�a��q�\�5��uECC, ����b�j:3����3C,�Y���Y)�1�3��r�ш)舨Sʭ�n��P�4J���?5�����yq��������;}���쨙��n�-�:[)n\�k��r�-rťbWt�Z��Tq�R+.7�ǝ���a<�n����ks�[�b���>\�]��q/���]1ԊK���^1�:j�%JjE)f��$Kn��%�j=��㣳�7?�>=�S��Gݢ����C����f�_sx������I��pU�$n�z�۪'QAY����O�WeU!j��M�UO��2��'�"�o�\n
��=jP���?�����PݼʟT�����VK���ʟۓ�Q��I����r
@��l����͠�I_6�]��|ը�Zߤ��U��}j��~����9o^��s��?ח��hN�l[h��٣v�=꾝l�|��$Oؗ]�Y�f����1���2K�.QX��Y��}�2�v��/,�����-31�̀U�f]��>ӛ}"f�^�f_wZf	��}�f_7[f	K�_�[f�SjNM����|�����_���pq�~��|���/�ϛ�'8�'���?�gQ�E��2nB=�|ⶋƞ���A�eT��7�U�h �� �6n+n�Qp6SN�1���%�j��mM��9� ����7�������:�F׃���=�Ҷ��k�{!�]���t-h/&o���23[?�����1����0:���|kW��["��	�h�i2�!Z D�N��y�� �L���C�#`�s]�n���NKD'�q1�uB��i-:L&�pBb�$�gQP�+�-PrB%�v�M��|�����7l��3��q�q�g���f�.j�#�c���ɡ��3�W���w���dJi��4��3.`�����9Ԍ�E�s�[��ʴq�s�9��*J��y��pQ5���?�/��^s�����]�0)��L��1�"L�S����bO�L�j�1E�;���+1��4��FlZFl�Dĸ�c6E�ƅc
�T�}�)�H���)y ʋ���ã�OO&�M�m[k����Z.>�(�'��J�iekeZr��W��\9VDZ�#ȴ�/��/�F�B��2r�i�L���X֗�R�e}	Z�\˴��Zq�i|�|S*�L�`�ǙVfe3������|�l&�g�
�r�.�P����E�a���2�6�����KTC���2��+Va]�Y���.J�H�a����0^Otm`=]��6�Ŋ��@�P���؜.V�]V2Z�e74�BF�\^\_�߬��h�__�v�a��
n3)U�a�p�d���MZUw�$��ͤTw�)�\��;@D��T{=��8Lr-pl��cS$"���aR:���I�S�O��t�)y ʵN�Q�X�VY��ϧ��=�W��
�D�,I��R�D
몮�KR�4[�����O���%R�t�M�
�����*�*k���ʊ��+�Qm�[�'�ֶ%RXWu["%p��O[��H	����F[]�K�˪��i����eR��G�f�, _�Z�r:����{Dg ���\�4-����y�� ����������ޗ3,-:���a1�}�� ��2�g�Mk׍�F�%M�sIS�^���Hu��S����FI`(ԍRg C�n�v�yQҔ�\�S�s���P7J} �n�4�>R�(i|�x�FI����]��/�D|Z�����(�Qi��QҔ:�4��%���T7J9�/
�n�4 �B�(u0�FiW�%Mϥ>e<�� 8u����FI��#Ս���g�n�4���ߥ�Q��Aħe̗�o�=:B�(iJ�K�������Z1�i ۅ|�H�^b�,�{IS�a�O��>�����> ���%�����%��B��4���ߥ|����@|Z����F���JS�@S�,��4�> �)|QҔuC�0,놠3�aY7���h�x�)�Y�����> MY7_�n4>@<�uC�Al��.��H">-b���?>��mC���¡,k�FYf�J�>]�>���G���g�;��E����z��R��UH�,rD��)�JYd��'�RY�TJ�GBv�>�-�#��c*%�K�E0J���yWm��9�����6��Uv��4����� �@��3�c��Χ�}z ���p�<�N:M��p^r:����}}��V�A������N��}XEu_ 9���~���]�n�o���:Ѩr(D3�h�:���"��zD���G�\!����B�":-��W��!��z@�q1Q� ���IアQ0.)�[��,&B�����������A٩�1���b��D�,��:YO]m0�U�b`'W3�h�qr��P3�bsѲA�K���r��l`��i1�6(�b����\u-V2Z��l�]����Ͷsc�q���W�o���o�'�]����1��P�xA��猁��Qc�8��y�Zg3�_`m�A��\���3Fg��k�MLx�xa�=H����&�����2��n�`e�<*_�m�m�׏7tʎj�n\;U�H� �0��:���0�quT�@��B��y\	U{� ]���1.��~ ݸ̩t�~E�W�P���W3�������~C����ytz��~�^_���Ѱ�|�aP�tc�
0�X��@�0�r�:��gm�Y���Ѭ�V�ѣ"	0��K���+�	�г(���b0�~`s�'�0.� ���]���_�����r>�]��)��M�Q���f �����a]^����~=�s����R���[����X��:����1��P�C���䍋�N��˸��~C����y4�.I??n�����_Λ>\]�r������Y���3�*��W<y���]�ڋ�*W�k��5h�<yTFI�F�*�+��4�yV����* ���"�ƅ����&1�� 7/��*H� �qUWӫ�[n���N�]__�/o���I� �q�ǩ�y�q��p{�Q;�;�g�'�;���g8�{<�`�8�a�g�q*�� v���{v�cH�p��vm��mZaN���3
Gk�b�q��.Wƥg�+є��8��4^��qW�^|s���Շ�����������l�lX�m�,��Ѭ�8�"��u���va�>nk���xH��0����m]�m�G�*��.����ö�Z��xm��O69�5�9�6GbE	���ͧ�������ݶ[*�    ��2��g� 4e�4e���GS0�-h�4e$��CMLb���_�2l� +��X"M<�m�&	2Цlʨ�nӦ���H��h7ed��>o��n�zF��ȹ�����]��Ջ�/&�v��`:�n��e���etu�eƳ,xږaG����,=oKϻ��ϻrś?h�0K�۲�m὿���,=�XO�2lI0K�/|���S��f�#y�,��	��@X*�bo���\�uʢU~�E1�bQ@�Xh[��o=E	�E���J��[���*���Ra,%�-[�ܷlὯU~��E��m�Z�-��_���*�� ��d��[(}��T��bz�Y(?�AY��o�(�[,
�m�Z���(c�h��b�]�U~�|ޕZ�S*�Ţ�e����-����o�³h��b�mQ+�����Z�X ӑ�V~+`�/�F�x}���uszs~~}q��S���i������4�pF�4{��L#�lN�c8��H����P8�n�`k/�Ө.��F�q�ǐ�p;ÜV�q8�v�����3\���pƽ��m9���񈿫`��^�8z���<;<y�v������ѬoN~lNOF;Y�8�
�Eo��a_���y�
{����k����UV�.���.+쭈�U�s�
޾�>n���5���W}��������h������5��Ժy��w��}��XuFW�+�+$�{�� !�	���+$#ؠ��lP�u��gWR-]L���b��P�v1��lWH&Xw���IF����+$��	Y��~7�S�WJ"�z5�k�����d<34h�PQ�+����ʌ�L	_�f$lU���S���f�?��5�A�ZeFj��vœ���2#eI���UP�U�+"��j�UV�PWU��\U�UU�ո
zKS��dq�����a������të������51y�����ί�M޸���&�s��,^���"6�cNL�*b�;����9���uΠ0�uN�0���+�4��
^�D�7no�jb�����^yg���5>��{�5��&�C�>~urv:���z��c3o��l����UC�3�~A�s�߻���q�=�O��g�%��"�^uѷ��KRҿ+R~G��$>=���`�,�d����{WfC�\|޻:��^��6��p���i������f��������?������?�L�?o�R��i�ӳ�lot�]��M��JP��=x�v�t�S&���		�靄�OBB-�Ą���� hBBuDighHVG�v�0���`B�r�.��r�.�CuLjgt8TK�Nq&$���jGo�㡺Nj�;�Y�����DT�w���]l��$(�@%�/H�UKXTK�š��0�CW+a|!b@BuD�/Q YQ���VKh�qXV�P��8TK_�P�øwG$��Cu�_X�P����,��Du}ǩϬ���w�'��&�v��x����O����ʗM�~������������H~�����=鯞���׊�w���oI�����W�����I|zN�a��Y����9����@�\|���[��xM����jj�2'Ҍߏ$���-���*&g�f���,�g-}�S�H�<��E��˗S�{"���}<!�4>��d%���t<��4�����ǫ">����w��lx��l�E���nw�j��܋�,�����Z=��VX��9�3�b���X)��-�9�H�Y��Üa���0g��c}���s+���a���-`�h	k�p�
G|�=�{%�+q��^)�K��ͥ�-���_ϯ������ڮwlx�/
�xF�xf�E��������t<�x�x>�{@|:��!ܦ�6`�2`O ��:�=��;���S�+A<�����`��u�.�N�&Fb�~��i��)~�������(+�ר7�\}H�>��ҡ\�]ȮEH�e��!�V�g��u��ayָ��\��]!���}$6ƕ�����#�w�+�14B�w�:����7��Z���I�(&��Pl��zj;������PBɶI�	[=%�m�Fl���Bk#6�R)l�OR{�ͤ�	ۦ�Z����;"B@DV�6S�P����@���O�Ռ��=������������͟6�_�|hN�nֿ���V�J�J�x%+,g�$g�$'�be,�O�#g�����㕶0�Iq8^��k�$�M�g��OR<�W���$������S�"��d�OR}�@��d�='ߋ��p^d���<�Ο��T�}9�a{��d�)��.�<"�K:������bvI�x�\�A>W�_�IA�|F���t��%���k(���G�t���y�|&����=���g�g��\�\ϛ�шh(���s�4���3%Q�YR��w���������ɦ�����m�����#��t��.pRX�a��R;���u�q�Y�V�Y����K\W�[+\j���8=��D���xn���auI���߮c��A��]����������������bo�|�F���k��������槏�o~����ĕv�L��A}͔:ۉ��N���a/�Եۅ�~'��;ɂ~7��I�v�A�̔����Np�In�v�k���Nb���Á$S�n�u'}�߅���)S�.j�p$����L��.F7ܼZ�6oϯ?]\]>jm���2�ZSa�Xk$��̡�F�_5.3�[#sk@0�WM:�[k4���Yb�X���D�N�5��F˩�v7f��5bw�e�P�e;r�nJ�5+ֈ�Q������e�	0k�&n��������ϐ�ƧEKh8,����� ӊ)��4������h	�E���,G�"�㓡���4`	�+�p��0�EF��,Lw!4>ZBw�i��%t'q��� -�;	�T��� +Mw2L줠����|�<�5�ؐ�0f:\��:.C\F=�<���,Ø�p	1f�R8�	1fLJ�_��Ы6��^�q<��jp<d#.�k �ed�GB=5�\F�o����X��Q9�����=���˿�..ߟ_Oޞ�5g?nF�曦���O��?��>i~_��f�hn���|��G��H���	�%��%.�%f㸝%�u�%��8����{&=�W��L+��t��8���*]�.]b���>��t�-1?��L���v�ʖ�]{�Wv�O ��b6y����I����@�g���f��k�^㖺��g���׿�/�K@ݞr�9ʢ�������,�b�q��v�a�v$�a�v����vd��J��s��7_=��`�Κ6����Pn�h�J�� ���,���������R=i�`	����<��1�_��%^�x�͸Ve�o�0��+0l�����6�z>��zP�m�zּ��z����m�U6[���M���F2�4�n�M����-� �J�-%�ev�!���~���t@0����_Za�M�I��ɳ]��p�/�Sd1&�^7�I���e�n�r�6�wùO�.�����\��s�{�\ "�o�sѓ�ns����\����\�"!^���a/�s�6�;2��S�F���L!�Q._,�Q�X�vt��������8�X��J�ƒUH��d�Y��E��z<�S�Czt�2�g��d$���<��	16>/=�i��6�e	q:>�>�G�����!�x�nLFF|$����!�����8�P�g�����k��MS�c,X��8��c�˱}����Ǜp}�<��8s.')�� �9)�9���p9v��k1�OR<;��O�]��S��4˽�� 77V��a��7r�r��,��;�.')<�1�'��:��>Y�|�,�H�1��	��ȁr�B\�WĮ�>��p�!�����!/�Bh��5�Ն�Z��
��*��.�Շ0�#v����W�n��g�����q'B#*VEcѫV�ۻN��h���:lK���Qz��E�eQm�QPq�q8�`űP#7DM4<����3.�N���"�j�{�Z���"��cQ�T���"���hxt&�Y�fz/�E$85!S�w��r���]C|y��y��ŋ�����t�_�6W����y|{��F�r�nL����j,jTb0��A�J}    -}m �� �Ҫ�A�
hk1X�bP��Z�Z}��J�TP@u��ľR�a�
��������R�LJQ]X��Jc��P@�(n�Tb�vg\%�aZw���֝qkI�θ���Pj"��Rqj#Q��8�����@�θ��8���Zw�T��2�ruc�N&낶y{М~9��/f��I�ټ��a��js�l]D�2W f_�=ټ��uU͓�[�\����\�j�l^��m�X�]e�u���~n�[�\�j\e�e���0�/W���Cs�\a��q.`5j�����5E߼�֍0��=�������{Dפ�y�P¼��	K4����0'�98%����-�L'˹���̛'8a��>'̩ќ75s�N�SY9�2CÛ*8a���~.R���ޔ�	K�Ԫ������-.μW��B�R9b�gv'?�ٛ�Lfo�5�+l��
�'{/&��>b2���&dV$�Z�����j2{or��ޛ�isM��kB��5��Z��\a��>b2W�����k&s��*��_1ó��W%�=�֬X��7rC�Fnj��<��D�k�f�Z����o䦙��o: S3z��4�}�4�LŌ}1�)1��U���A��q�� ���431�US����
Ld�I����2�0��af�ل�r�\�03V��+̌3VX"f��jf� R�=9��2�֞�Yd�=��4�&+��,ff`1�� {�f1�fOA��D̜ɑ�g�=���Xa���X5�ɑM��&���lC�T�{���)�F�MSX��|�4���a:�M'36�L3٪am&ft�4�e:���Lal0����7Mal�61�z
2�%f �7�Hu@f��S�),54R�F�2C�^=0��n<x��_W7�f��닏���pq�=�����źy���w/n�O^�{���F�rHC����S!�O��ϰh8��H���ۥ�H�h�u)��rtIAw0��HiS|���p*��2K�%��}������5���nJ6��2+j���t�)��R��`f8}���lr���z���l���A��ڇ۳���A��,�r�h����1���3:�����i���W��~�r�4���4��th��gt4GOCڳvG��w]z��6�r�!>l�h�������d{�o�-��ӳ�������O�W9��M�����_�7��Л���Us|�hS�6�F��;��i-��>۩��.�o2`��w;�}���4��]����ҫӝJ�eDn{�.��|��w��v��e��4f�]꾝]v)}���޴�m}�i�n�����������������-y�����f^�t2�/Fvw魝v��n甝֏n�u{5y����I������d��������Q������?�L�<k��:��G��rnf�(�,̹sF�����3�(g��GBG(	�0B�.�ن�\����*��.�ه���vng�(gܟ�:�G���	���\�v�h��+u<�g�Nޜ>m�9;S8�?o�Es����l3ⴣ���l��R�
Y~b���L�F���@�:����c���n��|ӄ)Fֲk��M�&��I�H�dX �@�C�K�d�CW`.@��H�U�P5�|��x�%W6 !���E�\YQ�ȕ%{���]���IW�8(�ڷD��s��Q3�s���PCF�
��+��4ݕoC��W�/�����P#�tW��i�$�\�j�4rH*"�o}Z�e��В���Z�k���X�[����v�>`�<�a�jCF�� xV$6n�hLC��
yyB��ET��}���1�P.��Lα�G��n^��M���g'��7VO��#̯i+0�\�9�k���X�⺮��Y�A�%mq`���%���`�8=���z�0��u88��Ddf�`ux!R���_GJ�v�Z�,Sk��djmW�L��o��ek;Eju��LMyG��+[IyG��+c�����}���ڞMYoʗ��\Yo�Zݗ+S3z�o�
5�7���\��C��A}߭�y��pQ�������ʕ���*��~29����'��+���j����#+�.�n�t��dr�T})T&W�dd(�Ƃ�L���ɺs@�K�29�Uc�O�*i*b�R�LNIF$i*���E�}P�^��q�|�9zyvx�r��h����X_�?���5GM��|;w��*F׈V�
1}�Q}�Q�*��y�]6���9ᗃ�*I�����FL��m�u�1�lr��x�O��{��&�� �I�>%n�u�1I�q�û�~����?�6ϯ/>}�h޼����o�����y���������������W�'�����䷼�C�Ov�ב��f����1��k�jͺDa}&f}f�����U���<�ZX���2��Xej�e
�3��'b��%jv�W���2{@�����VK���W�N�M85��ey+l��2	��S�$,� IX84$a��ULA�f�t�ŧ IXf�Ƨ ��A��$o���$,�$��=@�,3�S��Y���$	KĬb
����Yf�OA����H�S��N�M85ѵO�v��q�������^����~�=��?'�	9`���� d�����	��SS��'���m��E�X��X�6FF��F�����K��~	F�����#���vFF}��3�8��4!��}���f�m�	�U7�0����ٖ�:-�'���Y�1��u�@��A*��*謟�*���*8���8�W f4NA��Sn4����~H��3�q��@Lx�:�W� e H�9�1u��t�)�&���_���N?�?~}��e󤝴�)�������ُ���f1��>9_��3�����3�->�h�/f�}���<�l��<�����<���%�w�|O�Du��:�ܲ�:�ܲ//����}A>�|�/f��hm������<#���!����V�E�n4����Ͷ����!?����~��i�����O�O񃋋g�}J��z*���=h�V?]� .Z?r������S���3���W\����:��=�K0>����E���(.A?hs��?k���@3��7���j��ճbJgk���1���21"�� 
�� �f�Bkp+ɚ�
bB���Y��lN�1��=��L��o��΄��^j�ya U7��#o�o�ӗ������v,!/����wK�B0�o:�5!������B2����Z6#��;�e����B�[beL�KbeL2"���Z�$C{��,$���~Z�'5���X���,�/���>�y�$ r��l�u�;⃮����+$$>��
�/fv͏�<�Z���G����G�%�w�j	O�"���E���E�//Ѕ>�}A>�2�/f_]�#�E��/�>_��|�.��,Zw�qM�8�����mSS���BطTQ�$I0�~���#�,9�ɘ�c�l9U����	�$� �}K���3��M�� Y9�˘d��}K��$D,�$Gl
�	Ⱦ��BR\���)�f��]�0�o 88m����~[_7��?_\��n<�������o��>����7�>���gm�>��ssѼ=k�v�L��)�#s��$��l��l����$�d�}6�}v`��N��U�S�O��6�e6�ٙ2��ؓ�mO�-�ώ�>�ᔜ$0=j�;P���0j�&צᴝ���cAv)����<Y_�r��[�����_/�.�'�Q���Dư�b�f1�E�-d۽+���u!�>f[sw�$��U��5X[�/ȶ�C�Ţd{Zc�cH�!ۆ��b�-VK��BlA�2�ޅeLp�k0��t���o>�+�?~���8���~��>;�����hq���8�:��>�=��M�_�\e���ï2~����_�K���d��eI�쯌?�r�W�͑㯳_j���+��I9�Z����d������c����v{�n������w�������N������|�����������??~*�w��_���}~�����=߫�>�]�|�+���_��.�����_-~����_�����W�_����/��w���7g�]}�l�ϯ�N{�Es�<x}�ms����������� �	  ���W.��3��Ubf9b9bR�v�*m�1}6}N��I��*�Ak���`���&'�W9�t9b�O�)�G�*1Iq�S��m��B���oUɐ��Rږt�t���Qs|�l��������&������v�$l�$)�:p�$	��!톀p��A@�A[>��L�	�IJC�I�v�@���	��I���@8�E�y����F&(��O�`lg$)/
�jA�iQ�m���z��~�����]����|#H��\��E���X���E��9^tk���)2�F���"��$�D>�~��W�V��Zd =m����f�����{�(����� ����	檪�5�ͭm珦��o;���Vڼ��Ԗƾ����wTGZ�����#���/�S��9�8��������ﰎ�T/�ﲎ4r�w|���^�H#�~��a�qi��@��:���Ԭg�{i��[Cr��!컰;�|9���V����O�P�B�7ￛLg����QӼyqv������z��.S�,U�"UZ*n��u�RuK�m{"]�����q��J�����sy�mϣK�����ي����>S��4�)-7�Rk�*�"��B����	|���v����r�p7n��9o�?���GO���N������|�9ܮ�)#%(��"D��9ܢ܍i-��{�-�r��E]�+�����X���O�� 5�����w�}�&�q����S�E��7�K�������ޢf�n�_)X��L^J��-����|)�r����ME~|�ӭ��G�
�~a����]a'����#�b�}��+�G�e����4��O�_:��	��qy�_����"q�	ā�k1מ ���$���G��>O�?�z ����`�ǵ��-7v"51�J�ʲ�Eі�;�aѺ�Ţ `�(8[,�-jG���������w��,�yWj��BL)5�R,[�`��{_k�-<��,��X,����% 2�j�&P�ay��g�O'�O�v>m��?�x�v}}���i~�z���w��s�wV���୰w]4�b��0�O���*x�8��ܸ�ò����FW�q����ǹ&&+�wUS7*r���;lʼ�eM����l�ic���d��D2L7�lJdB��JGdR�u+K�HY*.Q��T�D2޲Ȉ>�*��R�YX�	�/ꆹ^�h����+��ʹ�6�:]�	�6]���pA�U����:j��x�V��Q�1� D�Q�sA�u��jP�>��ZC-tD�Q�]AzF
��ƠA���!=�1(<��P��{��vd9^X�y��vq����*;�'4�/h�4� |�l�	=
���>a��bx����}�H�E�.]P|���2�h��O�� ��q-�z.A?���7Ǔ�����u��7o_5�rq[r�Vy�CYz�)Ä����YV4ˠB�,K�|�)�T�YZ^��-���x�;��<b=�a)�Y�H^�u|���+�mtDYxWv�y�;�Z?X=~zx29�����u�}�l��i{�v��ڣ�	z\�{�V]�9a[G� tX� �]1r	ۆ_�]ږ��{�s�K;#�%0�	z�o��u�~cl#b����إe⌱���#꙰,��koɔ#n,2��^$+�{��|y� ݤW^QZ�F&�	ː"��z,���+�T����."Y��(�V�A��a^�5D�02�-M$�t��D27,��%����]t�Π닔��[h��`K��G��eu���,�(���Y�Z��­qY�,b�)e5�d�RV6�"O-�"�,��,�tf<X�=Kg����1��P-b
g&�
iS�Q'�L��T�����{zvx��v����۪����r��A\�4�	���؆�r��N,l�6������4ʭ�q��\n�5tf<(l�6tf����1�s+l�6�)��6H�tD�IۡwSE�
$�м�^���d��ٞ���*��Fh
c�22��G��1�45cO�������2��>��t@f��G��dO�3�����g���ef }£�Y�0�,@SX"f-}��),5�2{ }�),54����N�M85����??�*�Q{��bo#�YhŜ-12���_6���.�b~I�3wȮ�m�7��,�������G!#F?��x#���(d[x��72�}g�����|Xڻhd� ȁH�σl�b���Oxg��bV~��BLa�SXh[�ʯ<�
�Ŭ�
�J�W*��4+���U�+�[��Wl�o�J��Ŭ�
m��+��_��7+�� ��d�W*(}��4��_�B�#��ؕ_f1͗YL�e����O1Fd�+��»Ү����+��/#fV���}�3�e[x�ە_��g�+��B��T~�%�>���/�@�#٩�r�J_ ,�]��nѼ9}��i�,�@��z�^�%��k;e5zN}G�&_��Ы;�5z�_�/4{I�;�5|�]���s[�_۽��O�W���?I�����9�[�W	=�?����|��œ�O��
Z<��
���������>0�Z      �   M  x���Ko�@�3|
[U���ٗoQ#��"$z�e���(�T��]�ɣ
�H������o�cn&#1��=x]Ϯg��V�������~���jz}{���<ߌ�FD�U8^�<�4͆S5i|h��s5��͜W��Ͳ�2�L��+������g�6��H@%\-��b��b���?m}��n�kw?��S���OM���f2�c*ȋK��6������\�e�-�;��\�m��QB��d��тYxŨTm��e�AZ��c!�36�hIgLy������Y�������U[�ܓ\��\�R��"�m����&&K���3G��� %N���"�l�Қ9QN�|OZhЇȩj�:rٛ��N.� ����f�F^N�4����,͍ێ�Yi��C�.)������!��w��!rU��'݉Soq�ٴ};o�uT�@������g���l�^�����hQeQY�|?ZTou}v�2o�{�Ϯ�f�����XF2���D	�ȕa�	̶��O���)G��9�6|H��R��)u꺷�������R��D�{�OW͓�p����xX���Ie��z��x�^_��j����3��G}7�� ��>      �      x��][��6�~V~�������V��e[�Jvu
���0`&��	���wHJ�lw���$h�YݤH��w�\~�ɲ<���؜��K֫e�X�y�������_�%ƈ\g�dER.W����嗿/���H�ˮM~���w��,ٷ�n[�����}K��z�*i۔�tY���x��	�&ϔ[��Q���.'�n�VUZ^�M�U��nU%�r�^��f�IN��SL�KS�N,�n��{p⳸������0;��?t���������P����CY��N��;��[��%+�T��W�,�^U']�6��-W�	��b���Tmr���"��/S2����fY�ߙ�] O6����>�r�6���W��"�}$�nYh���Lc�����@Qe�޶e�,�}�eZ0�qN?[��h;�I.ݶL�����v��f�J2�+����dI�.W)���ܐ%ǲL7ͥ��	�z��:���k�.Y�u���$�e�.�dU����Dn�n��<ocT�fWWU��7�=��J�0����{���/��tk�W_�w8G�^h���hV��C���H�M�})qv���d�,.� 9�j�M]A��s���<�GйjO\����ydv����u�_��CZ��	O�
|��[a���5tr��.����Iw%�F�b�9� �p�ˡh�в!���p.��v��v����r?��Ϛ�ҹr�U�J��wlB�O�h4v%膏��c�n;Q�dBf���)�n�7�Yr�w�j�ubv$���Se9]����h]�Xۣ��3p�L
��,�̹�ᅥ�/M{X��Y�$O!�4�����Y&[���e=��O��ݠ�4�;��mA�Z��x���Ԙ�l��O5ā����bo�hÍFOl�1$Hx�o �������\~i���N��G�'{LSC"C
_�sKLJj^h|�r�ELc5n��^����$�]^�M;bE+y�2��&���7m @MѠ0�`��C5+DQpw"87R�D&�^�%���ٯ_�ߧ�\v��Y��Y���Ћ,���?aJ&tΥ�"xGB�FO+H�ʟ�7�N�\�f���\���'	��q�gi�ku�+���i1�x->�����.Q�<� .��5:��'�IylwSd~Y5^��%��v_����A�ȓ�A����	��^V���f;��$}�r�!��tMΊx��XLH�?�˴�f_�31p;��ۓ
�"*�9��6?�6��������vH ���Ve1�*��e�i�:�I�t%�"@"�D�D 5�����A@'+�����b��
��P�2ƣ�#��,���h73轴���
P��&&��S��r�W���&)�i�QQ��z���\�p�~��p?�����,�9O�ig���WM{�7&�)O�z72o&��|���L-��:=�ׯ`li_�G�Q�����\���,������H��ۂCd&���&l�h��Y��A��镄��Z�#Q�t�<���������� ���y�=��	u��~9f��Nq�O�<���I�ͥ�ڽ �b++�8y!g�4%��=�8��j�*����{*� y����AgH�
`�@0���n�5�N��k���l,'�����ⵊ�x����9�K{Y�^v��*Oc�Y�ε2@E/�`�Dko����b�VM(������:�d���E�]ko�:]5���P��~ԛCH�k�x�*,��_4�%����D9sw�M�혵�h5���r�4��W��H��n��ZLHl#㼿o9���w��ĳv�e��lғ�^���z�
T�������5��v -����vf�*�p�3F�u]��x>��oޣ���~`]�i4z��c�M�&!�\�O	[-�8�[+�a�<"��"m���>���-=��n��`�t]���Uy�g�@A�֖�����#+�~�a�q=|��R+����d�Ɍ D1O�y�Sw]9 �AU��A�(t�9�T6��0�L�{r���D-D�TԺS�+2��T�N	�F���䆧�t��������̝�����έ'Ƶ���^�QL����_�̢l{�!�s���vc�O��I� y���F�䪞B��BBB5��s$P�����C��E%��C���s�9K���?�Dy�l߽y���%��@3�.!�/���͛t4�RA�\�:Y!C3��Ȭ���0�@$�6]��./f��s!to/��(�pD75�e�:!�3W�m��b�ݖX�pnK7=�Ӻ�nC���2p�H���z[�[�ѳ��8���X(@B*�Pv����%�P��qJc�Џ��n �Ii= [���%8�<�^�E��?,���eh+�����h�P�伭�/����z2x ���,��X��d!^�	�C���0�q�rzg	ɭ3�4�׹�B!&p�
R�(�C�_$��@g{96�'.�������x�v�e�����I��'��!/KF�9��|O0�L���_ȟF� �
d���]+���TCT^ŻL"����b?�9�4��Oɦ� w����<�
+�=��IC�r�G$��_��[���6NՉ��C�3���1 9,���(��n{*���L;TZ���������$'��~��2�(v�h�s5�(2��a�a4�ig,��j&��s)�r���xϸ)�����
��
�E��j!O���1>�\���V�\����XY�2�py>�r�)>���v����K}�b�K���c����œ/m�>�;c<t\�C�%��X�)���J�t�3:�%�)t|�J���5f������Q�vUA�3Xc�Ɇt������0����D{p��l�'���Ͽ�����># �EJ���6˴��C�w�>�_Kcr	6X�36�΋!��QbDK���	�o]�����S�9]��,������3N�@Z��'B���%�Xc0J����^��h|VK��[��jKKZ� ��**/(b��&�����^d^�������f�4�C[L�!���SM(�齪�Ym�`���i���3�+�wŜ(����	l�I �Ǆ��>��f�/1�hFZ>�1H��w	���C��Lg�У�i�Ň#�NU|��]hK��-�>��~�l7��t����d�]��ڙ�jB��@�y� A��o}�h	�".�C�$���	$��c�YT}��pk�f	2�'L�M��&��aQ��&�\k6����Cj�;4��im��O����(Cl��?�D���Hh_�I��42���{z
���O��C� %"�E���U��O͸J������b�>s2�������*��86��B������'8���NJ2���'��0I��<��;@�-�WM��(QP^��脒-����ˀ��^~����a%F�Q�F��ҝ!,�����rdJz���#��P���`i�Z��ŵs!%Z���pst��M��2��:Kg��u��#�g" p�ڌuG��RL`J�_�8�"���A��	���W�&�	x+�G��kb��,��L�kV;J�����p!u���NƓ�t>W��2�~�xN�֣��	��vԘ���<��QݗrW�d`�48!�� g�+< ��;��e�˄KX�e���5+Rn�~;U�;��Z�Ԩ1S̀�R'��~��M�$�����.>���:��q	i�q}��`�
�h���n}�Օ.Jy�.5N����\`�A<>k�I��������1����W�\*#,x���+���6�v�P h�G�,ˁ�qV��xi"n��-�������~����D����S(�_��r!6@�W�$%%&U\l4#�I�lw}�"LAZ��C�w"�&�cz�ԝ�r/�����2�~���L��؋MuByA"����2}��2�n�x�x
y�ί�c�4[�=�hY�L��th?�a�����ǔ%�F��:*��fǯ���۫z�������;��3!)lF�&`W�"^�*Փ�U�x*{��#�y��X/��F}Z�A���T��>���wӐ2W<   ]�����1����er[�9x�GC�<��(R+ږ�̊L�ޔrN�ba�H�E�Q�A�zo?%�����:Ҕ�4�%k��Si�re�-��cy��r��bh[Nj�gAYn�bVJ�x!aDF��cq�ʦ抙��C������w����Lx��y�1������P�v�_8t��8{�#^����k$Y.]*I_�29"]�\IÆ#�Ώ��
j��4w��T�u���n�H���*�������Z2sV�3���QeG�oj��^��C��(.��64؛�Mi�������k�4�
��rM��Y^'�L�J>��ŝ��@���e�Ղ|�0ι�V��-�a�ـnN+�%��iQM�7C�s+��2d���<��Bs����AF�B�Paq 5l���#�YΘY�a3��;�BJg���� ���T�sYŘ�Fix�+;�����*~J�Xjr��
 ہ�=��C���XR��[�����H(-��Cwil����翥�K}�ml�t�hfv�0"�8w�S�Z��5�)/�y�!�<���h<���HX���� ��W^[���G�����MԵ0���OK0|3��H6į�!��dͥ>��.=��o����_����<��Q\M\�ld�9���z�i�Z��5;���}������3����G�ҧU����6m��i��5l
K�ET��acGc��%���4H����J��x�*ޅD݄�CY�$�=����hfD.qyI{l�w�J!��=�˶������6Z�{�7I�D�u����8��sP�M���-�m:l�#�L[���z��2)l������R6��Iz���$�e>z)ŜO�CbM��\��V�c�\��/cqp$� z�V��̈́^�	fx�0��\��X^�m
�.�ky��9c~���D[��JEeZ�R�� ܲx�'�q\�V����)�W��I�Պ\�AϞ<��e��q�A2o�>�=������b,��N��>���W�5d6 �����q�˪�z�l�C���&QB�1�$���ρ�L'�b?FV�/�Yq���$�I�F.��}��j�Z��n7�O]�!�T.���l�4�h8~��w*�L�\_1�EhuīSF�#8��س
��_ L�t�9S���?9�1�h{�-l�J��K֭=#㺲}���e����ĸ~�]��JXٜ�*�rbe��ȍ� �1�!��\ �ƸE �B���!�<��Cq�e}�Z_�ͥ�cI�,64�x���X�=�
��_���*&#�#/�[��m~����$��t��)��120tjMݷ� �m���v�]jQF������* ��XO<��沶Q`��d���˟���&�^q�*/r�1,��r\��-���9Xt�����~Z^���h��Tb�Xm���"�m���\P��C�+���t�0;���d��AHJj�?�_Q_{���<&�#��ZVٵ6�;Ӄ<���P_2�S���h��'���b�}�D(�e�'b�k3ߌP������͚� ���Xf$O�����Pj	��vf�80�6���p�շ�t1cV�B��ÛL� Z���~���5�p������b�OR�_�K%��r���So�/m�x��� Y��[ٹ_�h�*:���j����7,d�F9D��a�'��U^[��)�̥Vl���VP{R^���uj�%I@����ʾ�q_�7]~��B��S�D��v����-� �,O�{�wj��x�{*u� Hڣ��_�Cl��v�&ne�[SW�k{���:���o�|�/o��Ӛ[�[�M���5���X1_���u�Ԏ�5F�i��e�N�~X1�G�P�C��k�;}U�%���f�ګr���$ʩ�Πj`(��*�`����N�z��J�T ߇��En4~q7Y��]���)�N�t^I6zc�ծ���kȩ�u|�k��[>����z��E���o,t�;[�+_4�g%���g�s}�S���?ՠ�^��衇c��:����Fk;g��X�9�m"��rn�W�� �6�
��KY�2;ׄv���LK#�`�A��&1\�D%@�*G��J�jDnj<������%��T�GZ����U��W��˃���v9��5کl�.�� sr��%��Fo휌cJ��+3�MI�;ټ�v`}�`7l�Gt�0L��3$lǜgc���3趦\����.�:t:���Dp���f\�¸�fO�/�{+�>d�^;��}u�����NWm��9��p�uqӅ��C�3CO ���j1�F�[O�#������ZR&4�4�����a�7�?� 
s����?��0����'�k҉�o�%e��n��3��}�=�+sc� l(����΅+y5e�y�9P��M���ׅ��+ȱͷ:�d��p�lbb�fi�z�Q+�ؤ �`�����N��S���Q_�|�L����G���ּ<8�4J xK���|ISr�w]9�1_o��LvA�V�_�i������u�#��է�� ULJ-�z�o]6�.�㇅���E�`�ѣ�L�<��m_~��n=?��z� �(�N����7�alFs�\�:
���/˒�G��/X�����0')L0z<�\Lϟm5uA��r��7�r�`��b��W��g�	z��^�~Oe�Qxv,#���r��}s��B&�،�cPl��J�W%Ɣ�!�SPW0wF�+}�����<��+�`��l6(_���d�	f�I�N���d6�����韟�M� �熞J}��nq���l`Jf��;��̥�Pɪ_�ψ�P�˯��>Ͱ<��J؝^.�F"��`��R�5�?K/ -w̘}AV.�i1E�@���Y�̝��NQJqS�D	W�yW��D�
1_���<)���j�4��x�|�i����ٗX� ��6���ڿ@�9׭��BH�*T�*�I�<H������m>!zn*y�o	S(S��flF�E�ϯ�&���P?a�+I���h �eq������������7s���
��f�Ah������;�j
�6���MC�>�;Bm�}J�;�mQ"L��>�� ��t�t9��簠�E6Z���Bʛ�k�O�J-�H
��Ƕ����B�v�B�ov�{�]���{�܃G��}��,fz=8۷֖���3��[�l���sJ����>'dԽN/zW(������^�N�P��IM:��T%]�s9u<��)y�����~�[Pnq�������S:�9o�
ʜ��ɴ�JN���u�3݂�O�����x�뜰���?�^�9�����ݩ� �o�_�jp�3������ ~��й��ۭ�ҹnD����i�=����HCR��s҄�9i�v���>�E9�&�AeW| Dh���i�+L^���H	����)ѯ��Ŀ�M�\~����iI���������~��?��˯�o�So�����{B%G?d����Ӄݫ��Zk�3ɤJ6�6	���������������z�/��73Q L���FS�����w?/����̴p�      �   �  x��Vێ�8}v���a����Ɇ\"�i^<:a;���~����Ok7 �
Q�n�U���B�w�`�o�yO�O��6�#˰	g��:���b!7�=����S�]fI�S=��0&r}�Eb��ߋ;��]�/��Nǡt-D�O�����)�����HC U&Z�"�ŋ���J�
0��b#|x��Z��L���� ��Q�R�9*0� ɥ3��1)��s��+0�����8%�Il�"X,��*Jm�(�t �G��`ՙ+4x�1�EL�1����+�~���
<��ь��zD�N�Oj� �Nwt�������A[�Qy�`7��ޙ���
�PEm�]���R�p����!#�CA��]x"z�R�)�L���w�1<p����`�>��'�l�d�a���gjL�����8q�{Z�R�U%��4;�t���L��s��v������/x�R���f���t�_����r��'���~uտ�����"o �*Ҥďyq�6�A՗K����~�R[�E}�8Hd�5OZ��//�s�����7e�	ަ�f�1d�����u�	�Ό9�ǴK�v�+��~�m���E���z�S�cb��9��퓢�e�p�#)�D�]�?�:��c�ߋ�vS���58{~�SqG�?`\�M�8�rJ�W��3޷��o�9};(����C��x7E.��]�� �����6K�|��_��}(ź9c��4��*��`�9�q�q�>q3u;�zuq�����ҪZ�
O����u!/��Ϳ\Jx&�c}nX�͸;�sö8���>r�ucFٌZ���g쉳4��ۑ%�-s��K{'��YfǴh�oP��z�A���sX'Sbcb5��Lk�}_���\Y�P�A����#"Xeqj��^9�NL�����a#�A;�Y�O�q�����3U=�>^]��R֌.j����2�[���6�z�׮;��9��jr�!Ķ��7m2����      �      x����r�Ʋ�������w�H�0O*�L�W���,E��������q�Iyź��P��Fw��=sm���j/��Q���v���n�x�[��8�5�Vq���~%4Q:R�3I�q���r�R\B�էlR_)�����]�Q��+���9\��K�/��)Q1�,Q��#j��l�����׶���o�y���M������z�ަ�M����pE)A�����a�G/^���l�6]M��������L�0\���%S����q���t��n2˜A���f�\��kV�3��#��81<dOpԇ��I��n8���,]9@�XS*#���/wEM(�	k��	�Z�As2��5�y�ڮ�Y<�Φp���F����o�O`���3WE(M�cFٔ���!\��u�y:[�KFw7�Jj�\�=���5	������+|\�ট�m�.�W
�m���~ W�~�� ��qe��I��2�+_����M���23�����ͼ�f?�	j$mvU,�X�Ϫ�	�uUg�q9u�@���V{lǼ��9����JM���>�ncj�Q���t���e:���$.�G8`ɇ��}���	~�$"��:���Oj�I6N�(Nm`q���v���L.5#�%T ����|i2�4�ݝ�v���0e-NI�P������/9Mx�B��Yr��p��ɞ�r�ڄ�d*j�
v3�<��� -ĺ���v�i��d�t;��j$��-�dM&���4�u�S2I��/E��"H;�l5I!��er�y�� >	�7��Z�~��2֗#��Q�ޡ��uΜ@u�J b)�k��������&�:��"�
�,�L�DZ4]B�d�A��R����X��럀,t�Aȕ�bd[1ʟ����y��\)�qG9~�^Gm(�%���,&vD�K�RSP2�d��YO�&_vK0���*��,B�����dx�O�j�zMCI��rd�r4w9�TM箮����P�i�]��~� �vaF�ez���꫐5�Tq��>ۢ`B0���Q�ňR(���`�F��jd[5��_��[��ϥwZ
:��%�A���^�s����zYX�$�L�� Ty!��I�m��eO��f���O�{]�Aylk�e�$����t���*I�Y�%�U�d�w�-6(���%V�>�b� tZA6=�2a�2�
�|�n/�9�;��YTFs�.gH��8����`�
�}���얝��t�h<|�BN�i�s=Pr�9�$X��>u�<��se'9ΔR�*�1�`(����a	��c�.K�����mV&Ī�EML�{^u�n�M�f6�� ��U�ˮ�jt�޼�#ѡ��N��aN�hFY�
f�c�ʒ���/����q_�I] �EЌ��kq�v�X��^eA㣵�2O�?�خw[.Rrl���������pa4���H�D!l�f;m���	�W�m��z��j�I��:O�e��,'PKZР�6o��$4&��KI��*���E�����0������,^��CqW�>�=��"�Hq�1	�U�1Ѓ79��	z'#\�Al�_�6�7pU�m����&���W��SM�O��1^���h8t26"��H?v*8�_�5p��:��v�Sps�kr�Ǣ����M��t:�n�� 4���b�����.&u%�I���_�V����'09��	ʁ�@A�@i d\p�1^�;����%Z������Dgt�]d4��h<�vp�S�^b��4&�HF��c-��˟���e/m֐��\%��X�@*�b�� �)HuR�D+�i?�W�ڿ�n ����[��ٺ�0,�� �:����W�*&F��l�b4��Lø�d�54ޫ�6�d�4v2����N����ވ����ti����H�S	��Ծʉ�E�vD�����������ߟ��Hi+Cì#]��[�%qI
!DFL%�ҀZ(���"�j�v�Í/8�/��*���CV�!}:�p�s\�����j�ˡ{L��
�X��*�Zʧ�Y��;���$���ub�ȸ���u�Ϡ�II�zh��z,�֗$�JR����~�^I��Kq�P��fC),�˺��2�P�M&�5@Aw_�ݧXj�	�����z�cܯ�D>N������W��s���r6(�@���BD�*c�
�ę�����=R���|$�;MB� �L_�X�I�����*]N�	�*��8L�:��?�_��������}�CC�Dy��a��V	4��3_�X+L�t�U�\E
yT�~�7�����O���"UtP��PP��9Z�"�V����?�.�M����ǫ���)��m!ީ7W`Q��|q���'^-�@t����:/Ae�M��e}�b�R��������v�5��j�ӷo/���	lhO�n���K\PV�Xz�B����R�Z��ݤs��es�8N�J#oW7���6��5-7	�bPN��z�[�
��RŞ(U89�Nf���`XL	���/X��1�o'����E�-4���}���zy�?~�
f��P�(�^�r�h-4���ӑs��wd�� �)4B��'q��b�U���f��2Ї/i�D��!^r&/?��5?��Fu���Ծ�q��Iv����A87V��>g&9.%�����ꖙ��
�[�kz������8d�fA�,]Ը�:(�n{��[�����V�`�������[e_߿Pv?/��lઌ�x�'�F6��\�z��]o�m�^������,�(��F��볐]es&r8��B9��Ƃ�p�E@_�x�i\sw ��͗�HQX��zzڭb��^��{ 8��N�&�s��� a}E㭢��~�W����%�1�p��7H�_�ײ/��5Lt�y���,� 8=��x��4W��C���{��*҇f�`�C�:|{Φ/��q�e�g�:}ዏ`g�>��6��$CQ3
���O�m�׀�_pD+88c��W'A�cLa7K�a�$�����Cgl�����5�	T�&8`v7��!N�))��0�y��֔������-}A��Lv�/�I9�i��?�� �Ϊ����9-��q:�A��U���r"Z99�Ɨ���.�ȱB
i���H�q���P��
���-_���?�m>���0h?��qL�L^;%��ŵtGRCV6� �׸�g|:���gp׳Y�]g�� �=^e�ͳ�>���8Ɗ 	cB.�V/.�sنkV�xS_���Guo��s���ي�c3�H*+��$��$�l�-p�ϪW�r�Ks�T`�����1�"�X��Q��6d׳$��r�v���HE-�Lr��.�"���I����a�d�'c���� ��s<����j�BsU%�����d8�H:�"�>o��y>���_�-7�(�P�!8&G�'�C����D'yL�B�{)�y��3��WCE�n�%f3fM�h�Ek7���*.��A�C���t�1����R>�j��e��
� DCw�~�ꑤ��
A��/Rw��2s�ie� `����$r���3_d+��/� ~u{_����8��`�P��᫃�Hb"�$�no��|�"@�U@�*�{��,�s��d����`B;i�����^A�
�P)�ṧ{�Q���:��G6�Y����fT���������
�$%*�c0f �{Ȭ��˄���E�Ȫ�^�\N�	<[�Ø=���FR9z
��ԗ��Ƣ��?�<�]�ߠ�ۗ+�ؔ	
�������t�r���_�����Cج�mp��5�3C����q�#�k���$�\O�TΏ��]T�a|���a#�þ�D���۱2�=\��^���(�O��!n�J�p��p*AT��|.mh�� C��+K,4˴��+`_|T+>��M�����ꄴz
*N�]
v�]�������C=�Cr!�1�ޒI�"`��I��t=˶��s�N85�*���V��UmYo
;ApQH�F��>��]Jw�d���	��e�Ϫ%M�����©X��̉X�Qv_!�5^�s�UԾ��N���6!+���
��rqwDF���x�'��97cN��}�	nT�q� ����}�S]�[N]WV:�<]��   W�j"k��/J��Q���8x�054�ڗ@ݑ���b�VT�ȫ!�Z;����	^ڜ��J�ɵ1x�7H�+��}߸-�Dd��B���b�QdF�n�O��a�7"[���WD�i�vPU�qX���Td�Y���N���Z�nS���uS`�K�n�q�-�mS����v��g����s�!m����+�O|�K���	�W��}yԭ<���n�.\4�����A���b��hC������8�V�x��ת+d��*��������؞}����=�o�q���6x�w̸�,j�Iu9�`�e�J�BM)�k�(�s�򭡖Ӑ�Q��\�9��nu�<��Oh�Ѭ`�A�F�v�\����u�%K���ɇ��6]�vz������ƪxz�(�Lr%�;��	'��Z��?����4_�q�ϳ���P�SҒs���a��M&f@6����T
�I���U��EEM�C�i��GmH(O��W6>:6���>C;�q3۹Ia��P�$SX=[|v�ke~&/�h�����	��}�3�Kg�q7�)�p﨟��k���tѼ�-����?�C�̀dBg�=ӊ>�8��/w���,T����p�g.���"	���K;b_�Lg�~�F��J��3%��亖>3����XZ��J	Nꆹ}�3����,����^�晶��<�>jgf�<[�p1��v������$J9H����@�j�$�oQ[б��a�
�=�·k;�|�`�1V������53��������I�K�      �   &   x�3�420��52��J�I��L���425 �=... |�%      �   6   x�3��HMLQ0�2�0L�L!S.CN�Ĥ��"�Ģ�T.#N����=... }�      �      x��}Yw7��s�W�Si���}�77i����s��L�XlQ���ݿ~" UY�"s�����h	|�D,�N>vGǧ��Nλ_O�w�&oo�^�N�����ۉ�ř��(�LY&�癋�(!�L���2��1���P���F�(��T����0o�c�L8�_BN�y�R�k�dg���d�^�F���o��N>�_��q1y{u}�����=��|�����D��w��qY��kD�`ן{������������w���w�����Xq*5>�o��)�"*ԥ0�4!�Vr˃+x�8Df�O��3/�䢙�����gBb�,;+}jc�����nq�p{79��?;�O���󳝽�r�T2�ނ0ee�l�|��M��廜�>�Ō��:��$��� �R����U$/�uq��~�A쌎�Rrf4 �R���e3x�L�5���X�qx��:��
c���a\����U$o+�w;����n��[��X�c�?1^Y�g�LT�V'�`�3�VE�a2Z���G�~���V;F���>�Ip�X�� �xW������D���0!9hB*�������Z�qpb�{+f�H�d+c]pA�Ci}��
-�>CAR�n�c���P�^��í0X6��P+���^�iZ	V�g+*c�яCm} ��
-�>CAR�n������]2�~��c(�f�M4�@�0
�e8&��{����hM�d�Vg��SF�� &�Z`}bI�;$����E�|��3*�e3��h}���4Ek�jf�MkF���� &�Z`}$����m���w������`Mw�������Vf&Q�j�����PhT�h��^�H���@5�J��F���L�+��� HnIŻE 0���ɤ{��ut*��<��vQ�����Y�Z�?=��&�'HG�3c�R�0��L�+��� H>I���������w;'���I���T��w&`J�-f�U�f�R���J,���A�'Ő���s#�R[�$�B���R�T�ۤbZ�t���`-w{׏��N�Uz-�Zc�fVV8!Y�+Оx|��5le���j=w�)�`\��ASMAR�2��w~>���I����\r��0��2b�f�
΁�Y��^ȲF2Z����q�x��`\����#�x7�B	SԷ沠&Zyz��͜(�IZ"��"���� FAa�^��Ԛ�0	��냠qQ�T�}Y� ������aq�gwyw��%��L�A�[��`�L�B�T�����ƀ��*3������0	��� �$�A�Ec���A�����`Y�C�>��L��k�g3�����͈�R[�$�B��BI���c�q�l�I0��tܝλ��ygNP0����c� ��2�� &Q�s����w)�5��(Ldj��W[�$�B�"Ϫ���� ������_^�O�0�E�_��4)U,Kf	� ���k�����8�c���0	��� q$�8~>�~�T�h.;�`� F��`Y��:PS�*�ˊo0y���.�!��� &�Z`}9T�H*�V2�;Fg���/� �o����/�� K�BAJI��`Y2�2uB�p	�%��cT3TƩ(�ϧi} S�����#�xץ�;��>P���`��	�,KFSГ�di�H~��#����;�7ft��0��X���##�x��`it�������շǇ����5ɜ.����:�:L�\N��J���.f8�z��ִ>��Th��A�p#�xӝ�&�|>/>,�7 %�O*h1��1-�ͼ)�i�0�q`�?���3�*��)�cl��� &�Z`}$����ݰ8|��I �V'��j���\���'���˿��/����������H�i���n�p�,j&O^��������d�S�w�����������^*0'|��3i���?X��z�Jn\�*�+K\,m���wY���J����=#���4T!�?����/>_�\�-����}G�
�>gH��~��`Y��2��9����=� `B�d}3�1zD���>�Ip�X}WIŻbμ?�yw�v�;:9?8;�9?�?L���^��訛�M���Q�C)��0����\�����@�ӟ����Sd��-:pϖO�� &�Z`}9��H*�'ɧ��s��ZE*@@�Wf�l�B���<ϩ�]ҫ��b���,#�zi} ��
-�>�V�T��|�N��w?�� �.Ơ�^�r#ñ2X6Ӷ��-�.z�x��~0P�|�#FKm} ��
-�>��R1��w�4�Js�6k_�0�*�e3�+���Ȉ6� p�S΀���L�+��� ��`$o�����k�Y@[~��w�W��˻��o�	�~rvu��V**_j���v��_,K9�֘�ɠ��=�F�d�F�~Ǔ��� �R��A�
��%��޿8rZ1��t߽{��MJ�������F{nY������>|��0�M*�)��	"Nk���S�s6S 8Fj��m@��A��w�3�eu����Y���`���EI
�����o�y���;;�:;���b8�Ԙ��3�l20�e2ν��>���W�/ǈ�6��ȥ���)j� 
�4t��o˻�D�]�j�z�s��~����Jt�����A\�B�B��&R�V��p����J	n̈ Mm{+�KD뽋U&Jb��n�'<����?��o��,/>/�~_���q�{��ay��[^u����ԋ "�%
哗�	���0���^_2�P/���j?fy����{^�V��a
�Q�9���N��,��/.����W����Ӄ�|q�{�I�]?���������r�}�[��?�-;��ߖw/���o�ewn����P7?;u������G����a~Y�ƙ(��;_5���f���2f���mnꝦ��j�T��eT�0��}(�$A/�a�i���3^�D11��f�
�ܾ|�4g��H�SY��5����=����sQ���eK�/��ᘺS/�n����)�4v/��wN:�_�:�^�?\]��_��W����i�41b�!�Y��
6}�|ud�HK񼘲��*�+-n虦�������S��g����oO@������>ŗ����4)��	6]AY�W\��p��D���(F���}��J�T�{eL[���������KQ|�1� EL�H�WK�*p~(q2���h/F,Օ67�N�ga��잊T���֏���ry�~����=��I���+�]�A��Ä��"Ƹ���~�<D*��s\�zeL��ӵ�����3��� &H2D3�ed�u��F1�(tH ��1�G1εң,��� &�Z`}�Bf$������u��K�y��J������4FG9���饩 �c5�2=�^i�� &�Z`}�Gg$o+�ӳ������SʋP)	S<~̅IiJ��y��*�]F�Hy �q�B������ &�Z`}4J
��wCL=�������o0f�ƈz)]���M�m�;N��0*�L��dʥ�F ���L�]�h�����(��.�3���ձ��f	�t�8M���Q����+z��)���l�:w�S�)皮�_e�o}�t%ǉ��M�F�׋|m<��Y��)�B�^u_��x��c%�)����<�Dl�m���}��>C��i�A&6�Z��67��c��j�9l���5ţ�����h�����L�o�u�e�M���٫���o�iwzu�p{�=�������!������t���#_1"�,Dz�Q⛦�̏�\�5���g�XK�mwl��6c������)?no�/�9
3U��/KPUd
��`>g�\����[��34��L��#Qisc�Y�V�]�`�˨6Ep�L詷��>CCM����!W��א�u��O|���*
�������}�GoԘ�nsc�q(V��ڇ�eT��e��A��������^ʪ�`����jQ,�W����m���u
��ʀ���,/5�`\��A�� �x�� ;��    (C��#C�Ls�+�ei��)�QI]�tI���㍲2�nŘ,��L�+��� �ZAR�n�2����`���:V^N�3X���h�Mq��蔤5��	�d�ߴ>�Ip�XD��0��wųy}��_��-=>�g������˫Ew�oP�iq@#���E^6W����f��?`
#V��bN��4�3�Վ�`RZ�T*��� D�p2��w���	\��r�fu���`Yr�b�N�\̉�0~)ђ���4��� &�gV��A�=#�x�n�گMʯ�.���&�����`Z�L�ŀ�B�ƛ�v-h	�=Of��঎Ri}��
-�>�<�I�; $�wh�Tt��|�\Jx
��2��;hw����*oCz����2�F�X��0	���Ȳ`$���)c^P�e�̀�>����s�i���@qe0�R!m����N�� &�Z`}�{f$��9�ݧd)i �O:�����a�PܚJ�-nh���N�2Xa�����_Pm} ��
-�>�<�0��w���
��������ܖmے�mg�Ҏ�L�[*���R�&rk1.X낉c����&�Z`}9v�H*�m������}۠������;}��c�F��Jڐ(�ǀW&Z���|5%�&�.�K[D�#̾�����`i �v���Qm������=~�>�}���D����&�	T\.���y������jE�#����+�7������͍���i �vɪ]������w�3�4�x�o������>9�����W7�n�l/�����6ckmH�Z�T��T�k�R�r�Q�QT�B��Y�ӌ�@�F���1K��͍���w���e��Z��6��N(xfx�=�3�]e��^�7��� �ȋ��;�֌��`ͪ�L�� &�Z`}$����]_.R��a����O8�¼s�D�%-!��4���ל,K��w|��>�t�B��te��q��j��Wh��A��9#�x�nq�2����w�Os��dqww�=��}y	=�K߀ҧ!����L��ʥw�a��;��tUe�rP8����`\��A�,H*ާ��i�b.����H��/���),b�c˒�2��T�"*�^�0��r3֧ſ��>�Ip�XDv�I���4�Bmm��7�����`Y����YL(L��/-����*���cdS[�$�B�"/�2��7%4&����>9s�xsa0�$g<�(�B�$�0u^ʜ��=�|~ S�èƦ��x����EFQ��`�jz�v���2����_]��)?�6�):�����1�CLh�Xk���Dpg��+����<W�]fo+�l]���N/�����w�5�W�7l��bZ� �;>Wj%[��,u�l�D�N�]#�h�6�M6.��AݝQq��z��
a�K�nV�j��6z b�v1��IjFn^�Υj}q{���~�۾щs��Q!��@���pY�_$��C�����}:�f�=�6DJV2%��`ma$j�&�]�[��&h��$o+c��c6m7�`\���u5#�x{S,����Km�)��������loJ�<�ztZ|�X�\^�AJZ��,�)1EYax�2��I��VD��W`� P�����8{;�v#��p¨)�NS|�NHWG���暑j&��v��67�Nç���%�~�ּ���=�+{�H�T�BS
gpf�l&*uRO� |�y��ц�@0����i} ��
-�>��z�H*���;�wT¬�OvO��]�I�/8Qi��PDѨ�s�T:"�T�e0c6���0	��� �$��vT՝}��{͎n��=%�<�ó�`~�z��{xG�Ғ6S3>��c�O��`\�����H*��{�4��S. x8��Z���2<ז)nQ����I�n��H����&���Ka;&�Z`}$�����6���̾�>����Ѽ�{�����lҁ�cYb)� \�v�j��S�(j(ϟ�Un�(�67��!�a���~ՏBÛ���?��z׽�^�Χҽ��.t;�C01(�X�j�����j�"���<sI���O�LÆ���;�����e�S��j�xh����`�����G�[+���B������y���c�b.h0*&�E��VƼ����f$���=w��67����BX�2�Hy;KF5n���j���TzE��%��G��J��_�I��2N���zZ�w�IhZ�ƾ��v`?��������o�h������%����#d0��k9�!�����ɦ��w��������{\!ҮJ�o�a��7�@4b*�T�N�7&�[ �V��R%����ji��GE���-��� ?�������W����z����ଶt��N! \�d�0���k�p%���`���0������#Rf��0�
-�>ZJ*H*�VPo�}Xt;��]]ώ`���<%�h��䝱"샠��t=|�6�T,K[2�V뼥Wh�K���bƇt���UZ�T*��� eAR�n:
;M��f{�[O4�`�,�Bqe��:��w��,\:���ͨ��j��x�dX��d$��ˎ�7���p��L:��,�i_i�����U�'��I��0�`T�k�� &�Z`}"뤌���zd����Up�s��22�OZ�� �E��1�U����Z[�$�B��MAR�n���==8CyHk���Q�t�4S,IٷL�Q�Jg�.�/y�Le��,6ˢhxہz7��C���T;�
Rpq�tU*�*����^��wޞuR��Nm܍�$2�X��������C��h��`S	U��i{+^=Y��WO2����g����������:\������s�����Abh�2P�a�J�eN�"�R�ʀZ�c�X�� &�Z`}kH*��ar��CXЭ�t� ���3X6��RP4�2��lHM�0�'�EΌ��Q�J��Wh��AdC��T�����������G��#���Χ�R�����t	%!��v��a��xxsL�$�4�.)�4Ν�_$ىD��[9�`����x����/�QT��.n���}jg�v��A6	.��B��{���{B��0�Ǣ�(3F��͍��
a�K*��2�V����81�N�������i����^�vǷ0�߽�R9���v�q����t{'a��q{7���WNpGl�@S�����Ҙ���ͫh��|�u"A��9����޳�]!�v���_F�W���1��p�w�`�.��:&|��GW:v/_��1E:�']����knqC���ݷ�q�@�x�?����F^%b|$�~��t�iX�
�$��V�}:Ś�R��r��=gZ�o�ˡ��<3y5IrC���}�{R
k:�B:=�c<>��e,T!��2�p�u�Ld��y��j�A��K�d��,`�'ZepO;������i����U�iyb���&��'��S)�������	�2@Wktμ˿E�B��J�mn�]�CX�r�_ۘ�Ք�����nq;��0ER�iLÓ��W��jK�m1%��U�Q�Si��s.�ݷ�e��ݤ�������~��0���X�z��D��c~�p[cb�������B�����P��K�z䴧m�̤�`QV�$��1���<�.]ep�ؘ����L�+��� ���H*�m+�&�Ikh��;Q�lL�-��2��`TN 5���)��+��8x9�����0	��냠�T�T�?�MO�Ŧ|i��h�ֵ��������`��4�6|�!K:��<�Ō�m��� &�Z`}9N�H*�?TA{ ���[���~� ��~A43X�SK��*�M�}�w�Ҳ���Sj��%5�`\��A#� �x����+��R�ʂw���2�e)2���I�鵘�X��>�L�q53�������� �R����6#�xQL'���dg�C 0���z�̫B��eCalZ�~rz�=�N�j����X��,x����	���Y���҆�6��	�̝�Z������IP&ZI�����~73&a�6�mIJ�G:�DK�#��\flrԮ���&�Z`}4�
���/=������GJ��ͬh�e�����ƈ9 f   ��i&J��t\���{�V�]���˨6���Ý�ӣ�'��
w`�|<��x������2���,�u��&:��0VC�1�c��L�+��� ��H*ޭ�l`C�5B)��K��2X�~ S'ү$���#K��s:�.f�Vь�Q�� &�Z`}��
��wCF̯w��3O��tF�����c!��Sm4U
�܁�Tn���8*���"�	��I������~��U8� O\��C-�?m�U r�h�=�6���@��[n̮Y���IozueQ�7�7�zf��Z��Ys�������	Ek��Ji��q�/�/1��=�Cm�U�`b��L����c^i�_�3>��plM��{Z��?g?����)��      �   i   x�U�1�0���á1�g,���H���p��� qC,��X8�#�z��dKRI�$AR��H�$ �I��L2�H��y����r?c���ʄD'Sz�ѻ����9�      �   �   x����
�0��s����I۵=��@elz��*��W)XX'4���{�Je=,�1�<M$���q{ޡk�4���ξ2N *�z$�>gX�sæ����J�eTѐ�aE�a��é,�FC���2\4�����h������{I��v�=�}p��١������.5t0,�g�b�W!Fh��]��mC-�f)W���.��>��H      �   �   x�u�1
1E��^`���fLzO�Ղ�����GDa���̃�߯Z�/Z�˭�R�����:I�ZJY����-��$�Oj�����=9��{?�?Sֶ�@���A�#�1)F
���uuja,�ڄ���6j�&X@�	��s���M-�M,�	�P�7���-��)��|,0߀����b>�;U�gl����.Ղ|t��cK��^�A�J-�|�Yx��9���-�         �   x����
�`�����������$�J�мD��,���I'I!:��c�a$1	"FD�(�� ���!*�A6˃�	��q��u��&�Iތ�O���%�i��M��չ6x��l����kcː���E�	,�����MU�W��l��K��ncO�~�u:�u�����7�M@��a/P�}i         �   x���ˊ�@Eו����[I&]�	4C��E�4�!��?�0�ѵ�[��Uah*L���~���p:���vj� ̬��?�T g��ml$�r�_���\��~|����SF
�@YRC��Ӕ\Ś[:�r�v�&��'��Y� ~
F��ۥ;ޯ�ˏ�_�rS��˪45�Y)���!K����P�         &	  x�]�Yn�:���Ud}ak��HG�Ek2(�������*���g�bMTYU�,n��kx���T�f�1.v�ݔPk�v��e�������e{a{1�]ݘ嫙�>n~X���D�u�7�f�� ���I*�9�+dPC�ٮ�IC��VYH��܇�e}���a�5��<B�g��4��ڣ}y;�ۜ��̛���ȣ
���P;*q�C�6&T�Wp+�Hmv�Is�c��v3G��4Ƞ��&-O���}�+�*/"g�^�\A��&�0�q{x�(͓��֨xz��ڬn����l!޲�7��<˭���F��7�A�A�^�]�j�AWx�aﺩ�i}4��� �r	T8�=�2�a�aM2��=�7��y8i�s�>��m:Ó-�i��M�XT������u��Gg	+�]J@ԅ_z��`_��� ����� �8�Gv3�h��FX�]�1e8��ˋ��[���2+G�/$#��	��=�'��!5�$�*��6��R��󺗂��	�ҟi�z>�V5P�QԙŎ���� �XF�(�Tz��ET, �?#��{�����5��	r�����ͪ �G��W9´Ct�h,�i�y@��ܭ ��� e��#�v�N���!7�$���.*�0̂|�.YqE{MX�{�;X��O&��C����B ��mW5En���&�ê�o܈���ecrI2����z�k5(,�'�a	��>e	�2<�꒶&d$� ���&��̧���2���co�v�n 7��%pe� ���w�����J$�$��<�Hp��j�F�Z#(�܀����w����0
%"�e�;\>L8���=���IP*_ی[��(��9�\"���H\�zp��9����0�mP3wT���jBo�kʍT�)�	�w,��ܚ��_�N�r�B��U3D/>d�ZT�1��{*���Eǌ��Dg¤#N'��ʼ�kC���_��g�����yfB����
%�i�'Y�K"���| S�ɩ�o���=�����_��)��ls,qJnfFaޠ���^-���P��"��E�|��B�����GQ���ڏ�(�a���3'ݭ��������m��_�P}��ym&�^���[���45�v�9�[v�����R2LL)�T�eI���-�6���%��Gۚ���}\LQ�ۑ�$�::�#B�}�a��@���d�G��)r%�����Ŗi9���
5�S��n���bEP���iUY+u�Wy�� �#���	���0��v3��O��S�Z��1����x�5QMI{�k������m�D����nD��%-��3FoI�>p����9��J�s�T�i2U`�AZsI**#5ZQ��0�Ìv����Fv,�܄ĈR�O!UZ@��^0�v	��V��|K-����l����X�6����c����担��~�1�\e�w��>F�Bh��HK�HS�"͙����9����܈G#EBQe�1�+���r��� �.�McNn%�&���;_��E�8�t�2l�>����-�vRr�OUC5�a���<*�#>�l#�B͓<4]b5�1Jߩ =�&�n�M�hx�KD�os��t�X�s`O���T��B�&ñnGR�Yc���=�۷<�BxYu���ۙ�r����xB�V���؞�gV��#�=�\_X�#��a�K2�ɛ�K�6��L޹F��fe�k���U�4�1�4���o�%h�N
���>�Y�H�S*M�|�q
��D��;7��2���B�t�l$���a�G
f��k���Ť��j|��F���!�'L��f�|�C�q�8`�� D����ȕ�=ҷSP���e�1ҹZ}�)���)w	i�� �G@�G�	��9�ɖ�	P��*F^�6��h��U+��P Y�a� �Hc��#>C!���(���<�c�D�b��=�"y7�=�Дm�jӣ@q�'�4R��{��_�?Z�D�;�V��Z ��;�<��n���{A�|���XdFԜ�PS�)�]�	��;�y^�v ߡziBUR��r�����Ө��5�J��,vl[�yD��{��<
�����*����J��TN��=�t�~`+���D��A��+A�����Q���g��@���yX�%�8����{����Ǵ��9>�PJ�v��gX�.F���N�����!�jE��2��	J�?�|	UYzsycV�`S�S�4}�]Pg���^o�Pg9DCF(��k���w�+�s<)�)C��~x�Y���v:J"k{�����������         �   x�-�K��0D��0#~	�,:�@�Ѩ���9�����r��h�ӻhZ##��y��a:�/2u�8#z�^F���X5���u�Ū��M��6�8?i��+L#3V�BK���3�s���H\i,K�Ww�zē9���P��$u[�`K	�2݁H��nL��TK�{�����Ӗ.�V���9��'E��+ъ����Nc;��}�M\�s�Ah����x;r�����ϼ��Z�]�G7r&uߏ��)����[�            x�t�۲�:�5z�~�y�}�*&g��
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
&%���w1c�='�an���~# 3�Nv-�� �T�]`��>jÃZK��e��mV�N��BT�`����s�x���{���X��������&2x��*2�)�6�-�a��g����A!=� �l~�|�,f�i�A�)}�T�Ђ�����"�;�5����\^   �^�@���Q"�Q�3��	R��A�Jk&�R��cT�ń8��i��!��wF���6�q�\��"}n��s�5���/.�|=�Y#$��LW��2��N]��wwI��r�|n�S�sk�z�n1�Y��^�D����a��\����3�Ξ��ik�����_N�0s���[�K��y�Ї��r�}�y\1<��(G���&-�`�sȐ1�3�g������%1$ϘsJ���v�B!���_}���9hJ�Ϗ����Q��l            x�ս˒%ǭ-8������8���.��ud%u٣;�[���v=hYU���ہع3����#3�2k��B��;����{w>�#�#���wo���ǿ|���?���˷w|��w�?n���>|��?�?|���]�\�����߇���ۇ���_q�B��=:����L���=������
V�Bq!����������޾�bհ��GLaɏaC��r��:�_����t"���|����ǻ��||��fP��N�В��#��-f��������c��ѡ'�-D3��%T;w��R��/�o�?�dL���`�X4b���Q ;�	�F?�>Զ�f��+Đ�w��������@A�������j%��M�&�S��vN���L��4;�iJ�������ǻO������ۧGAL��:B;_'eY�j� �rJ6����rM�=bs  �Af?Y\���9�P䛇l�5fАp�A+o#c��ͣ*h�g�Ń� i�Q\�v�4$��!��l�y���jqu	�_Ɏo_ s�snJ�7��#z������Ow/�����?��{��g��qR;�k��l'�Bkf��tl����V�tl�7ldGɥ�+v\�W� �>!|2;!J�e���v�L騬��vkڹˍ�����w�fGd�x�!fW���Q;����.^g�kGs���v{�d�@��^Ky�U�X�j.���?��x�� -�	��K�	- �Z"�<ӹд�pCq�s�����T�l��U\��㘄������c�}�������^�cW���\h��5}qx3����� ;����M�r�� ;�Bv�b�� ;V"��j7����op)����j�]܀��&�ki|�q	��w���@rd�5�k�$�"ý�����y�i�A�������ק��������'�����w���}�ǧ�O�����?6��ݗ�ib�F��J�h���`m�S��� D��>ܶ���m�K=.Ta��v���ъ?�{��ۧ����ʷ?�����߷�7���5��C�d��D�zf�@B蘬�Q�+Ƹ��з����4�!�St�]Vm4�1`�H��@3�D4���|ř"�~�� �W����[}���
��4�3 ^)�&��-#��wNx��ݘYcV�ӗ�����|���@��3���b1@�����K��ãĠ����b��9T���jg��G{ж�b���f;�g�r�l�K�G��4n���¸��qj�a��j�t~��/���o����85�4\,.6|���@;��M�ΐ��qP��G����BD���_+$���(��Ǆv����cav�.�$����-��H�,h&�\I�1	g",e��.x��
��[1��ٙ���~A$�]�x�(�34@y:�M�0&M�'~��	���Ea�y�^��%���8�d��C�#bry����7?��͟���O&��
�n'�w��܀i���N�8b�Icf��o3����#SC����ׇ��1�Ǐ�?����[����#�?9Ѫos`ld�FV���%+���/��%�$�q�^�=X�ͽ��ɮ�"6\2r�ӈ��#1߇�
��@A�q�PΗ���(���ɨ��G'��d3������P�Gl���;��#M\v�912Z�i�#���zM�&�5�3��B�k�G��x/Q�³�G@�R�;�E�΃��:�渗w���zq`������s��
�"�"Es`��Yrx��������Rr�
��ӻ���z�����csB�u���>>}����oß�����Y~�ׯ���n����������Q1��t.5M��M�K�;�iG�+S�|�����H���Y��t�D�%o�/a�\E�l��=��ȑMN�)��[���(�vI�M��p�X��?~z�g��ǧ�8��8B�H��ā*�����T�bmWŋ��GY�p�\Br������2I����ӻ�{��;��s��İ�Þ��O�bc���:����mp%�Eqk�ALS�ݪuʵ���9��QU[\T��*�\l��-nԸ�k<�5,)X��\��7i\��P�Ǜn���V���#pK���$h=�U�~܊�v��{�+��|�����o�@��*F�M��c�������f�n(޽��=~����G3�폇���_�<����6ʣ��6jj� t��[G���q��9���hd75;ofF�y0�VJ������!�.l���t�)�i�������0�S���1t�Z��ufn��������_�KＶ);�GN�Ĳ��>�z�/�$w�,��5�1�9���ŜغY��nA�Ў�9s�9�sl5?���w���;��)�|N�c�D�|4�7��g�g]w�4�S���FɅ4�7@~����&����i��Q�͛�\�Zo�DM��Ķ�1�L�
A�>Iu�$�� 4q�� ��f��y�����Q�ъt4C�����H���Y�Xʎ���9NӮYC�{��N#kW��#yd�/f��i������c:&Ff���[po����jx�Ӹ���G~w�>yF�ѹ���kK>��s����U-7�)�&�F��e�WDꁑ��V��}���_O��<����ky�g���I������������o_N���_2��/��*��9���zD^�����?|����A1��?�����������s���-��b~�����c2���A��oϏ���]��D�p[���]�����_���~�x�[[�3��.���>����{[�3B��O�NN%��+�N�"<	1�"�;�Y�%�_�'1�I��ۆiT�%�,��i���S��ƕ'`�RBۗ�֣��Ux�1�cS!Oªy�ұ��`�WX,О\�f��B�͛�k$��z(�	z�cm.��z�� �������k���"R�X,5�[EҺ�#?���#����")�~^f5	q����iY�'M��"
���L�#i����.��3.�W:i��bp��:eғf-Y������&�B�<������]���-i��~�I�?'���V?k��Ţ�GX�7l�:��,!ˉU3GL~�SR���ъ�'������>��G70�8'�{[�?��81{�(�[���|�r�@�r��)���u��G��z�+������zlC���'`��ȋVN�"8bHԣ��r:)��q%�(�Е.��b�[	v#��#�����T�I�k6��Ft�+3p��X��%(�s�ŏ����W\�gU^�40Z�g՚����J��c���F�� ��㨁E{%�W�s
0)�v7�+�m:8i`	�z<�M�଀�(���HO.=p�	FV��)�U'����!KWMY��2�� O)+܋@��z�+h`�edO�pXS��.���I�3�v==�������g�(j��Ă9�U�#w]
W���-ʬ�s^��)3�{\Byh��LmQ��ls*�=pl�S'fũ��k�*ߣ�i7�ӧ"zM����]<�n֮Ca��G4Z��YjW���x�ܠ�j�FZ��cչ���*��,�S�0���9�>i�ą���q�Yg>��y�$� �8fW�mêLDy4.�t�07���m7$�f=�����	c��c�V9_uY�f�����^ն˪�wP϶��Š�4JK�|���)��N�JvR��k:��~X�@��t:(�bg�k:e�������4I�8�'�t0h�$�(�Ձ>:���mx�����SF�	��d�Өlq�|�8|�rN��)�Q�&~֮���Spi7K�j��Y��)����AʜJ9� ������c�v��-3��ՊKW�6j�3v����e���x?�F�{����h}�b����B_#�80(`vܢK��ƞ��0�Z��pt�ގ ����8����͟�������LV��i����~��W��&�A03vi�}���1J9�)��ᡋJ c�5�n�}Tc�'jr��;r�&biȮ螽�O��a.y�.�/��a��k��/��p��hfCI�f_ j
e�*2[�'c�H⪇�Z    Ȟ���s�*�����XS #J���^S`��q�!��D�����u����/o�>�a�&3&N�d��S*���֨�3�,QQ�J��6�5jT��!cTR��ԡ8�mg8iTd����N��3�C����Zz��]��q?����hw%�uM^�J���5(T.���������t#�ԋz�x=9��;&M^�X���u����M?�Q4]#�nX$�-���nX����	�b�4��:���b:H�l�
�u����5.�Ύ�Q,�6k>�j����p�0�f4�-�[���ٌSCA�^�3k���\����fVW����5I58i�e}I˚���|�ym�O֌�5��a�x�5i����К��v��v�.S���S�JиQ�Q��bL\k�uGA,ϓ�Z�5�tb��;�LX�o1[��J���_�����W�w���9����PWG%"�{UQ�x����o�ݳbU� ��Dk<O�0t�]jTڱ�S*,js�ffTӱA,�xt��J3�N$�^��jfP#JK���_o��F,Rul���r�|��A�������f�,$�ΰ�%M���s�i���$Ͱܻ�:�l��^r(]�� y���%�O^��p�a��p��rjk�S0AcJ��pzK�C�@�}����թ��O`�1#�@f��0ɳ(;�r�IM=X;�){�4��� sXΥ�I�rC-1q���*U�3ʪ1��g�a��/�趰HFlg�!dP����/g�v?�����h��d���0 *LnCZ۩m9�Qa����3L�`��.����ڤ!3G������M��vY�`9��1+�7������߽�����k�����Ǐ�?�����<���V·/��Dk���W�/bZU�5��au_|�G�A���ҕ�%�
6��_	���f�C��9�"	�Y��%C/eT�0`�\��hݧs0Ic&ޮ�XQ�s �2�0:�eV�,�Κb�i��a�-��Q����oͷ�ɀ|F�[�\F�OdTg��$t~{�������4O%��:�o
@HT��1K������<��8�Fe
��&���͟���$��^��CJ�r�}��������������sh�H��dH�ѫt�]�,SR�q��8�U�
�+,D��hL�X�+\yg��.v�2^g��6�e^'���:�N�"�fa%C���Ǜm\q����[bb:�6A�w���Ow\��`�C�ݿ����o����ꎾ/�(�+�}/���(�rv/�m���;lg���N��f��� n/\���zԇ wSJ�p{�3=�FS������/���o�����X�*OqO�����]�g �)sau���E��E�C��Ç�_>?��U�������ǁ���x�A��9��o����m�y>� ��<}pº�̑�����U�.�E((@*|����L���+i�7b������M�mq��(:
�\jN�-.i\�Xk6�}�:���3�]"C7fTx�Ō�y���9*��"�5�(���6G۲�S���0���`
�xܽN��Ǩ��&
���� ��=����N���tߩ���~Ө�c0�]M�ж�nrb��\��v��d0�.ȅX/������ӿ��}��G�������0�kَ��]�R���"-�^YAǡ�@���EC����bx��4*�b��F�1��ld%���pG%#���[,�ݯ��~}������3����#��>܌}w����s�iTG�jF#�涯j�fp�ې�5#�f�Rd=��9��f@��o7CP�kC�O��&���e͘r��zj=�kF�f4?*��X׊�����\{�X������G ��֜�z3XQ֚����~���1��N�f�U�>Θ��}b?+,7���%����{xȩ�l׶|Qz��i�c���&���)�� �
�B^Mld��i*1r��t�}5~q䑑�t��v�I�m	R������q�4ҎGwG>c'Վ���Zv?R�t��&����;]Ӷ�\���PM혔��K��5�ڱ�d9s��U��1�FP�/��#�̝�k�9tǗ�\�oY���vٵO�-��63�� ���;��53�'�]��H�z@�VFY&Z��J��->�u!{w$�JY�(��L���	���h�c'�M,,�㌗�8��I2/D.�y,3��]h�+	����UC'��S1?Ҩ�e��~!�#�	�|^�H���a����|1��Q]�zP4-+�z�g�e�ܦ~�]FZ��p �뒓cT%��l'G�O�iT03�OU����(\.i�Y�V�������6�$��c6��[��g���;<Q��4��p���ݓ5.j\	5G�ي�Í�8m/��*V���W��dZogMW�!�\���<�+���,�/;roR����̐��k:R�=,�G�9w�C���*h�A�>!!j�,z��<!aTЁ�ޤ'��)�טzT������4�%�@�Ņ�U�q��
j��(w�졗�XV�߿9I�z��+�+*��0�=4_H�D���:�FNvc�;��49n�n9�8�ʩ�+�"���]�tP�_�RL���bI^��5��R��J�kJ�[���ܱ����Ϥ��h����r���:�$��N���'3S4�)ORǓ�}���!LO>���ԑ��Ѩ�����&8 d{����i��w���:�*,��+D�I3�sg���.���<�z]"��h����$��.�I��¡��a��	����,��P5Q1$�7��B�D�Jx����£z��F�M��� �4��ձZ�!;$M�,�t���F�|�Q��8s�,��I�!˿�+�?�v�g͎yn>���gM�\X�.޿��Q�TK���}���Q��LRMR,���r���RrG���dM]��f�O�I�|�k���ׄ[8Wrǲr������Ѭ�XIGk~+����I�K~~�j�ʚ�!H�L�E#��[i\��b���U��Ҹ�ckFv�&ݦq���sQ�+]%�p\��/���
hҨ�Ux���{��^F���4*���&w���
�ӨN���G8�1c_ܣ�Ot�Ký������׶{��/.��&�ѷ��1*
�M}(�z�1CG�!D�/mw쪚Ҩ.æ�c^ �|&��f����P01��=���p�ۜJ@��'�L}�G�UI�Q}�`q�!�.hypx��cr�]c�ib���r WiDΚ2p[s9����A\�����_}l!Y�9���Gv�g'�Y���%~�Q���m��M\��[ߦ콶)�L��MAلҫ��O����m��ib��kY�ʢ�E�3ڝ+�G��\	x�I�� ����-��^~s@�%��]r����'=ٛ'td?!X&�A�e�v����*��ٕ���&7���"�1��q����b�~�Ë�rj�a:E�֊lAE��R8o�D^0	8$.��s�&�Azo����%�mIɋ�a:���.��Y�I^i2���c�eq�
w]�B�0f՘ğu1�xd��h���1���R�8m��8&(L�z��5�n��9�Gw�9)�{���?-�yBS�-�ڲ�T3��@=&ơ�fR��X3�j(�!��G-L�͠����"g���!4Gr�I���)GF��iW�zA��Ø�Ǥڎ���6�:�����e�?b���d9�QC����h4B��+�;l���4v�_�3-,����8p�����<2NX�_θθh��W̌�7�UsP��ٚ���ܰ�8d�A��]�����,b��͐��\�D��#��7s_��ʋ�Ү͗=���l�}~����n}�0�Dɿo�(��a�^u����n��&6r�(?�XUf(�41C�)�z3���Z܌�ͨ�@V޿E��n��j��Q��(u]R!�������u��6��;�;1�_�kr�y_�����*HE0�ٻ��r^y�P�|���
k$�d�=>��L���c'��"b�u"�N=hs�+���Ȕ5&��8_n�+��g*�1,�mn/T{8>9��2]N^a�h�����8R?��U,>�Џ��K]���x�������������߾=���×�;���B�_����/��/�����i.2h����4in&����=f��Q    �<��l���Өi�aH{�3�qGۻE���O��j�ק����b�������I\c�e�ͭ;��>kE[.���Q��}6UEt�+��q��{����9|�9��V
�392̠�_�ޕQ��'�uۯ������<�6#KE�Sʚ��$jú��9k٢�������/
�_�}�[�T�����ዢi��;w�T��h�E/z�tca��IQ��i��B�0s`��((qվl������+�A�b�.�^�f�ތP\,3A��7D�!8�3��N�̀���/�y���]�*m���ތH��[�z|���BX���N�~�Q��1����]�j��Yd;��Ewa���pZ�/�E)�×�����/��:V�v����]׎�3'�Εh,w�.�#j�N���j�S���gBs���'���3v&��_�S*{��ڰ�c���'
���"�>LZ<ilb?�29)�5 ���?���kv���~a߆��8��B;��k7�_Ҷ�:��_4&��Bz�y	^y�l��YB����y����3⿟�ް��U��g+{lnWZw��kMJԆIK��O
���*Y�M|B#R��l��=���'t�2n��;��W�qqPY�Օqm�`��U����4S�6E�1�g��q�[�Nܻ������H�q��P������P�Jc��u��%��4O0���Ԕq���Pbui��r�CIz(�rڍ)�7X���Th�+�@�M�5M�#Gj�va���"G}o+�t��Z{A}�1jr5�Oi^z�P�G�,�[���kD�P6(�ܘ���'	� 0��-;�1���vط��b�>��,m�W��&nw�Vh�]p���^\8���
:��_�Sz�^as���+�6��T-+��"hlI
+]����(�a�S�i.!`�I�[���{�I�h����=֘��c�� �
���a$lWP��c���t�OJՆ%I��+D��+l�we�G'
�U���c�Ɩ4.�B��B�c�D�з�F��KR��$i�d��輿��6�|
;����XL��̆��fw�c͉ќ�Mc��7��0�l i�V˩2F(�9��R�݋�����	ww�\q�Ҕo�檲B�ZI��˸p�{lnrtP�ڸ��I�P�~bHaG��yw&���qC&�
gQ���]Y�U8M�ݪ� ����Ua�'���p��^cG)��ra-����<n��3f���a^_טs��R��-�\9*�0s%S�k,
i����\
c��z��h�qg��e�;����������*�8Tk��c��bZa�e�{ &�
�6hl頾��I)��A$�;�������/���'�D������p�~��Ϋ�F���9�����<R>|�!D=�/�c��ǰ��/���`���Cz8Q*9,���zP��f�>��dMM}��_�K�-�ٔ)��x��w
����Q�J��I��[T-5h�Q���6�i=(�%#��P~֣����t�mZ��ȗr]J�}TR�Q���e�R'�p��f�����㒾�b�m��_��|t�@��D������:�@�.vO��������qE��R��'|\�Ƞ��^��Ύh��u\���Q泟xO�F�}�Cvi���:g�!z����ۅ(w!��+RF�tx��f�`qSA{�����v����m$r之���듣�NܩrgR��an�#�=�����/��{�A�S$j�]r�-.g����n�]�p��%胎2w���!��I�E3:�%>
Q�8��u5779���G���n|��2L���Y��έ�'�\�_�;�	袡��q;����22J_ϔwf�^�H��H�k���P���f�9QY4K��@���O�ט�6V.�N]��5E�g�x�y\!��77.��h\@�8@�")�j��/M�Qڟ7�'k�;��z���eb��~zr����'�a��Y=���Ϙ�ݍ+�X����r��t��_�	������M���9X'L������	�W�z�5������k���ih� �z	\u~Ro$G���t������-MOG����R���'߱r�(��ұ#_��.�k5MGʦN��Fj���Uqt�J�	��y;�������Ly���0�rS�Y$m��Y,�#۱CL�&�Ų�8�����������Y��|5"�wV��	_h�۽$Q߄f� <��殜�w���Ҕ���x�ų�O�����;�1�F-i���)���s�KC���r�Z�͝��f1x�Wp�(+h�I����|t�c\�Ӡ��Ar��vz�C'��9j���/I���4<0>7�&�v[i�&2?����.��P�Ț�6�w���Cge�$ƹ%�V*$�a�Z�Ϋ��ꚞS�lGRj}~��	�َċ9��a�'͂�$��X��S��^r�|��t�ݒ�69/��o�O8�jsw�ﱰ���F��rT{�\p�Q�r"���2߄�����g�֜zh��T�H��� <8WN���(=��l����jd���
�����KЕ��5�C�|D*oV�k��P46.�@��5�hB���9�
�TѴؠ�DR=�v�j�hM��q�d%�R˔�A�g+g� =!7��GqϮ�>�h���<���	�UCslإth_]�	W?�Z�>ۘ�k��U$��%���=h�
�}Hd���k2חO��qm��c5@Ґ��"�j2�4�V۶��U�Ky���~K1ՄĘ�Ef���D���cZ|=�{M@�pi�;>���Y�ɨY�K�{d���y�^�S��q���'���$��`ݩ�<�1���xB�����f�f ��L��<%�p/�iR��r���4&Ǒ�5�(+HYg��Mr��k��jŵ���!��<�ri+Boy��2m)�{ �Å�\=�F�
��n��cY�kq����li{�x�G�N[2�KrЬ=mI���ARE�E�-��|Z8(�YY3J�Dv���8�������!hfB�������4+�ȖӜ��RL��f[O��z�0�'��F��q������W��N�b�BY�J�%/�:KX��(�MsY��	VeK�����㓏kK^�f4��)W�� �{�޹9�8L�^���9S�7�Hb9vW�q	� *�<��e����
�:�):�7[�[W�D�T����R��/���<������|J,��"�1ݞ��7�[������gLm>E
�gjЦJD&輼[0��?j~��AS�7��4��9S�	!
���ޜ��,a���0�9S��#"�_�>w4;�
ۗ?�>G8�\躃,x���@��Þ��ˏ�4׳�s3ʪ77�Ҹr�ƪWie��C�F�	���f�U��D��W��Q[)��aܔ��ͬ��[�,�5̜�-I��w~O��Vfe%s�D4�Ҕ���K���R�kn��_��o��JŅ�+RN
�
D��y�^a�%Pf2?�y�'�4�g�s�.��(������b��/�z�%��/g_�΂u�Sꭈ(��'L�6��ɚi���W��Y�H|7`���1�ho9��ߌ��7���j�2{m���z;�-e"z��u��2��B�(|ٓȲ�D�6Q2J�wg;Q���D��f�I='�6�?ͅ�5Q�(��,�pKGf�'�A�pώ����4`�$ti_J���O*$	b���}D!�p�r��SчA�m�~�y҇A��TB�ƀ���fE��Ig���W��ӋX a��Ҥ���O
��mM��������9}�����Q�z���.m1�}.�&�Ny=��-;W���C�p_�5&���Ꜥ�v����

.��"�qqZaii�Rj�^s�H[�+�����}\��b"��g���`�����:�5�*�LT9N�ٛY��$f��of��f�+��z<�"n*R�L��z���(/������d��$�X�}o-�0S�?{��V}�^�?���n,����� �΅�w*|ô�W��o��σ����7�����f>����:ވ7�:BPf6�l�ӴV�n��qe��#'n� _�9t�Y�Z�niФ�    %*�J'n �44�9�5�k!�ފ���m�[�P���c��TwB�h�]6����I�lXW����Csӱ�qŢsУ������~�����3$6�=Z`]׃�)���n��_�YN
1ra��8��,��Kq�+!e�XWu�`J_�'w�_���^Y�;�>�-�#0�෋q]��EPV�A�V��q�x��A���������XF�y�D��ŧT�'e� y?)-8�7 �e�
4�}�P �p��v�UAr�A�˟4�ϠG+8��z��7F�"�a�V�A��斉a�����=}ث/�N~��iC]���}xz+QY�-��M���pC�3���,u=����&v�.����G�>����<.K�r�Ʈ�t�ЉݨUF]54�X; Kɧ0�F�w!n%�
�2*A^�c����bf��	t߈��47h졙8���?*!�@�(p��	?O��o_���������_>>|}�OA���J�{.��&�$����
��z��������K��{L�:�j�*�@���������7��t��&��Nq�#)��O�sJZ� ��'�z�K��eO���FNQA�q�E��zDY �!����`u�L�}�p�F�O[$v%#o����C��tjՐ�a�`���r�-$�Z4Y�Qe���,s.S��/���c�
�$�O�^�f���rH(h���E<'������'�k4w��p�9tQ�A|F��3��|�,M"9e�g�2��ۭ0���4�������G�Р�Y����U�0tb��Ls7訠�Y�=��B��O?��۟��j?��U������Ѽ�m�NZ��B���Ӓ�mC�Pҟ�5l+ڶ$�C�f�k�V�m�]�٩|=ӪצUn����װ-(ۆ�d,;�Ժg�	�M$�wo�ջ�5#5���ihw({���չ^/��7ǪI;��W�WUU�v�\�Y��/.�9y����-�КrI�����$��ɔQ�Kd-T^s��	t�������I��X����Hқ
V���ɏ3����j;�O�?%ʡ�r�/�~3I���X���>i+"S;���>k+H��W-�_z+�A\׊��DH�Y؊��AB�jOA[��M�vc� ڊ�5�e�8c@�1cO�&�v1��Eo���	6��ȚA(ٲAlC�$Ȩ����nvM��������A����"�ovФנ9p�8�T���R��q�4A6�?aw5��m�;�hm��"������>]`J�E�Q����FF���
�YC�,�D�C-!R���Y�)������y���Qy]����:(h�v��?=�{z����_�?>=�=<���ׇ�|�2����}~|z�_���������.~��(�&�>W{hz �y��Em<I�V�I�5G��7�ξ;��6r�-vG{?jT�1@sQ:8� 9��69���W5��p�ol�%f��ʖ[�Q���76�@0*�`D��Qj�lV�
���$��;�L �<>�}z�����O�oT����]���<h«^���oe3P�Q9>.Y�V#�
2��e呓6C��Y5Ĥ塍u���J��|�||R�����n�8	�hH�[M\�`Y5�п(��[��6C*-���I3���0���F�YD�!�Q9iBá���?2�L��Y�n��Ԣ���`�Y�f5���N� H�KOEG�����Gy�������x��>}mt�&�6��ٚ)�eJ�~�UCJ��d�����ОL���Ν�%j�S��!N��2�A,lжA\�x҄9�H2L�
��{hlλ�������I\\��G���㪒(=�Y
�u��W�1�66�ɦ<0�F٢�m��Q�+R^`�$�q��5Wc\�"�,rȓ����q���C���������'H��neQE��t[�+�P��r�oeRH�W8┒��h���u4�ncZ4����X�w���۾��of�LYZb�������a���E��y)A���f��3k­엂��v)���t^b�i?�2����Bڞ$B��4[R˝���T%k�6Q�����Fhw�t+�2�Y`��ݠ(��/C�Ҭ�}q���.w٨�G�(�=U�!91/ZԡCE�ҟ���k�!� Y��b���0�
���`�IC��e���+5kh�VKsZ�KC�j�ޅ�����Π�C2���l�ܼlŉW�8��d�J$L�j��5O54l?='B���OI�9�Wy�O}�ȅ7w�
8��D���9�����z�vq(`��>kH�n�W��ʌAԶ��wU{����^Ô�*��������u������%Ͽ}{~�χ/Ow���0�n@����A��5��U�$C����N�A�>Ā=*���b�p^�"�юHvՠ��F`z#ŐzX
���W���Y�)���m�Y����ʍ�fUf��E�ڷ[2&��zR�z�7��!�6&�c�9;f�*��d�{�$ sK����A� �@BԈ����l�9H��;$��4���������2Is������҃w�2��#Li%x�x���AߣRr�}:��A!�P2�Y��
K.�;���<h������J~u�rvV��C��)�z��G�뚉�H3������#V%�#���.�4����팬�'�⸤�8�3�7&��UWҼ �⨬?�qyI�#��#������#*u6_w�ϸ����z��
9��pH"1e0�nG��p^ 9��0�>.������7�y����5 �X^�3h���.z'T6\=bl�`2��%����q>�<���3ٜN�EcǸ���f4��6�슕��R����]�^s0.p4�Б��i8�k��P���;?s�[z�i���Ʈ��n���fʅ��h=ܢ�A&?k�	+�2kެ��ܧvLt�=(�_�K����Bޜ�p��0򈪲�T�"{~vv�aDT��x�c���޵�q-�py���%��H�+Y��R�Y|H��+YH'sׅ8�f���=�<��9#�(Hy�t��|�jDVOt.k��cJ�E%Z�#�{p�㺑�rc(4D�1�t�7�D��J�훳����=$�c���CM�P1\�)�p��T�ٷ�ÐYC&�aq3Ȫ A*�k�;s�W��5(�z~��aȠ!��]�8	Rj�p-jH��H�ę)�G��hdGse���<�lx{.IA�Fr��h�a�	� �7��(?ɉ��J5���[5�d3'����5d�Q��EiC�%١!"hD�x[b�2sL zuuB>At�����$#�q�ɀ]k�AC.oY{x���~�?���ՄC�	�|.�5HhG}�L�$H�������Q��+Zr�^�xn�(���E���a��)���ACGɈ�������nR��zw���H|م5f?��͏(�����L�9sr8�����bp���a謡A*�� ���͚�F_�A(�@��~ќ�q��؜��ko*aszo��൩,��h�i9�KQԪ�C�qT+ aZ"�װ��F:�@-�(0��Q+�x�X���iD[��WV�N
:rx�y\��Ʈ��3���
�(��ONs�_p�AM�����GI�HQN+tY���r�_��Q'n0�S�<�E���e�.�
:�2S*�s���Q#���س�(q~@fu,j'�
+�&Йh�������Y#��;� /n�22io�8ʳߘ�ܪs�?�ޫF���Þn��/�(�~k��K�C�1�����K�V4r�L�J��W���m�:��^?Fmj�4~^H=*�Oѥ�����v�疾:�j�f������5�&e6��i�,Q�-�8P���$>M�(�7!�iC�LՑi��ƨ��;�s���}*�[������y�/Q�4���|^���0�^Cܴ�I��$�8��AR�~(��L�r��g��s	,'�r��x��~w�R��U{|��������;��c�YC��c�&���uH��G��\t�u?��}�����������-�L��ʨe�-#mk�r�b�O	zH`U�p�ӣٕ$?��1E��J��|pzTψ3��k�cj4%    ��hG����(��6��r�^�ڥhD�9���2�7={K C2��'u������MO�X���Yi��SG�$IL787%�F�hGɩ��Ĕ�Z�vK����Њ���!u�����MNψ����a�κ\���4�5�(�'L��1h�'s1��f0�P{\����a蠠��7]B��8*��1�6+ �B��@�>���@W~�m�kMh)�t�k�d =b�AlU4}�
�;kd����K�t�МiݠW�eUA����]�G��@��K�s�JL@
,%���>�Q��Z:�p}�94jh��.���Ӈ���.��}��`����`��������ׇ�߾����z=~�g�2�Ɂ=!�
Yd�7�9�����R�-(;�޺�>�*Z��|�T*����hA���Ш�ekD��*�:o-�� ��e�.?�:eļ)��]����:���wm**d���l;ިPQ4��}�F�����"�nM�pY-EW��\�������y�mE����W�E)��_�fN�kh��3{���B>��r�\��bKC4j�h��Bg���<��P!{SH���7B�f@�+��֣�6����5��4�r���s��bhmp?ι�z�k��z��b�A�&�A9�\��9��SX�����I���9#�,}Ci!���ҥqeMy���qkϕcĈU 	����5�Ȁɳ����'-��K�ߘ���Y����4.���tq�Q�U�-���t�c3.թ��j�C��
�f'i�Yj�
��<����2.�y�f��Y{��q���Tλ��[�q��(���D'�j+89���<�����8�"|��5��<�䮃���4��z[怎Z��bɛ57�fM����GVڠ�@ـ,��[5��;���.7`�lȨ������n�v���	��!��W��|� �����h8H��E�d�� '�ռe�q;�S�uN��
R��\�KY4$r��t� ���k!�SK���J
C�jnPj��	�AC?G�.m$���s^.���1�������3��1*4�
 ׌������������?�(�Ӓ�����6)Xot)�-씪�o���x���6�oA磨����O7wC��lM.S���ۡ�?*rقRi7�s_D�_�Q�� ����v�7�Y�@"���߻O�F-]��k�{��بtekj��	��D�Q���z�0�	K�z�H�t���Q=ʫ��U�����������!�ViJ����VԼ�iʗ�0��T���,�)(0�Q��Nh+
��S�3�ϙv����fFV�\Jl��jM��J6]��~������l��N=j��)۟�)����+��x�(k���Z����3��7�P�3^����砭tN[\��� ��\���cGͅ8�y�t���F�"���Om�>5n�'
/��4��/e839�䬑�A����B)���L���F�\�	Z�x��--���)J�ȑeJJ0_�9�ŔeFW��*+�¼D�	VDmE`��e��l��:�.9gv�;a��Ht1�>DW4�Q��o}Mq\�_�-�yCq��#��q/��b�0�<�K��Zj� 4^���z��7��Ծ�Ǹ׏~���L�,.l"����W�R�
���ĕ�[���6�	e{A��J����l0��$����T���<Y!�/�v��K���LN��K��\�:c@��KBK�#R��J���by�9���'�1���f;K^�fs�#8۵]͜����^���Ys�Q �x�S�F����]p�i�S��x�S�+��IY[mq'T�W!��T|2ƭ
��r1[��{H:�;�)��D�AQ�C��� 4�@��{�$�s�'�YP��y_��� �(��!���qk�L�����݋t��;Oez6����s9tN��� w�w�S��բ���M���$�-�k�Xz�G$)**�@�ֵ��U��+tM��X�+�!��,7Z:3C��(!���JcQ��$�x������<|^^e�Y{U���VD�y۷g+��Z�]�4�k�	{�� �i�?��g�͓{X9������b�'�?a�UCʽ?%�XI�=G���׃���öyM�:�]p����W<���	�E����5~Y4�92���g¨M�L#���\�Qc;hM+8�L�ԆjN��v�Mo\.��_��|x��)Rv!��]f�'���mz�����C+5K2ht,Z����4�^�LȂӠ9tp���͂O��P�6v�L�}.�Ш9�����5�^pm4�reJoc�7I�eЭ�G��L�ّ�@�S5%S�����7�&Wm�?.��upCфmY�K'v\�a�	VL�6���_w.F�[���u��e�Ƥ	5�P}����D����.vN�C���I�[���nv�-=�'�3v�����dA�b���z�����
��sܓ���s}J^[9t}�Kr���J��"�v_u�Ҕ[��\z����bI	���,�Լ�۲2j+��Mm�V�޴Kɣ���z�����۳��т�Q���T��E���ڥ��jq�!m����!;H�7��N�zS�+;JYu�n(��QOY�0rA�t'�%�˚���t�S!z35�Hoy�Rmf�*�Z"bm�4-��Y�i������Ɵ�6 8%h�O��4��
�a�œHwLC�� ��ry������Cg�-�|�k�0�
R�i>�	�rVs��Z*k��qc�k�we�C[=kh�@��n��4��|�eN3���?���+��p'�F�Xqi=�a�2�'�����-8�u�:�����l ��v#Y�	��w�h!:8�]�	�	��Qgw��F9M,���.��^.�d����Q��ƶ¡�4�\�6R�EQ5+Ak0\ö4�-q&q����W���r�v㴤�ZfP��~UϮVe��6;�O�a��H>�6���1�TZl�����j"��=hhiCƭ�g�أ�RL�p��hG�� "�/��v��q+?T�h���G�;[Hn����{�t�!�󗹙���yT�3@S����OU��ľI�UJS�i�CBM�/�?��}���_�������>|����Ϗw������?pT߳U������+��B_6���NB��	 �c��T+���q���mҀ��q#�&�R9\� -�8bT�����<N�|�w �����.N� V�(#�Ȕ�3�k�¥��[�sC���xG����Q��s6[G��J:r<Nl�DM9A"'��� � j�a'0[~�I�[��vP�ͪ����c�V��sD^ߣ#C�aGN&h��X�)����A�!3GM7A*��5ۀ���xID�6Ĝ�j��D����%�N���dp�aP�)r����4�l�	��㇧�E?�$��5�����أG5��d1a4#먹e�X,/j^a��<�O��1[�N�
�3C���O(�<~t�W����dǱi��Ps����&�&��N)�?~R5�D�\n��f��}��G�\���rϐf�(�`��4�,�A,<i���u��j�a���Jf�F����A�`��Nj�5�J��>��p���H�PH�S����$�U_J��Pa�ٵ>�<b���R�`�		M��D�v�ޔ����Mj�`�~�t���1�T4l��p��պ��s�~�|-�.w�S���I�����t��'$Y��fi2��.N�5��1T�I�d�f:��tH�Lb�E՜�A�㜬9g�X-V�h�!�Iv����r���(Z��ESU�ωv����f@�`+*�i0.c�\�)�dQ6�Sm���<b�8�J��Gp�I�5��,��Mj��&�f�2�Nj�
����V�E���k��d:��P������p6�����k���ԪIG��8Lv;U�1q<�xM:�z���KY�&N�`�S�I-^����/^S̀u���9#Ԝ�$���u���oD����q΀N��;�)C�<�9��F �7�;���e��4,
�Y�u���"YLj�L�`�<��j΁�!o�.A�� 8I�ZnN5 	  Ӽ���A3�.L�x��F	�n6�d�O���f ���I-As.T��*�@�7�X�)�A�9��@G9����� ;�ـZ=n�(g@�x1.�)��¼c�x��i�� ��MM9j�H2*�)����)�f�P����q6�&w)�=\���97���W��[DwJe��Ӽ��R�+��s����T�o�)��d�-j���U1�IS0����P��j�-*�x�H)xEes�9�2f�t�2���&���(~��!�U\9G4�f�ٞ��o6�&A���f 3u3�f�A�+Y,~bG7��RSڱ� ��/<Ďi"W�Uo�J��f�0�:����A�$)�1+�*��̀h3��i�jJ��r�$Ù&��Hg�j�S;�m��#ѱ�#+��^G8�r.X�R�3X1��	�\��EQhQ��CY�e�p,�c=��7�*��.e�<�4n�Pi��أ�f�R�s��`Ю�jr5�Q�2{�VDQ��#�����Ȳ�rVe���V&~��aO�k�Yz3cひ����=Ug�.\���>�fG�ژ��qѭ�͚;5;8����5w6+��Q]\�y�4h�d����~]S'�̛�k~��x5u2j��t�cK�V�%w>綂�yтC��ǝ��y�dg����64c���v�&66 ;��4���촴@��C��b���@A��T)���0(jHdwۃ�W<��.w�s��\�n�K�(�X���N�q����`��'�$ש��蝼��*=b���^ێ�*\B�ӡIs��tG��i,�����$*_ �6,LK�]���^�0І��j����6�H<�O[���ȶ�{�:e�,"��M��kai i����TSoE��Hk� k�1�9J�>�R����vr��Iko*6���kS��Q��c°@��)�V�!Gi���l+�]6�k�U=��Y�-V=�.� �#���%[�^��� )�*+�^��� l���>k�Iæ��.��w��5�e͇����,�L����댝�j0s�k�=$��x|5�9+4'rMG�����Ġ91T.�*��}�ќ��ݢ��/τ��1�������(��%�Rԫ����Å��Q���k.�~�z�i(� 
l �L���P{3��Uڷ�V~Ƃ�6�� t�K�~?��_ځ������w����Q��]S����\��1��Ī<�[�̸����;B%�׃�z4��������S M�Y�?�$묑j�#i#Qt�҂����?��쬁v�|��R;:�N��w�n�cGg�R@�����������?��O��w��X�o���j�}���%~g��t�޵.�%iؘ�7�]z����r�Q���̽�uk&V���KM�բN��[7���ߟ��՜������bP�%���U7�\ˠ�A(i�%錟�
� i��j3�ʮ�o/�E'G�ɣ n]�.�ܖ���ԇ������=�ŝC��������k��F�"����;(
ޚ��7�S�j������fWs��RFE'[dH=��)�J���I*��VfT��m�yU?eTŲ�BQ�f���V���FI��ɧ������{.��-+5�ysg����]:Gs#�u\h�Y���I��`�h[bءصW?6���&v��|ɮ+�Ѧ%M����37:t�~���k��C{��w��/?�����I�> ��RԳ7o�Y��Brאgܗ�
���k�|s��#�]���٭ϒ!k]��n̵M�@�lwt�g�*��s��I^N�>��0;'}00rr���sm�>HH��2#ڹ�I�$����X~��>8LE��ܜ�O6�}�kiԬ�����"Ys3It���
�D��7��:�zZn���S6��51� �nkN:˝��T2.��GtL\"s\����uTa5@4�s���e�[5��2���S�sTP���|����?��ȟ�����2M�>�Ǐ�?����������o�7��4k�	��+��p�«�i\�~J;���~Tp��Vt3�5@�<l��eG�Z[S#��v�ŨRk�J�'���Q��Y�#�x{�΢ɒM%G��M�h�l���`W}E��h�l7An@F��V͵��Zr�jFe�*O�U�+�5��7��)�)Sl�.��U5j��)7,Mlȧ�zT�Ν+xJ��>,��sm�Zs�|� �EF�̠��[��N<`�EȮ�W��~�Tnj�6�}�Q���8ӫ!�F.�ےq]ݯ@�q���r�45�؃�ʬ�W4+HY�F���'���S�h�R�_���jifRP�o��W~�*[�+���_Y@�$��b�/�_��_�?���$         �  x����n�0 ��~+�I���ۀ����^T�$�Q�����D���l@?`LG̛����(bX^_�V�`�@F�s^��B5�����hދ�D�v���6f���=n^D@���kJ�Xa�*:Ѕs�9i�������ۄ�<�Qg�`�8�������xh矉�D�a��;I'R/�O��3QA4!��Хۊ�~�3��Ic�3伭��l>�����>�<���{��`[��K�ɇAahyv��Yݖ|�f�G�z�Tͫ�ity��u�����Jy|z~Oӆ��ڬ�C6��|�܍2V$m�z�dh37�ڂw1V&oL�5qD�rnSwW�nqW�l��5��3�\�Tf2�LZ��6>6=��:E�ʬ��]�s6X�A�R��r�.�ȅkuX24cQ!Y�nl��*��2f�Z���,U��4��,}��&L�3����آ`�(�&
��֘Z�{��NL7���0^WVl`y�	u��(".����xk���"ذ�ǒ�����V8���|�u#X�m:�t�,6KeA�e� ٛ�*3ڴ�i����a�K���@��4�tܩ�d}D���YQ�����L�̉ŉ�H��01�*�=�<��T�|�f��j�q��"�i�ʼ��L@J�wk��1����Ae��ג��4�\���Ε����o�)��6����+'wah��K�u�8��{l����9om�ѻ܍�K�2��o2��xk�      �   H  x����N�0����{7?v��U!D{��* BV�O
u�u�Gk>����#QA%PI`wM׊�m�R
��v�4#����;:L�1�Z�ƶ��qX��
V7CSs6Sm�p�]|iA^��1�	�j%�_~�"�	6�fT>f��ɻU�!��Eʙ.j�ȡ��w��hDFd��Y(�D���Xt抰LA�2�a^�D֡lx?Ù�����4��� ��&�uw�3#�.A~;2sQN]�E���U'��45U��0��?�p��o�\o3@�Or�D�dա���q~ �\�P�m�{�����C�c��ڂ�N��e�l����=_q��cL�      
      x��\�r9�}��
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
>����&��yϖ��HJ�H��F0A7��.�h�f�pH3uv�H�ͦ��I�F�)0�l*�*x)�^P��6�J�k���Cv���?n蠥��@ߕ�Z[���	t�Җ���S);��m2D�hST>bS���x^��8tiIi�l��Q�+/勹���(հO���W�y�Nl�,:�X�\��ST��o�G��b��!�>�*��JF���f6�&*h��Q�Z���:��J맿M���y9J'         �  x���[o�:ǟ�O�/ pyd��n�4T��<U�\0!7H M��ӟ�%ĹР�2
������O�E,�`D��rl��֫�KZ���U%¾�@��}ö&�eY�e�p4�����,{�֬��ӷw��e�P<���C�
�#���M\_���V�[��b�� ���6���#:r� �0�d�P�R6۱�$�&.�L���EjtbO��*�w��c˗w%�:ٰ8�$m��[Q;�e#y�^����\���i1�3 ��<�.�iS]瞍u/����I"��=E(��nx6ƽtR���T���+�.�`i�?�F~`��s��(���G��k�L"*��B�¢��=6���������{�`�sS��=�S���r1����XW���m���~��mv��,��O%�~f�⽙�G3�>Ӣ���9(��yG ��sx��v
bg��E>�N��ۢ��,K7��넺�%g�?�9g�耆m���.��.=َ݆+ȧ	ߪ���a׏���P'\W�z�]�[��kլ�L"��3OO����x����"�m��Ü�ʣ�"J��
�� �B�N,�%�.��	U��}���*��o���`�Ƨ^*��(� GZ�0=j�L�*3/�Ģ1;Ye�G�ɯJ�_LEˋ�q���-��"
/�R�����9}��`���Z�S���N��NPL腎��4�ټ��0�>P�B+_Ʌ���O
�|$�u�` �CǾ$�{D*l�CA�&��y���GQ�KV�t�P�h6(����]6໖Z*�����k|;n��zR֦ݛ ֵ���I�[ ��K��Qqy,��(���۲;	@m(z�u��&҇�U.�P/Ŭ���}� ���}��y5�xX�N�dq�ck̶o� i��:��$L\��}��ix�-�&l�	!Y3�@ϫ+��%.g�!�A�x\u�k����n�����.��A�!�t�Oۊr��'M���N�~/Wp��=�v�@�s�������>��|xx�p^Ey      �      x��][w�H�~V�
=�J�+�ҭ�[aa$�A(���z)1;�q�����ޥB����Z=��$l�|�˷�L����j����I>\D�j���ڿ����v=O�r/�4L�~�ق�"m�-GI�l��Z\��Ui�!<�����x���
�4��_���o3��� ��3}��7Wz�߯����������m�}_o�n6_5��̴V�,s`��ݿ�O��g˞�CX�z|8]�6�W=OMj�e�L['t@́���l�h�η�ܯ�\盛]�x��,S\�/��2��
E&A����홮�-��#_q=�f|���x��x2��)�~C>� τk𽫐#l�G��<�%���OhAtfS}�O==�1������v�e}��U��v �'�Q$�4�4���~x{`Q�%�9���u�OG���s��'�y��Q8Z����	_F鼺{��ɰ"�:j?m7�� :��K)s{��J�q"U�H�E�%O�Y�/y2�	�q"����"���y��tœq�MGI0��6Q���o�w�������{�1mG�w���zp����({�۟�&��9#]��'P,�p���~p��7(�.�epz���u2y�Xˤ���y��2R�T:>� ��6�����LC4A��A%c�D�n<|���QWj0QH��Ы ��r��L���H�jf/����p>�����4K4��T�=�ِ'M0_#�Tf4K��h
B���&�-���O@DO�O[&xr���$Z��	6�$�v�|���6��U�� 9x�6�.G��=#�'i����t4=/��j��M)��9�faå˅󨲯��H�6уH_���c���_m7���W�p"�K��<Յ;�AlfI��k���7�4x�J)#6 �f�h�<̂%H"����d�E�ã�B��k�
�L�dWZ_�s@��Z&�z�o��g�GA�<��J���WM���p�?S���%O�O"� ��>�Љi9��,��w�9����t�$r��� �������<�$��I�q��;
����@!��fH"�>}�bT�Y}�Vۘ�|�A����<�g�)5�������VO��3��n�������k�fs��<��u�Yo�Ǧ���Ht�G�	�8n�6<�1"�S˴lG��eQ��S˃�	�!�TZ�%�I(�X��O0�l��Ũ��zn�mG��!�+��]/��z4�F	�]T�0�tA-��ͤs`FQ7NU���Y��DSp1!��|���N�Wbj�j���{��n;������B��B�3@�q! ����
KA E�� �eaC�H�V�H��٦EQz~���w$4�	�#Q{�: ���ߵ�?��s8�8�l`�t=iR��!��.\iA��R=IL��p^Ĉ�$�_6Nx�U��??�h��6�|�߄J�2�^��1*I(~�;�S$���F<ۗ�3�z�pW�uB"�X��j�-��ki�O�?/�Z�SP��h|�B��#r�e���#?=�f�Q)B(=G��������t��1A ���RjM*��^P�UVo�W���O�bAC>A�0/���**|���<��pJzz��1T)�k���ʊE�0�� �i�ȷ����@_z�αMI�Bɠ^K3�ml{rL
��@D�}�[Hϴ��Ki��wV+�Pkǃ ~	Q���.��A4����:��p".F�n���`+^\o��u��LjXĲ�����t%�����c��'�����le7�~��GO�1$��n\	�G��G}y²Ã�on���SD@���I�2aYd���1���r�J�����1$�ߦ��n�9ż�D�ޥ�����s�8"��*6$���P�? ��Qӑ�K}�W%�|��\�1���lyj�<Ҧ|52�sPutD������#��h�'|̏{�n$<<}~.�/O�Q9Z@9�'{yݓg2j+2�K<��z*f���i
��9�-���ֻ���:>�L�T �<�B4����>By�������Js�BLe5�
/����C$4�Jۇ�u�<o~L&�
4�zTG�j�	���-~TK#�n�xZ��MOr<]Pe�s�ʟwA��D��n����t�#��1ƍ>�1n�5��}�w�,�y�\���-P'��HY��Tq�&?�T�6����W���3��c�e˷-S�~,
�)�GY�� ��N �0*�߀M�R�A=|�O �[�嘿!��w�G�§$2|Q�q�c�,��T�K��1j4�� �4w3����R9�,���5n�0���s9"R�S�����s���ן=u�X�A���r/�v3Mad*��m��D���C�GPŰ8!�`���~ھ^���gظ�����_=���2�b�K����c�T��oO�\O�7�o�Il�	�]@�8~έ���0U>���/��?�Ԡ6��s�q���#�p�3]Èv��<���Ju 	���qb�~�A��{��*%��=��5��{yL�nB8�a���{h��}_�ESW�@���=����=����u~���u]k��d�y��[[D�agS�2��M_$���x��y�C�$��P�r<)��m�� ��P^�hm!�D��Qt&jCL��#Pc�"
3�� �abM��T[�?�����(-���J+4��z}wpBO�z�ru�:M�H�V��<f�6�_t�Ԓ��w��W_�s��u,�v�iG�� Z��W�|::ư[�J,���
�4F��e��
h�%�o�����3��D�l���E]Sl�ȩJ�%����Ӊ�!��,�!���U�����%pmDey	l����W������^Q�0�����T�kV�k�c�J�5<�do��d�!c.��	�������ܕ�R֩HU�Z?�0���%`�q��|y�=>ܯ�-�0 ��U���7&�;}��p��&�)X@����k۾� ��}̡���X��o2m8J��S/�G_N2��c���QC@-�|�C������@k`�c�
�4 �����W\����}F(Mn�"�mٮ���Xγ�6DD �-���=a/@i�1�Sdg0=�/D#O��i8��fO�d1V�l8��Q ����v��(#|@c|��r�����ṮJ�>c�F~�?��N{�8q98�b1S��Ƿ}-š���F�e6|u����H
j��� ��6:�gđ�g��t�Xv����y�ԈO-}x�����|�-��I�+��&�]~u�8��^�s$-E>*�g�HP�Vڴ���	�NO�K/X�Q�n�?]�}:}��b".)�p�Yn:��u{������˳� �.����BЕ��A�_�EY>�M����fP�Ζ�Ҳs�'���\�
Bz�	���eyױl���QF4�隌!��?�z�Zi�E�Q�)-�
@A�	ؾ�<8l�=E-Y&��]T��(����W���Z�4�#�-�,�=�UD���Ѕ|�	f��L�D)<�=J!HP��ދc1��q������w\,g�D�&��6Y	�K}~�5gS��� *�D�	�Dq�N>F��4���J]&�������e��ؘ8�=�4���H�X޳�xM@��]������F���R�)��;�s�8<-�16���D#p��²\����ŝ>D!�כ�ϵx�j�a(�) �76>e0�8F8��X��r�m�R�Hh��<R� )^�0*e�uHG�O��	Ukusw�����Z���㕱�����w��1����?ߥ�V@J�@�(H�mxGM�ڃ�:�Ӈ� ����0�H�H	[�L&+���l����4��	[�u0P���vs�E#�^̕�7�}�eGj�X�"��{$��������N�ǡ>C�������տ?u��M,���Xr|�|����j.���6Z�?��?�W7���D�U8����f��v49�������:��Q�G����`�A�!er"��lU�=u����ۛ���|�����a�����7��������t^߿V
�E:�nޒ�������B���E�a{̷z��J�mMz�� @  �K,F��%܉�-����51���~��*N���w�i`R�`���̘���4�,�ۢU(Z�~�}�I��X{e���H��g)�G�¥D���Ʃ��e�$��
AY�*���g�Q+:�O�]�B�LM�%#m��,C�hᑚ���|S�v�a�	*�CWsc�'�'X��o��i����츣��Ow������j���E>�:W���bgK�t���cɇ �X�r� �A��-��@�eІ<-aW?�x�S����uY;'�,g@!@'������vJ�?�$/�חc�O�TCU1Y�;_6c#H��q��𻷂��򻻛/�p�?݁⯺����N}1�'���$΂�h���&�-g���MM�A�"���o��y��֪G7	R��YTp����oA[Z�ϥ�`9q���f��f���݀�H8�=��,a���Hg�ۇo߾�� u�b��G�y��g�g��Sv9ͺE�^��C�)��>x��n�J�y?�9�k��'�HF�Z�aS�a �q|�a�\t[�t���oP&_�1�D&u����p�1Mw�p��]S�ΤLA�J}e�t�X�[�_}%Ƙ%u��gC݊���k�.���A��8�$�6��t2�D+����W/v�UY��%�:����f�u0��C�)����jAz�OB6P����Pl�Bcַ��:�m�9fi�e�[�h�͵��P��X�����	��m/R4�˧���j/�Z#�%ʿ� ��;��� ł��n[Gjc�z��,�Qp�vyӋ3�|c�@6���	$DYv �F�S;Џ���N���L��E9��7�௷q�4 H�����7����c����Z��:`K<����'(m}6�RpyL���i
ܻ%���q��n�1�E��Cxx��p���p*�߆��`��sR`,1'�G�	�z:�-��W��`���C�41��T���s�%�s,tf�)�z��m���8��x�nr�<�Ʃ�!FF��Ak����w ރ�*��E����?z�E�/>!m�mY�N��X
`�6�	l4�P���
�3S8]GgzN�!��~7;�aT3��u�9�$�����)�Z`ٲ�c��(��l� �c�{�:KZd��`y���,3�ŨB���T��W��kp������6��_�,��lno�b��C"�v^̏K9fo +��bQ�ZI�伳`�i�\��)*��*���D�IV��*�%&���^��oRL(l�d>����.�ŭmk��{Fd���W44txRc�_���7jS����ǎ�F�>u��o>�Ey�~p����u�1��_K7-��"6�e��짿��+���2"��?Vv�������ۧ���zw�v�yP�.8h�ĝ����%��)��4y�ڂ�a��Sm�ɢ"�ϳ=��f�`�y����j���|�o��3
�g)64�jẂ	,tT
�v��X�� -��YBg�؆<�Ƀ�#����:6��T���[���~�^��.(��ąB*�1��[��e+�����|R���#�=n=�.�
��J��D�"��&D5���B�o�8���p��,f%і�RE�W%�Z�����������g�.S黇�)�y����b/U�`l�w�ה�K�4���Ǫi�����V�j�DD��Z_U���u<��9}�q������c �X#�̓R�Em���E^/F�T�ΊA̓gB?�L�,Qț��S�� G�c�����A��R��xEa.e]5�N���Z���9x��,x�4IG�Ӵ/��"����p�u������g�
ەQ\�8����������_���M1TN�ӷvb����(ea�Q�Ki�;]�>Eދ�C�c��2���~��&�d�T�(KHZ�ki-^s����������Ė璙M<K.���A��1\r�$��=��r�"���<�#fC��
\\�J�v추d����;���Z0���}��%2�T�O�w�;�1��X�Y/?�%;�A�g��V*�]��!�ݳ/Rw�8�>��Tig!�Y`�Kr\���7�G
xs��:��y\F0��h`Q+�x�(�d�<e�Q*�Me��y��>e��X�(����?}{�$�X���gp��0��)x�,�B�
�,.�8��	=�l���׈�ER�W�@��1�ԩWY*l��a	K/ذ���P�X�8�L�A����z�l؛��كMT+ �Q��������i�M@
�E�q���|"^�'�rN���]���u�l �K���g�#>�!{ b��t������~��,��Q�e�q��qS�CE6ەZ�����ae���e���\�Ҕ�I���	h���..�x����cP����^�=m��ɨn�䎣�g�G�S�S^���w&a���ٓF�zxۑMH9ꢋu,���<ƨ<��ֆCP�K ~�~��?�)�b��*ȶ�c�g��>���|,G"��$�<F�^�T��ϡ8�zS�pm�!P�(�$���"�[u?@`2�ATL�e'�t�*| �"�H_�W� �-T[G�K���%�vY��:�i�����;��bO)H��,�H��"]R�sʸ�{���8���ų�NMS���wb��pz�%t�����¿z�.�}�r�)I5,����P�� �:.�H�X�r�8+�C^���0��\6\�L9����,^�a��Y�P�|M�eQ�@���WD�Q��r�h)x�[��3_;I����^r�Ð��.*��&zD�`� 7s<S�a mw�t���݂�s}P�1�la�57!aŵý }��厳�$:��to+��y�G���+�¨G��k��[]9M<e�\�=�=��|��Q\Ԋ�0�
S��24AQ�eT��h1Bq~�@2��"�RI=��9vQu��{yL�������ܳjIO܈�jF�G2�&V���4b�y�o��_F�1{�Yz�gs�Q�o�fE��L]�H�O
���$������!��`G�\Lz/�,��E�� �HxG�pw��"���g2������(r�]2�pͲdj!��͊�_��tH������p,��1�|$F��G�I�YmON��(���S�R���>��D��u�]������L ���Z�;X��b��GS|2�8����:hf�$cS%`���'x��&r��|�LP+o0�7�>�����P?J3�������*Nf��>hA�Ӟ�B�:̚��� �#i�2��d��91-�a!��_q�e}A���F��Q����y��Xޱ�	�Q��1��h#���&���4��B�*�ֳ�s��L�B(��q�d2�[�!
�vl�	��e,"�Zy�8�Ck���C,�c۰k��@E�"6�8V��LMUn��8|_�)������+�c��W%���X��L�a��=:�כ�c��i�����,Mq����T�?�QN�g���	�7s����Rŉ',tȮ��'Du#�FԬRm��)*>i+}ԋ�#�K���:H6�>x11����9����XC���E?F��1�d���U�^�'ѐ���]�:ВL�����L�5�*2��&��1iO1����o�����            x��]�r�6��=y
��ht���9Vٹ:�(�g7�U��5���%�,ov��t�W��9�3T%*�~�����3cό{xn��1d���߹���}����@:�zq	�vW�������3��'����9��������W���5���/��s������w�ʭ�c��Z*�}����w�~}wxy��y�a�����/�s��4�W_�߾>��n��?���q`_�G��pw����c��ˋˋ�����]����O����yy�q��w���H�A��*pѺݗo�;�a|l���_����?��<>��3�'�4O��+��D��fӢw���p�1����զ��z��L��P>�ݷwW�>-f��?��:��K��S�+��/$?�#D�g���ï��c��be ��P�W�c߳��?k��)�u�v
߱��?���������6�.=[�)~J�������o[����Ï�b���\����i�?�����1�������<`����Y��\���-��/4?/^(����>����^��X�RC��V����e"���6�V��k�T��4����B�Y�����F�  :���������d+"_X�A*�0[p���z��\�?�.JK��) $C�#���Sg������Oѥib�ӹ�U��R(�/�A�b1�%�����Ǧ͹�U`��������S��!~���'.���X��h5�Ƕ��P����
N��C(�o\�ng3l���'d$pw����޾ϑ�.K�wg����s����E���q��{�����o��_[��Ҩ�Dcd_��yܥ�?;L�����X�� �c`$vǱ�(?=N����Q�6��1L�q�,�~�?��4�N��X�J�:�����{�*9b{���.���>�,C��:� N������������l:�U��Lo �tn|���I���mkƠ[��f�0cd�P0�����1�<)�Jw.-����������\5�>��tN���g�ʦh�tl�8U���IBʝ�T��[�l�u2+��&�J���s�M�X6���S��Ջ�ӊ�K�����oB>��������ǻ� 
�P%��.{�>�f�-mB9`��A	�����t�y`�/�'��j�]'[ �!)|�dz ��W�y��|O����W�k-b�����x��:jX�!���90}��`�R�ǔZ�%ޘ^�փJB��RV�,!�r�s
�1�>����G!q��=�cO_��Oҿ�E��������k����5�`�]��/�|�e��ѣ��{6ga��Xc��R��p,6P�`ZApM9HG��:6Kx��WJ8�k�U,�
	�mO�7-��11��XZr��f�����!)� ��7�l,�qy�H��E������F�M/�~�
|���u<�0��O"��&L4����ܛ�<i�P)A3 �{�'
��xdj��x�=�`�"�eU:(���Q�7�I��	�FL�/�]K��EVض��a���<}Cݵ2�e�D!��F��]4S���0a)�~=�)�����a�t:zm�5!�ѳ�0U@Î��n�EÇe�/:J�w�a��g�6�o���+te�ny����IC�a�M4����A&���*o�K�������>"����G��`T���џxĞ)ɺ��^ܧA�5� ��Zn8>�m<��=K����z��F� �Z4Lج�/l�g���퇻;�������>0���uVe��� S�X���a?랞K]&$:��'F��|�ݣ� �� j
���, ��cő�#�)�0�!@[h�b����*�8�֎��9BE�ײ]�n�2�M�oU��K����UA$�*�@l���=s����o�������f��?�FX꭯��۔�ܔm�@����rpP�:��r�9�O�!�9p�L(�)�b�\R-�§�{
�l&I$�щ����ӯxxK�i�L��e��icM�i̜�ʾr�h� ?�眭g�o��1H�6<H��͛��$�#���vO.���E?���F�dtX�)�����'�)+��_��<���~��:����pu&_�a�v?��2W"�:���#�<��AV�ޅ��7|��pq&wd��������Օ��&%8���՝�.�ܾ�}?F�%�緷ok�l��"�BL:����ئ�R'ɨ�'�����*�m0����~S_3J!j�B�#���+ذ}4����fY\9�[(�έ�KM,8WII��1{��e;%$�9��:*���̙ϼ�F��[�s�0�c&N<E�"P�U	�b��Ii<)�&*�7ϊU�Js�"d a<K���,���~*e�#6LK#dݤ��]Ґ�Èn�.�2r!�}��EQy���0���Tp���e��q�
�t��F^�~7�L��$�X!�j���xaS�˷.$"k�G��zUy�G�h� ��ro��HI֡�`m�:�YR�j�粤5��{�\�D\���q�*�U\�q�p����\ܠ��}����;vN:�4{)/�=ۄY�ӭaA�#����0�Ȯi�4C<�O�r��ț�[�B�?Z`mn�yTQ�D��ց(%q�#���e3�i�N��,����f�\E���A�3�+S�ص��yT9��0�E���������Z��iހ��ê�u�4�O�a��S�o���}�O2���x�!��2l�'!� �ݖGN6v5��bTe^|���4$`LB*��f8�$��$�$A�yT�^���ԃ�!1(��!�`R!'�ċ_�}[�0^���v��J���>��|���,��/�������F���-�@{ҫ1�ޝf\Qi\=�a��L��<p%(q�i�|������۱���G����JT�Dɻ�TA\�����F* �,�.����F��1�L��Y�O��3kV������O�*�5�g�dU�5�	EIC%�%�����IU�<�.�z�����>׹�G�Ga_K���Ӕ��U��~~���z�!�IC>��U��-��R6LP0CB�:�Ԧ���ǳҩ�	�0
��Z��ON����y)+�����p
N�h�}�X��c|Q6n"�m^q|�3�g6�6j�r��UM��/��ӀZpQthS*�"+,�[�J،N���u(r��ƣ��f��{,��H��B��x�z*�LB�%R��|���fw!�^�l��l���#/L7�(����j>�pSB<+1"�r�- �'Tv�0�u�X��V�z>q��IO�q=�rQGُ������$^AF��]{�����ddO����ea�>O�pz�&$MM4c�$�Ɓ�[�����}B��4�8�%��<B��rw�T�␾���w� LO�b�[B�B֤���� \\���?��"�8p�D��Y9i�}���*.(��Hs*9L�Y�Z�m�F\ɯ'�,��m�cUt6���@o��I���9@y9�H�j��]e�	�bW�ʪ�5�73�mwS�g���9��Nl.g�ejٖk��(S5�~�I�a�B�&l _�k���[���?�Ֆ4w���&eC^�A�����`�$ ��DW%��o�bk!�y��ݙ(e�S0�ǡ�>p�;��eAݲM�n�]>�Et�F^C.�����D��娢$k��Δ9�ğ?'ڵ�h���d	:b�}f�o�P:�}ѭv��0�w-��Tm�m&�R�~��	y$��o!�ъKM͋��ˉ�/P,@���ή]B��q��TE��Ů��T�v�����|��_n��0ic��UB�޹|R�?�a&wln5�A�y�Ty�D|���*gLD�=�S��/�9D�J�
q}�.VH~�$�UD4����d�\xrʅG䀫�l��E�x��,wkXN�H�/U�=�@�'��ؠ��ӕ�g-��h�3H���M�C�5�o��f��#�r�����
�g�݀|�I�IE!�1ǆjlf����M�1�dh'�N����>ڕ�o`Li���� �T(��_���*�aI��?|�a��+��Q���
Ħ˪�(y� �	  �G����E[̑Tj����w��ވ��Z��T�W��~DB2�"
�ފ�?���7��?5/?!��Tt���EL�H�_�|5��YDb�Vk�#�*J�q��J*�����/l�_t����I��Z����@���4�t�K6B�cA1����;�EB��\�pww�9�`rl$T�nC/
E�0�OD��pr���Y�a3��Q�=5�����+�̸\n�+�H����2��,�b+P��uf+�`�6�]s�Q��h���,?�,�8��T����k�j�K��QԸ�(}0�h�8𠐏>�8�1���m���v�i�C�������W6����?J��$��Ӄ~�k��s�ݥ�G�)����Eg�+|i>!����J?d�z���1~���P�0�#�����J+����-}\d�_t;U)$ۍy��M1/W f�G-�s�����4��rw��7F�!�q�ckҢ���z���D�`\}�c ���*Ws��1,����ص�Ͽ~��&��϶=���X��ת�_��	.��� �jC�8&���[V�h?k�%וc�� �ǆTN+@%��Tt�FX�_�صl��46��{.V�R ?�z��"�؝y�WQl��l�?2�i_�t�. �`^l��� 1�7��5`���춛G��v����5
k"R��\��ژ�O�a��K3�A�R����<���7�v)sMҎ�(z �Ц*>\��p�0Ϟ��d���N0��3�r��%)��<����׼`,w��u���Q݁��]�7qI��$���-�I�ƥ?�%�Ԛ�e󶹦��AOImlk����JA�20��j����?��5�	%[�#Q^+�䛞�pA�����M'b0�����l�`�z^�	�u�?�J.�K��rQ�Q��m�+�8�*��1�c�N�ra}�9�7�.N�%Z��Z66t���U��^G��i�2ದ��hH
v���Kb [�*.�:�������	Y��m� 4��	�E�"�=�ՑH�$��W�ZfŎ���$������@��\8 ���}��$&K���T����c֘���s�{��)�,Kg���z�U�7���N��k"���|��c����Y}�2�17(ӓ�Y��o&�����!��˷����7��?S.�|.���ֽ)@�p{C�k_���IR�)'I�I���i��[��9���Q��@�1�\"�:j_#3��J��/2F=D���QAl㆔��a޺b��U^b��ŋg�NP��β7%Z�-�P��"~��)������V|�P|������)Ġr�b��z��=w��ӹAj�F�D$�f�������`ͪ�:�0s@ GV���
C�s��
S��Of�3W��p�(z�v��n��'��ܘ�Y�vy�� ���	��t���Qn3J�lO6�-,�tLÔ>�U�>{1�0�0��q�)N�D/�Y�����;�r�0*5�F��B>p����J	����P�,�������)� �F����Z~�R�eKEi�����bPE�.'ך*ofI|����$:O����I!�%�=���.�j�1#� $����LD�K�DB�g��	�%���敖�H�A�![Ϟ����:�^*#T��7;q�:m�����W�*�۝ �v�����Awq��ԏ�׏?͎����{-	�HK$T�w=���h����%	�E�_}o%V����mM"�$̢8EU�]��^��ՙ�+$�/f�$NQ��3���������5MA�q����1n����'F7��p�l�V�"y(��0�ݰ_��w��:�}��mJIf4� }px�h���ϭ+�˽x{�i)��So�8��>"�_P�l�@�C��H��t��^�P��0��7)@���e�3J+<<j��
��B����a�%��k�G������2��X�M%�Q�3�c�4)-%��v��b��n�J���" n���-L��K��,���fY��2��E�}�+�2��E�:+],bK�N=aYT�e�H�^�I\\߼Q�Dߌ�C�b��~��yOy��K��M���MI�zo�Do�<�U��Q�vtN�ae.�b�H~IjT��f�h7�('r���9�H��c������ys��\���49+RNf�-�X��0�#�[ˠ�<�)�q�+7䍏6�'������2)q�N�u��`(�䌋l%��{�.��A>���������	V�p�g����ʢ���v�YD��gXDɌQzy�g��Di�(�|��9PB�2�N���6������4�}�8F)g8�P��)oM�6jK���´L1Q$;hRU�rY��Lܖ��A��a���#ag�Mޙ�-=8rS�<�`O��29�2��3��Ә"����sG����d܇Xg��`s�w�R(��<��J�"��3Q[�{~һR5�������M�q;            x������ � �         �   x�e�Q�0D��S�	����g�L��]�Ʋ%K!r{������f�E�IOaF�T�ғd�>a�ohh7����a$u�h.J�3�̉T����a�,cv�H�mR27}�*y♂k5�%|��:I���^�L*aL�z��ߖ��r���i�JK���xsF����>	-ߎ��q�3o�͑�콲־ Ƀt8         ,   x�3�tK,�U�MM�H��,N,����2��J�rS22�b���� ��         5   x�3��/-JMNU0�2������lc.8ۄ��6�2��͸��ls�=... �{�         �   x�]�K
�0���=��
�7m�ґ�%��B��~Ӂ���|p�����~������F�3�l}�P/����p,�L� �G/j�P� �p`b��)���-&?����嫎4�%Dէ��!��q?� hhQj         /   x��J�I��L���􂱸��r�sS�3���Ē��<N7_�=... �x�         3   x�3�I�PHK-I�PH+��U�,I͍/(�LN��M,P(IL�I����� E�         �  x����r�HE�ֿ�����nJ$�O�
��Ğ��1my£����z`��O~��! o�P	N7��e4V��Z�r�W�nP�qP��ZU�`x���p*��t���t9��kU]NZ�_N��_���G_�� ��{����p�f��[�i��n:ےG7i�{?���i�N�3�7]�,�;]�굯=Vys��/~��x��?S��_����[-|�k���S�uwy��b���_=���w���@�,>�z����ɯ�^o�~�����8���8N����6]ϪW�i|���5�؅޵��mһ��Ե���]��͵���u��]�������-��3�m�ѽ��:��ݲ�/������*��7X�j;t?:���͏���o�W.���B�{*�"�S��O���'Zs߁���\�ݑ�E�'0�������Yt�c���\�ޓ���	M����ԝ��K.?���}�Ħ�V��ԍ���,�ܪ��������'4��CO7��m�m	+HXI�*6$a#r3�e�n�|=n���]oHг���A��ps���Y4���Uи
�WA+`b;��[�E��h͂�YP4�fA�,(�E���,84�]áYph��f��Yph���B�f�@�P�4h
4���B�f�@�P�Y(�,�hJ4%�t�f�D�P�Y(�,�h*4��
�B�f�B�P�[]h*4��
���������������E�0D�0D�0B�0B�0B�0B�0B�0B�0B�0b%����1��1��1��1��1��1��1��1��1��1���m�ڶ���o��m�����s��m���V�l*`	[hXC�Ѱ��U4뢅����hau��>ZX!-��VI뤅���Zia���^ZX1-��VM릅����ia���~ZXA-��VQ먅���Zja5���ZXQ-��VU명����jau���ZXa-��VY묅���Zka����ZXq-��V]뮅����ka����ZX�-��Va밅���Zla5��[X�-��Ve벅����lau��>[X�-��Vi봅���Zma���^[X�-��Vm붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶ�s��5=iͦ������ikx�����Y����V�m+붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶc��c��c��c��c�������b7��n��톿������?b���!ѫ|C�W��D��ip��^xC����D{b(u�1��Od#��h�2�RƢq�X4R��*c�he,��E#֋�Ǔr�>��h�n?}����D��������h	L��&�Ym+����X�hC�P8I�_<f���_ցZ�}�3�B�*ܐnI�
7�@��R�)P�BM�{˦3cъ�X�d3�ٌE�6cѪ�X�l3֨n�Fۋzc�q�rƮ�{\���n��5�k{z\������5�k�z\������ή?߇3��x����l�\�?d.�2�������E�ä���d͆"B�DD(�E��h"MA���P��#Ԧ��[c��d�]�&*���_�������i�%0�~�h;	L��&�L�%���V�IbI����0����Ʃ{�m3ci���?Q�HT�-�D����&*�Vm�9hk�X�t��5cm�Ŷ،�I�U����Q��6)c�	��"���D4[W"�+Mԕ���JDst%����\�hpnn>5�-��s�ފnH>9�-����zֳm�Zxxc'Q��LT�@��DE�4Q�JMT�Xզ^ц�S�6���I��3�&_�M cm��2�&c�M��_=����DE�6QњMT�d��DE6Qm��)��7���I{S�X�|�7���7��2�PxO�������,�Px/�������&J�o�7M0QMBE��70Q�\m7��/�]�De�V��W+R٫�6W�m�����Hea���0��m�	k�.�>���ʅP�ku�hC�qі��M��E�B��6�m=.���@�C�>1���O=����Ch�����>�(�����N���;���(;C��g� o��SCʎ(;/��P���Bʎ	(;#�6�ώF�I��Q�H5I<��&��Gt#�}H\�i�ၶe7��{Pv�!@ٝ� e7Ԥ��m� ewb��j�)x�5R��vJ+�+���@���>����@�;�Hx���~Nq��ec��_&P���~�3@ُ(��� ��-�~�[���o����b�"���@bO��ц���������<��t�T���He_܏T���He_ߏT��He_�T6
���yK����ls�\��g.��3����6��e�y�Z�/�	�^.�w���i���L����(�V����(�F����(�6��3����ⷉ�I����������Ulv����͝���D�C�Md0<:����D/ � E�l�=�va�>z��G6�<g�h�(0�5ٍ�.�nLvEvc���⺳˱�]�ݘ�b,�<�P�$�c�j�%xd9@-�D�+��n��5i�����'.<�����z����kU��z��_�H\�;9�"2�*q��"2�*sp�����v:˞߄e�n��[��%,����f	�6��e{Y���2��r�o��=��o�� ̳��6O�	X�X�5�����Sw�O�%.�A�%?��;Zx�/q�Y�ąg�����g�2ج�X�]���h���7`�l�P�^�b�Pm�h$�I�*zHT����Z�`��@+��uvZ��@��p���]��]�wuW��(�T�l*J6%���MEɦ�dSQ��(�TTl**6���MEŦ��R�'����C�㏿��o�~����x�<�^O��㋔��x��^ܡ8U��`p��e�����T�z>����4��Rɡ<N/�����o�?o8 }�x������������������÷�~;��n���������?Ƌ3            x��|�rI��3�+���}�S%H	� y�T]���X�E�JT�������̤D�-++�Bf�p�r���>��������`������'BO������a�������,<��X����q���%݅��8����j���|5�Ь/���Y�򱹸���^O��#�l�,�hlQ�2/����PK�q��dXI6����Eo��ZW���{;ZO��|��w���8&�	q��D��0����<����6<=�����ۧ������R��>�g%=}yx�vo>]��/6���|9��ւ1ݙ:_�x�^#�N��EХ&gj�9Ƌ�:[��O6Z墮Uʠ��)!�T&a�����QS��Ty0U�a&n�1<ގ�?¿ß���ݿ���x~_����szz~(�������ϻ�00u}1��Y���_W�z�ڞn���z{ss5��~9_4�+�YY]2���K�&k����&8�X#,㉱ wK�`�2Q[F��6���LO����Q���f��-;a�]����ͯ��r�l��ѯ���yܜϖ�6�\��\�3:UL��)��[�D�J��u�)";F��͓��Y���xF�T��M�`����N�G.���_v���l�����)_��:!�*B*�T+&i�x�5�D�H,.������A%E���	�b"�D�����M�w��D�.�f��؎/��f5FA]4��������f�����W��|3;�Dw�\5�_�[�@z�TvA��L���{#��ffEME�ʂw�9#�B�i.�ͪ�D�YVO���Gͳ���<iO$�c9��.?4��>�xq}�,7����y<]]o.P!F��:ZN�8��]rQ�p���'��ǳ�%9�[�Nko)T��j�*�(�V��0
e'E�/��`�;X��	�F�������3�=����]-NO��z}}:��փ���I��.��
6�g��B��m!V�K)RlҬV3���;�T�VU����I��`��v��_	�cG���|�;��!�G�p��!�������}�>�U��E��s����D��K��a�_4�t{v1o���+�3�U�P� fFפS�5��לK�j|B��*�%-��VQ}���L�С£f��r�!5�<�mW-^mƳf~:�
��-�/���������S�� �ח��|}�j~�Znf��ְ���֢ڬ�g5΂��g粌I�o�ʎ�|���b9�$p��4
�A�7�w�u,����`ʹ��g�ב�Us�,"��W�f9[�N�7���nV���j<n�g��������������߇{�{Ń'��K)IT0�&Lu�ho�Ij%K�ɚKα��O
�Rt 2
Z�w�.P� e�aB�fo$$+Rk#b�0�S�V�l�ʚ�u�A��!x

Q��Z�����X	��xER��(�םS�³�-����������=3��(#p���E�BQ
��k�)Ĭ�[]��Jɑ�:���� �3��ZM�;Ҳ#"�c"D��}���f_{Ə�3HX�T���|SmNW�f�\�IIFC�fPV"�֡ZZQYKU��E�b�)�K΢r���s)��{��(��wx��!�#"B�H9�f|�>�\�>��܇O�TA���_w���uP.�KP�j�
ȿ���v��[�� <S�L�L�K�(�9�\�PVl�`��UoB2��*!�=eF=�M�;��1n��+�=ͮ� .���Us1?螞#�׽+V��+�"����Lc��Dm+�9��Gb
�l�h�Y��+��"�8�6AƂ����t̅۾�z�ڞ�*��h2�nk�w^�[�]���v�޴�� Ȩ��S"r*"�d6�L�R9�L�&�K7�G�X-L�D(-��WV�G���c/��/Z�Hp��H0m� 7�f�l旭e������1�=��/��gⱏ�J[@^�m��*kVk�#���ÿ���<WB��)ܳrU�u�X1P:�Ù��=n����ԋM3��q��0�\���;p�CϢ �3VE��$�
Dsc�.'.l��O(����
�&�*h�d}eN���qi�Q�Q�
�o��쬺j./v	������-��=Ze��raa�c"�E* :���U�y))i3<��Q �d���C��1�#6�#6B��R��t�>�7�Es� `W���zq	37�Ӌek�z��m~:[���_o�7W�󛞱�!Z��q��_�,g	��W��
����F"�#HyVI�!x�mh:��T'��p�6����-�����|�j	D�l�:o�/-����C�vx��m�w�����s@�-ȍ���5*	�B���dv�M �F���^2o4)���f�A<�%���w��:�#:�#8��F���@���0^��/_F7�>݆�ϟ��e�_�w=��/��of���mE�*�DsM��B�\��lK4�g�� }5ӅW�58"��y����Q�D2�^r��l�LWT��A@���_�s�2u���D��t1NDkq����4�d1��x���H1���y��"0wj⏣������U ��ҁcl�p+L�2�@\�>B\��UP���B'H�p$�5���W��P��NT�P�$<n\�uD�M�O �r4{ >���^f�?�ۀ}�~|q�dks
%���: ����9؜�>]TrLA3z�7��r���8ծpf� I'gɩ��yA�5%:�#:��,1�h��{��l|Qn�C� ��3���{ �f1[_,f�SL�#���@��)W<�	���Z!T!j���S�*{�d�ZW���	"��\V�� �� 	w����N���aգA;����_7À�_�]���m���.CP	�*����b|�^�.�����e��F������/*�xsWt�Gt�G��jwL�=(A����q#g����"
/�ӾM�.ܛ>�A��Q\����d���Y22��4GJ"p�<�K,��e�����,�]M�u�[�5�5R��S7�<|P���W����u��Q���anR�i��gؗL0Jp��I�3���'�S��&��c�,\D�y��9�[X�Av|H�~��|輁���.���Sʶ�-��yy��9o֛�z��_�l3(�I��y`@�S�8��+�s
���Aܑ�Z1�va�O."��TT��<3eG�d���I6�����n��Es	+�s���f=��o�粶��Rs�Ί��}�$T�W8�41�ʣo�>8j� ��ly��bb4������d�Gת��m����Z�7�Ж����������$��c~� e���9g�ʒ��
Ӏ�GU��.�r�e�1#3O��=*�~D�8^ydGr�ꛩ5"�ͦ��T����_� ,�Z ���/K���.���;-�M^3j��+n�J�+4�j�uU����I��Ԏ���a'��;7��a|
k2�F���p��<\��<ܗ���!"�t�E7��fg�_��	B�NP�6�� �XB�@�q�JUZZs&���[`�ѸbtH�������: �����5�w=�T����Mҷno���[�,����2J�/�G��4�%0ҹ���ӍA���,BB�_R}��Z7�#@��j�����|���~�Y�u��k�N�w�wW{BS�uV2�,H\��Iͫ�9r�a7��%�h��٤,��û)����n��b�ꨖ-5X�.���e�!����^��.{ �r-5�`�qJFT������ k�1�*Xh`E�<��vM`��;�@ǁ�E��h� ��duw_ze���o������g�)��s�D��C��+�:�^I��Px�J{W#HC���}_S[���Wձ ձ �N��hR%gH�������{mĤB/��1��Vkk�<'��䡥��AuU$x��Um ˀ��C�%��Hy`x-�P��mR�o��q���e�ς�]��r��|?h������zKm���d�R�O���%NmI`y0:��W�0��FKYLD���/;Z�:Z$5ű����K�]B>^�[7�wwk�o1�^m�mM��l!���e�� �J����%C�dϰ$��*z����Pf�cHJ    �W�@A���`eِD^��~} s].��E�Է�������*�)���c�� pS[͢O"F�^ËQ�
�d2���8J�7��+�4�v9����,��/�H=��v���2O� ah����t�{7r�FD�(��br3�ëv�X��>��(/�0ź���m�<e��2K��mt�n P��:���^.�wtUǝTǝd�s{���]�B�^#�Dmq�ڼ~����޵oD��\X+"1�"ti0U�"j��,,B�Ii����R���:Ǔ6��'¹�I��I��z���[������.���jM�������k��'���"X_�R:����k�<M�ZF]|WS��h���������=g͜�����nE��M�-�4#H��ݿ~�^]K/u�Wd���l�h>�E�WEe���3[b�oa��BZ�9-^��4͒i� Ŏ뷣�j��6��q�܎.��.1~�h}�lN}��|���\�.QR.P�a����+BHM����~�Vގ�R��$�}6@	��d$1�pEa�^����/D�P\1�&�D�v4I�ZE��GͿ�M@ڪ����ݭ���
��Y��9X�6�u�f���S��ly�̲!�L6��B��ķ��d|�"Ի�@>yǒ��(�f��º�|l�������rz���D-3�����d����sm�.4eg���e�j��LB�xZ̎9��^>�"�cAWwtH�萣�1v�o����������1c����OC�}h����Q5�I`D,%ZZ)S�E+���B�Vyz ��E��3Q�6(Y����#�A�1��Q"-�M>Am����k�jMލ�]N.'o�W��ir�\�V�f{���U�	���)P���U%W</�`�E�ʄ@	Fuڍ��W����٨;�;��	��1|�{��CO���H�ȼ����i@m_u�@���/7�Բ�
C�
%���p���`>B��Sf��S5�i��҂�;�t�wt�w��Q�hAU�8��ټ�VC�^�/�6��.���͂n�'�k���@K_Y(�J�`4:+��N�j�s0�2����̌^>�V�����**0n�Fg�������t�n��BP'4t��ߗ��i�j�D�5�lQ�*c*��%KNV��"�`5�1|F��%��é�~ܸ��hӹ̞hE����]�ݥ�n���ǹ7��00?�N�[�>��H�I�\���P�08gbD�Vq�$DW����6'X{Dq	�U�r�?��#5�v�S'���}5�-��4n�k���w��5�r��׌�%g�^4��Xr"2�@]����Z�`m׎���/a?n]�a��[	�G��Y�w���棛��g�!��L���}p�\��d䬲*������ʊS�-���?���en`r�"v�U�Qc]�#4;�}���̩d��A|eJ��a4]�_��u�.f��N7$5�ۂ�i��#>�aRj�1�CH	�7K,CZh��|�����G�GM4w1���<N�f�͸UJ����E�auy�_w���
�YJ�k�
"/M��L:�ͳ���*M�B 6��%���/�����L�^�,�'���,iK�A�.�׮��]�ϛ��>��ݧ)9����,��fV	`��	�dZX.�w�D�
�όͱj��@2ZO?^TLGS�8���hR�||�ܐ��:�󼽠��.��Z^HƋ�QW��1M���I"�*L�9Ŋtӵ&c6�v�a�}�yW1�K<E��G����[E��k������o>�`�%ŭ�Y����U�do�ƃL�Ql��N��B]��$g::�B��ʗ%�[��#0�F����#5��t���e3��!�W3zu���}f�Ȅ�OL�v�A�@�2hY�Ƅ�๨�&0e�#+J�)R�#T�ľ��8�|�k��غ�Ș���vD�h4�VqS//�����?ot��h'��9�*�� ��0Π�#R�х�5�H�Α�B
n�a�M*9�ǭ���2},d������,s��m.vC��+�������P=��2I��l���@(=�����\5O�	e�Q1Р/��ʠ�5�8�V*�O�ֱc�Ě�v����lZ��><� ��]}� �*�D O[�*,P*C���QB�RF_4��.PF�ތW,J�~¸�Ę��$�}W��	~v=n�]��#47�m�W�����u{.�JaN�ꐅ�:Y.�R�� �#}�e.���8(�R�\�T�}�n�&ށ��1���DR�i7��b!�����|h֋��c�}���e���Cq�Ft@��E��d�S��v�f`!�Oe;�bY�k(GP�]Q$�˸�����i׫��p�wu�5��X��D�Ҭ��!^�q�0�� ?J�l��M:��0��q=cQ2�q;c�+�'G��x܌o �WW�r��.��_���l=nC򛘜�W͇��!��v�4� Ȫ��RTM��p)�ˢ���!a!x�I���#&"�4�߄F��`�3�8؎�؎�p{�h���ysլ7���Y��G���U����Ap��&
X�2����;ZXBq��ZB��P4��)~����UEo�5�H��z�;;Zc;Z�5|����/Ow��nC҂֏�}}_�Q��_>Є:����ܷ(m�?N�mG\lG\4�6'w�F=�Ooǫ/�Om*Αj���ݟ�v��[pi��_��[�[r�^�V�aA8�)�)��D3V��e��8����FUҀ����q��,�ﺻ��f�n��v�Y��b�����-�;՛5K�c%?!#�(N���`@A�w���,�A�Z�+w_���H�ʠ���>ιm�^��[I�R�oE۪>����n��������`�����d,X&xZMܡ�$MK��O���a��Q� (����?6��w�T=�x�J�+|zI����6�����֪����RK�.�{f���I��Bc4;!�h'K
.��,�F�J[x�� �}Ƞ��;�#3���YZD��[��~yη���M@i��N��ri���u!eQ���el1/	dT�lY���,s^4�ehG+�!K�H����;>c;>�ڹy?��H�Aۯ����&:�0���х�M�>�1XaH�]�*���vPL&��@{UAo�,���J�T�Ω��'$�樭��9nHs��q���i�z+�������6�M�)-�ެ~�{o����^3.+p�K��^BЂ��Ǫ����$�7$�X9D0�Z�S��������9��7��o��t�wِ
���z�8ލ:�B�-���Y��.���`�]���<�۳����ZE/�F(ɣ�	���׎ A��� � S��Ҋ@O|
/(*?�/5h���t�q��1N�����W����p�؞s�x|I&߇�����_�+����Hh 0Ug��r�&j��r�Z���H�,R, �M��8,:q�|�܎�^#ǜ�d�~�����o4�0@�����;���Ӿ�4[�B�^Y0U$���ZF��`B�Z (�9�`8�e^XP�\��h%�a�q�q+}�'b}���X�؞m��#�P�-���4�e��F��v�1Y�W�����9�^H��u���� �iK!G.V#��j�M

��
����8n��9=�9R!j�ۛfѴ���ѯ׫�v9�������=���kBw�������:G��*Y���c��v:8�h�4^� �H��,����E�#?��9� �V�M7��n.��y3Z��o�N{W>����r���$�p�T���[ɐY@�h�97�k���X�!�X�u��/:�b�;(��(���4D|{ґ4[=�����]�5+@����j&�r��;o'�ufp��cBPBRTi26s��&#� eC(^+�����6�?�oUZ"��������X��4k� {{�p�-��4F%��0���s� �c�@��d�O`�\����א�JB���҂��GE�h��I��po��Z������ip��u8��nϲ ��`<��^]5g������o�'x�T�i� >   �P���Sx��GǤ	�\'������9'������DHp�����F��:Z�;<>��i�׿�����^�s����������n@a\�A'X��bt�C)�ɀ(�
�Gg48�������\q�ei=0At�ln�ȏ-ꨍ�}��6��������O����t@Ut(��?¥�eM}zZd���pU<;0�C�'ǩ5��Dx��*����s�����
��w��c7�c7�D0d���z��Y�]̖���z5�}v�(� ._/�ME�|m�V�c��:@����'���?���]x��RQxhi�ȭ��[:�C��b�Rǋ��،�،�tΓM�}����z0�߇pOC�W������Jaю����C��h��P�cEH���T�Pe!��cC�4��N(4��+��,�X�v+�q2�;2�;2#5�lwt�~Ǫ�^]���Oo"��s�]��t��5�T�I��v�*�J)��cP���B���i���>���@�&�l�v�Q�:�{�4��qj����������xAÉoEF����T}͘Tn�4��������U:�Zh����h��.EF/j���;�}�]��wt�wt��Atf�rz�?���~�͏�//g�F�_AdB��l�H��"0jh	QK�i�]�"�T���l"'��9�v1��i��}Gk|Kk����DT+I��|��V�o����w����Me �W29�y�5j�V�&��9����I&����	�L�[��p:�q��a�4��3�LCj���0��M��c4i�{�mV�f�����9��{rB�L֗�bJ�z�S�;	��i���$q�v�Ҏ9��vzl�<�V:�53�AÏ[�;�,�������C�c|�����n�1n�o�z���2iW�@̾@�B,9Uc�I{�Ba!z�5LM�"%i�#��76	����`�TեN.��^�����O]lJ���vC�I��*_h�_y����,m/T�+� 9��
Nc'<	Ν���X
A(�x �CJZN���T�+��Ov�8G�C��P�tb�����鷯|32K�p?�AE���i"�=0�E� 2r�V�)~����1:Z�6�������}�I@���,�%�=����>J�:��7_�]�_�|���
'�7��P!@?�k�\!Zkb
R 2Ҭ>/<���FQa,U[h�-�ތ��Կ>n�<�%��l�h���6�b������\���W�7�z_=Ϫ<�^n���/������S�f��,������)I�\c�����4moy�$(�,�YU�!���S���`p�0u0Lu���Z���(Վ���YI�]_U����A��5�f�#mm/+�ey�0�h�� ��8SYzٗ��
V��a�>X��iM���v����x���r�ž>��8jwO��?>d����qB7��WL2K'�*�� 6�,5���h�B����j��r35Ǜ�;��`yW5���vՖQ��ܦ!���p�k��-�4W����R���RڃK�5��!%��![��\@i_��5@���=ͽ�}��m1j:X��*�������_����o�x�g     