PGDMP     	    &    
        	    y            oaic    13.2    13.3 <              0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
       public          postgres    false    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    206    206    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205            �            1259    28697    customer_id_increment    SEQUENCE     ~   CREATE SEQUENCE public.customer_id_increment
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
       public         heap    postgres    false            �            1259    28742    MRRViews    VIEW     _  CREATE VIEW public."MRRViews" AS
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
     JOIN public."DivisionMaster" d ON (((d."DivisionID")::text = (c."DivisionID")::text)));
    DROP VIEW public."MRRViews";
       public          postgres    false    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    213    217    217    217    217    217    217    217    217    217    217    217    217    217    217    217    217    217    217    206    206    207    207    207    207    207    207    207    207    207    207    207    207            �            1259    28747    id_increment    SEQUENCE     u   CREATE SEQUENCE public.id_increment
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
       public          postgres    false    218    218    218    218    218    218    218    218    218    286    286    286    286    286    286    286    286    218            �            1259    28767    approval    TABLE     H  CREATE TABLE public.approval (
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
       public          postgres    false    226    223    223    223    223    223    223    223    223    223    223    223    223    223    223    223    223    223    223    223    223    223    223    224    224    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    225    226    227    227    227    227            �            1259    28799    VendorBankAccount    TABLE     j  CREATE TABLE public."VendorBankAccount" (
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
    public          postgres    false    202   E      �          0    28659    CustomerDistrictMapping 
   TABLE DATA           _   COPY public."CustomerDistrictMapping" ("CustomerID", "DistrictID", "InsertedDate") FROM stdin;
    public          postgres    false    204   �      �          0    28665    CustomerInvoiceMaster 
   TABLE DATA           N  COPY public."CustomerInvoiceMaster" ("CustomerInvoiceNo", "MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo", "POType", "FinYear", "DistrictID", "VendorID", "InvoiceAmount", "NoOfOrderDeliver", "DeliveredQuantity", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "CustomerID", "DivisionID", "Implement", "Make", "Model", "HSN", "PackageSize", "PackageUnitOfMeasurement", "PackageQuantity", "ItemQuantity", "TaxRate", "RatePerUnit", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "TotalPurchaseInvoiceValue", "TotalPurchaseTaxableValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "TotalSellCGST", "TotalSellSGST", "TotalSellIGST", "TotalSellInvoiceValue", "TotalSellTaxableValue", "UnitOfMeasurement") FROM stdin;
    public          postgres    false    205   f      �          0    28699    CustomerMaster 
   TABLE DATA           �   COPY public."CustomerMaster" (id, "CustomerID", "LegalCustomerName", "TradeName", "PAN", "BussinessConstitution", "GSTN", "ContactNumber", "EmailID", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    209   c      �          0    28708    CustomerPrincipalPlace 
   TABLE DATA           �   COPY public."CustomerPrincipalPlace" (id, "CustomerID", "PrincipalPlaceID", "Country", "StateCode", "DistrictOrCity", "Pincode", "Address", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    211   �      �          0    28671    DivisionMaster 
   TABLE DATA           H   COPY public."DivisionMaster" ("DivisionID", "DivisionName") FROM stdin;
    public          postgres    false    206   �      �          0    28716    InvoiceMaster 
   TABLE DATA           I  COPY public."InvoiceMaster" ("InvoiceNo", "PONo", "OrderReferenceNo", "WayBillNo", "WayBillDate", "TruckNo", "FinYear", "DistrictID", "VendorID", "Status", "PaymentStatus", "InvoiceAmount", "InvoicePath", "POType", "NoOfOrderInPO", "NoOfOrderDeliver", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "InvoiceDate", "IsReceived", "ReceivedDate", "EngineNumber", "ChassicNumber", "MRRNo", "TotalPurchaseTaxableValue", "TotalPurchaseInvoiceValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "TotalPurchaseIGST", "SupplyQuantity", "SupplyPackageQuantity", "Discount") FROM stdin;
    public          postgres    false    213   �      �          0    28724    ItemPackageMaster 
   TABLE DATA           W  COPY public."ItemPackageMaster" ("DivisionID", "Implement", "Make", "Model", "PackageSize", "UnitOfMeasurement", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    214   �+      �          0    28730    ItemPackageSizeMaster 
   TABLE DATA           D   COPY public."ItemPackageSizeMaster" (id, "PackageSize") FROM stdin;
    public          postgres    false    215   I-      �          0    28735 	   MRRMaster 
   TABLE DATA           '  COPY public."MRRMaster" ("MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo", "FinYear", "ItemQuantity", "VendorID", "DistrictID", "DMID", "AccID", "PaymentStatus", "POType", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "MRRAmount", "NoOfItemReceived", "ReceivedQuantity") FROM stdin;
    public          postgres    false    217   �-      �          0    28749    NonSubsidyPODetails 
   TABLE DATA           )  COPY public."NonSubsidyPODetails" (id, "OrderReferenceNo", "PONo", "DivisionID", "Implement", "Make", "Model", "CustomerID", "OrderReferenceNumber", "UnitOfMeasurement", "HSN", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "ItemQuantity", "ItemQuantitySold", "EngineNumber", "ChassicNumber", "IsDelivered", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsReceived", "IsDeliveredToCustomer") FROM stdin;
    public          postgres    false    220   �0      �          0    28677    POMaster 
   TABLE DATA           �  COPY public."POMaster" ("FinYear", "PONo", "OrderReferenceNo", "CustomerID", "CustomerOrderRefence", "VendorID", "DistrictID", "DMID", "AccID", "DivisionID", "Implement", "Make", "Model", "UnitOfMeasurement", "HSN", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "TotalPurchaseInvoiceValue", "TotalPurchaseTaxableValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "TotalSellCGST", "TotalSellSGST", "TotalSellIGST", "TotalSellInvoiceValue", "TotalSellTaxableValue", "POAmount", "NoOfItemsInPO", "ItemQuantity", "ItemQuantitySold", "EngineNumber", "ChassicNumber", "IsDelivered", "IsReceived", "IsDeliveredToCustomer", "Status", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsApproved", "ApprovalStatus", "ApprovedDate", "ApprovedBy", "IsDeleted", "DeletedDate", "DeletedBy", "IsCancelled", "CancellationStatus", "CancelledDate", "CancelledBy", "POType", "VendorInvoiceNo", "MRRID", "PackageSize", "PackageUnitOfMeasurement", "RatePerUnit", "PackageQuantity", "DeliveredQuantity", "PendingQuantity") FROM stdin;
    public          postgres    false    207   <2      �          0    28759    StateMaster 
   TABLE DATA           A   COPY public."StateMaster" ("StateCode", "StateName") FROM stdin;
    public          postgres    false    222   �C      �          0    28799    VendorBankAccount 
   TABLE DATA           �   COPY public."VendorBankAccount" ("VendorID", "BankAccountID", "AccountNumber", "AccountType", "BankName", "BranchName", "IFSCCode", "BankDocument", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    229   E      �          0    28807    VendorContactPerson 
   TABLE DATA           �   COPY public."VendorContactPerson" ("VendorID", "ContactPersonID", "Name", "FathersName", "MobileNumber", "EmailID", "Designation", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    231   �F      �          0    28815    VendorDistrictMapping 
   TABLE DATA           [   COPY public."VendorDistrictMapping" ("VendorID", "DistrictID", "InsertedDate") FROM stdin;
    public          postgres    false    233   �H      �          0    28821    VendorMaster 
   TABLE DATA           �  COPY public."VendorMaster" ("VendorID", "LegalBussinessName", "TradeName", "PAN", "PANDocument", "BussinessConstitution", "GSTN", "GSTNDocument", "IncorporationDate", "ContactNumber", "EmailID", "ApprovalStatus", "ApplyStatus", "InsertedDate", "InsertedBy", "IsDeleted", "ApproveOrRejectDate", "ApproveOrRejectBy", "WhetherSSIUnit", "WhetherMSME", "SSIUnitRegistrationCertificate", "MSMECertificate", "CoreBussinessActivity", "Password", "Turnover1", "Turnover2", "Turnover3") FROM stdin;
    public          postgres    false    234   =I      �          0    28830    VendorPrincipalPlace 
   TABLE DATA           �   COPY public."VendorPrincipalPlace" ("VendorID", "PrincipalPlaceID", "Country", "StateCode", "DistrictOrCity", "Pincode", "Address", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    235   !N      �          0    28838    VendorServices 
   TABLE DATA           _   COPY public."VendorServices" ("VendorID", "Service", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    237   �O      �          0    28844 
   acc_master 
   TABLE DATA           ~   COPY public.acc_master (acc_name, acc_id, dist_id, dist_name, acc_address, acc_mobile_no, "UpdateOn", "UpdateBy") FROM stdin;
    public          postgres    false    238   fP      �          0    28767    approval 
   TABLE DATA           $  COPY public.approval (sl_no, invoice_no, fin_year, dist_id, dl_id, status, approval_id, indent_no, approval_date, ammount, transaction_id, deduction_amount, pay_now_amount, payment_status, remark, dl_remark, paid_amount, pp_id, pp_status, dm_approved_on, bank_approved_on, items) FROM stdin;
    public          postgres    false    223   �S      �          0    28773    approval_desc 
   TABLE DATA           O   COPY public.approval_desc (approval_id, permit_no, serial, mrr_id) FROM stdin;
    public          postgres    false    224   �Y      �          0    28852    approval_status_desc 
   TABLE DATA           A   COPY public.approval_status_desc (status_id, "desc") FROM stdin;
    public          postgres    false    240   [      �          0    28855 
   components 
   TABLE DATA           C   COPY public.components (comp_id, schema_id, comp_name) FROM stdin;
    public          postgres    false    241   m[      �          0    28858    dept_expenditure_payment_desc 
   TABLE DATA           �   COPY public.dept_expenditure_payment_desc (sl_no, reference_no, transaction_id, source_id, schem_id, comp_id, head_id, subhead_id, head_name, subhead_name, sd_path) FROM stdin;
    public          postgres    false    242   �[      �          0    28866    dist_dealer_mapping 
   TABLE DATA           G   COPY public.dist_dealer_mapping (fin_year, dl_id, dist_id) FROM stdin;
    public          postgres    false    245   /_      �          0    28869    dist_master 
   TABLE DATA           E   COPY public.dist_master (dist_id, dist_name, "DistCode") FROM stdin;
    public          postgres    false    246   �_      �          0    28875    dl_item_map 
   TABLE DATA           N   COPY public.dl_item_map (fin_year, dl_id, implement, make, model) FROM stdin;
    public          postgres    false    247   �`      �          0    28878    dl_item_map_1_old 
   TABLE DATA           ^   COPY public.dl_item_map_1_old (fin_year, dl_id, implement, make, model, model_id) FROM stdin;
    public          postgres    false    248   {a      �          0    28881 	   dl_master 
   TABLE DATA             COPY public.dl_master (dl_id, dl_name, bank_name, dl_ac_no, dl_mobile_no, dl_email, dl_address, add_date, modify_date, dl_ifsc_code, "LegalBussinessName", "TradeName", "PAN", "PANDocument", "BussinessConstitution", "GSTN", "GSTNDocument", "IncorporationDate", "ContactNumber", "EmailID", "Password", "ApprovalStatus", "InsertedDate", "InsertedBy", "IsDeleted", "ApproveOrRejectDate", "ApproveOrRejectBy", "WhetherSSIUnit", "WhetherMSME", "SSIUnitRegistrationCertificate", "MSMECertificate", "CoreBussinessActivity") FROM stdin;
    public          postgres    false    249   ��      �          0    28887    dl_master_old 
   TABLE DATA           �   COPY public.dl_master_old (dl_id, dl_name, bank_name, dl_ac_no, dl_ifsc_code, dl_mobile_no, dl_email, dl_address, add_date, modify_date) FROM stdin;
    public          postgres    false    250   �      �          0    28893 	   dm_master 
   TABLE DATA           �   COPY public.dm_master (dist_id, dist_name, dm_id, dm_name, dm_address, dm_mobile_no, "UpdateOn", "UpdateBy", "EmailID", "BankName", "BranchName", "AccountNumber", "IFSCCode") FROM stdin;
    public          postgres    false    251   �      �          0    28899    farmer_receipt 
   TABLE DATA           �   COPY public.farmer_receipt (sl_no, receipt_no, fin_year, farmer_name, farmer_id, full_ammount, permit_no, implement, payment_mode, payment_no, source_bank, date, dist_id, office, payment_date) FROM stdin;
    public          postgres    false    252   ��      �          0    28861    govt_share_config 
   TABLE DATA           S   COPY public.govt_share_config (sl, fin_year, head, govt_share_ammount) FROM stdin;
    public          postgres    false    243   �      �          0    28904    head_master 
   TABLE DATA           9   COPY public.head_master (head_id, head_name) FROM stdin;
    public          postgres    false    254   T�      �          0    28779    item_price_map_1 
   TABLE DATA           r  COPY public.item_price_map_1 ("Implement", "Make", "Model", p_taxable_value, p_cgst_6, p_sgst_6, p_cgst_1, p_sgst_1, p_invoice_value, s_taxable_value, s_cgst_6, s_sgst_6, s_invoice_value, p_igst_12, s_igst_12, add_date, update_date, "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "Division", "HSN", "UnitOfMeasurement", "GSTApplicability", "Taxability", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "PurchaseSGSTOnePercent", "PurchaseCGSTOnePercent", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "DivisionID") FROM stdin;
    public          postgres    false    225   ��      �          0    28907 !   jalanidhi_dept_expnd_payment_desc 
   TABLE DATA           t   COPY public.jalanidhi_dept_expnd_payment_desc (serial, transaction_id, scheme_id, scheme_name, comp_id) FROM stdin;
    public          postgres    false    255         �          0    28912    jalanidhi_payment_desc 
   TABLE DATA           �   COPY public.jalanidhi_payment_desc (transaction_id, farmer_id, farmer_name, implement, make, model, serial, project_id) FROM stdin;
    public          postgres    false    257   �      �          0    28917    jn_expenditure_desc 
   TABLE DATA           f   COPY public.jn_expenditure_desc (transaction_id, item_name, item_price, quantity, serial) FROM stdin;
    public          postgres    false    259   s                0    28922 	   jn_orders 
   TABLE DATA           {   COPY public.jn_orders (fin_year, dist_id, cluster_id, farmer_id, dist_name, farmer_name, status, date, system) FROM stdin;
    public          postgres    false    261   k                0    28925    jn_stock 
   TABLE DATA           �   COPY public.jn_stock (fin_year, dist_id, dl_id, system, po_no, cluster_id, farmer_id, farmer_name, implement, make, model, engine_no, chassic_no, status, receive_date, deliver_date, dl_name) FROM stdin;
    public          postgres    false    262   ,                0    28931    lgd_block_master 
   TABLE DATA           M   COPY public.lgd_block_master (dist_code, block_code, block_name) FROM stdin;
    public          postgres    false    263   �                0    28937    lgd_dist_master 
   TABLE DATA           ?   COPY public.lgd_dist_master (dist_code, dist_name) FROM stdin;
    public          postgres    false    264   .                0    28940    lgd_gp_master 
   TABLE DATA           P   COPY public.lgd_gp_master (dist_code, block_code, gp_code, gp_name) FROM stdin;
    public          postgres    false    265   5                0    28943    log 
   TABLE DATA           �   COPY public.log (sl_no, date_time, user_id, action, status, ref_url, route, ip, browser_name, browser_version, fin_year, remark) FROM stdin;
    public          postgres    false    266   ��                0    28951    mrr 
   TABLE DATA           v   COPY public.mrr (sl_no, mrr_id, dist_id, invoice_no, fin_year, dl_id, date, items, indent_no, mrr_amount) FROM stdin;
    public          postgres    false    268   �+      �          0    28785    mrr_desc 
   TABLE DATA           5   COPY public.mrr_desc (mrr_id, permit_no) FROM stdin;
    public          postgres    false    226   �.      
          0    28956    new_item_price 
   TABLE DATA           �   COPY public.new_item_price (implement, make, model, purchase_price, taxable_value, cgst_6, sags_6, invoice_alue, selling_price, sl_taxable_value, sl_cgst_6, sl_sgst_6, sl_invoice_value) FROM stdin;
    public          postgres    false    270   F0                0    28962    opening_balance 
   TABLE DATA           �   COPY public.opening_balance (fin_year, date, system, dist_id, transaction_id, ammount, remark, purpose, reference_no, "from", "to", head, subhead, payment_type, payment_date, payment_no, test) FROM stdin;
    public          postgres    false    271   �G      �          0    28788    orders 
   TABLE DATA           �  COPY public.orders (permit_no, permit_issue_date, permit_validity, farmer_id, farmer_name, farmer_father_name, dist_name, block_name, gp_name, village_name, implement, make, model, status, permit_validity_1, permit_issue_date_1, fin_year, dist_id, engine_no, chassic_no, ammount, remark, expected_delivery_date, delivery_date, c_fin_year, date, system, paid_amount, order_type, "FullCost", "PendingCost") FROM stdin;
    public          postgres    false    227   �K                0    28968    payment 
   TABLE DATA           �   COPY public.payment (sl_no, date, reference_no, transaction_id, "from", "to", remark, payment_type, payment_no, fin_year, purpose, payment_date, ammount, status, system) FROM stdin;
    public          postgres    false    272   Cj                0    28973    payment_desc 
   TABLE DATA           D   COPY public.payment_desc (transaction_id, reference_no) FROM stdin;
    public          postgres    false    274   ��                0    28980    payment_purpose_desc 
   TABLE DATA           B   COPY public.payment_purpose_desc (purpose_id, "desc") FROM stdin;
    public          postgres    false    277   ̃                0    28985    schem_master 
   TABLE DATA           <   COPY public.schem_master (schem_id, schem_name) FROM stdin;
    public          postgres    false    279   ��                0    28988    source_master 
   TABLE DATA           ?   COPY public.source_master (source_id, source_name) FROM stdin;
    public          postgres    false    280   ҄                0    28991    subheads 
   TABLE DATA           E   COPY public.subheads (subhead_id, head_id, subhead_name) FROM stdin;
    public          postgres    false    281   �                0    28994    system_desc 
   TABLE DATA           8   COPY public.system_desc (system_id, "desc") FROM stdin;
    public          postgres    false    282   ��                0    28997 
   tax_config 
   TABLE DATA           6   COPY public.tax_config (tax_mode, "desc") FROM stdin;
    public          postgres    false    283   �                0    29000    users 
   TABLE DATA           8   COPY public.users (user_id, password, role) FROM stdin;
    public          postgres    false    284   2�                0    29006    vender_master 
   TABLE DATA              COPY public.vender_master ("VendorId", "VendorRegNo", "DateOfReg", "Name", "FarmName", "IsVerified", "IsReject", "RejectRemarkStausId", "UserName", "Password", "Type", "IPAddress", "FinancialYear", "UpdatedOn", "UpdatedBy", "DeletedOn", "DeletedBy", "IsUpdated", "IsDeleted") FROM stdin;
    public          postgres    false    285   �      4           0    0    CustomerBankAccount_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."CustomerBankAccount_id_seq"', 7, true);
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
          public          postgres    false    260            E           0    0    log_sl_no_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.log_sl_no_seq', 2974, true);
          public          postgres    false    267            F           0    0    mrr_sl_no_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.mrr_sl_no_seq', 209, true);
          public          postgres    false    269            G           0    0    payment1_sl_no_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.payment1_sl_no_seq', 1095, true);
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
       public          postgres    false    207    290            :           2620    29155     POMaster updateDeliveredQuantity    TRIGGER     �   CREATE TRIGGER "updateDeliveredQuantity" BEFORE UPDATE ON public."POMaster" FOR EACH ROW EXECUTE FUNCTION public."UpdateDeliveredQuantity"();
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
       public          postgres    false    251    288                       2606    29161 ?   CustomerDistrictMapping CustomerDistrictMapping_DistrictID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomerDistrictMapping"
    ADD CONSTRAINT "CustomerDistrictMapping_DistrictID_fkey" FOREIGN KEY ("DistrictID") REFERENCES public.dist_master(dist_id) ON UPDATE CASCADE;
 m   ALTER TABLE ONLY public."CustomerDistrictMapping" DROP CONSTRAINT "CustomerDistrictMapping_DistrictID_fkey";
       public          postgres    false    246    204    3556                        2606    29166 <   CustomerPrincipalPlace CustomerPrincipalPlace_StateCode_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomerPrincipalPlace"
    ADD CONSTRAINT "CustomerPrincipalPlace_StateCode_fkey" FOREIGN KEY ("StateCode") REFERENCES public."StateMaster"("StateCode") ON UPDATE CASCADE ON DELETE SET NULL;
 j   ALTER TABLE ONLY public."CustomerPrincipalPlace" DROP CONSTRAINT "CustomerPrincipalPlace_StateCode_fkey";
       public          postgres    false    222    211    3520            +           2606    29171    acc_master DISTID_F_KEY    FK CONSTRAINT     �   ALTER TABLE ONLY public.acc_master
    ADD CONSTRAINT "DISTID_F_KEY" FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 C   ALTER TABLE ONLY public.acc_master DROP CONSTRAINT "DISTID_F_KEY";
       public          postgres    false    246    238    3556            0           2606    29176    dm_master DIST_ID_F_KEY    FK CONSTRAINT     �   ALTER TABLE ONLY public.dm_master
    ADD CONSTRAINT "DIST_ID_F_KEY" FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 C   ALTER TABLE ONLY public.dm_master DROP CONSTRAINT "DIST_ID_F_KEY";
       public          postgres    false    3556    246    251            1           2606    29181    dm_master UPDATEBY_USERID_F_KEY    FK CONSTRAINT     �   ALTER TABLE ONLY public.dm_master
    ADD CONSTRAINT "UPDATEBY_USERID_F_KEY" FOREIGN KEY ("UpdateBy") REFERENCES public.users(user_id) NOT VALID;
 K   ALTER TABLE ONLY public.dm_master DROP CONSTRAINT "UPDATEBY_USERID_F_KEY";
       public          postgres    false    3612    251    284            ,           2606    29186     acc_master UpdateBy_UserId_F_KEY    FK CONSTRAINT     �   ALTER TABLE ONLY public.acc_master
    ADD CONSTRAINT "UpdateBy_UserId_F_KEY" FOREIGN KEY ("UpdateBy") REFERENCES public.users(user_id) NOT VALID;
 L   ALTER TABLE ONLY public.acc_master DROP CONSTRAINT "UpdateBy_UserId_F_KEY";
       public          postgres    false    238    284    3612            $           2606    29191 1   VendorBankAccount VendorBankAccount_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorBankAccount"
    ADD CONSTRAINT "VendorBankAccount_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 _   ALTER TABLE ONLY public."VendorBankAccount" DROP CONSTRAINT "VendorBankAccount_VendorID_fkey";
       public          postgres    false    3538    229    234            %           2606    29196 5   VendorContactPerson VendorContactPerson_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorContactPerson"
    ADD CONSTRAINT "VendorContactPerson_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 c   ALTER TABLE ONLY public."VendorContactPerson" DROP CONSTRAINT "VendorContactPerson_VendorID_fkey";
       public          postgres    false    234    231    3538            &           2606    29201 ;   VendorDistrictMapping VendorDistrictMapping_DistrictID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_DistrictID_fkey" FOREIGN KEY ("DistrictID") REFERENCES public.dist_master(dist_id) ON UPDATE CASCADE;
 i   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_DistrictID_fkey";
       public          postgres    false    233    246    3556            '           2606    29206 9   VendorDistrictMapping VendorDistrictMapping_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 g   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_VendorID_fkey";
       public          postgres    false    3538    234    233            (           2606    29211 8   VendorPrincipalPlace VendorPrincipalPlace_StateCode_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_StateCode_fkey" FOREIGN KEY ("StateCode") REFERENCES public."StateMaster"("StateCode") ON UPDATE CASCADE;
 f   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_StateCode_fkey";
       public          postgres    false    3520    222    235            )           2606    29216 7   VendorPrincipalPlace VendorPrincipalPlace_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 e   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_VendorID_fkey";
       public          postgres    false    234    235    3538            *           2606    29221 +   VendorServices VendorServices_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorServices"
    ADD CONSTRAINT "VendorServices_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 Y   ALTER TABLE ONLY public."VendorServices" DROP CONSTRAINT "VendorServices_VendorID_fkey";
       public          postgres    false    237    3538    234            !           2606    29226    approval approval_status_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.approval
    ADD CONSTRAINT approval_status_fkey FOREIGN KEY (status) REFERENCES public.approval_status_desc(status_id) NOT VALID;
 G   ALTER TABLE ONLY public.approval DROP CONSTRAINT approval_status_fkey;
       public          postgres    false    223    3546    240            4           2606    29231    lgd_gp_master block_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT block_master FOREIGN KEY (block_code) REFERENCES public.lgd_block_master(block_code) NOT VALID;
 D   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT block_master;
       public          postgres    false    265    263    3582            -           2606    29236    dist_dealer_mapping dist_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.dist_dealer_mapping
    ADD CONSTRAINT dist_id FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 E   ALTER TABLE ONLY public.dist_dealer_mapping DROP CONSTRAINT dist_id;
       public          postgres    false    245    246    3556            5           2606    29241    lgd_gp_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 C   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT dist_master;
       public          postgres    false    265    264    3584            3           2606    29246    lgd_block_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_block_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 F   ALTER TABLE ONLY public.lgd_block_master DROP CONSTRAINT dist_master;
       public          postgres    false    263    264    3584            .           2606    29251    dist_dealer_mapping dl_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.dist_dealer_mapping
    ADD CONSTRAINT dl_id FOREIGN KEY (dl_id) REFERENCES public.dl_master_old(dl_id) NOT VALID;
 C   ALTER TABLE ONLY public.dist_dealer_mapping DROP CONSTRAINT dl_id;
       public          postgres    false    245    3564    250            /           2606    29256 $   dl_item_map dl_item_map_2_dl_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.dl_item_map
    ADD CONSTRAINT dl_item_map_2_dl_id_fkey FOREIGN KEY (dl_id) REFERENCES public.dl_master_old(dl_id) NOT VALID;
 N   ALTER TABLE ONLY public.dl_item_map DROP CONSTRAINT dl_item_map_2_dl_id_fkey;
       public          postgres    false    247    3564    250            2           2606    29261 +   jn_stock jn_stock_cluster_id_farmer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.jn_stock
    ADD CONSTRAINT jn_stock_cluster_id_farmer_id_fkey FOREIGN KEY (cluster_id, farmer_id) REFERENCES public.jn_orders(cluster_id, farmer_id) NOT VALID;
 U   ALTER TABLE ONLY public.jn_stock DROP CONSTRAINT jn_stock_cluster_id_farmer_id_fkey;
       public          postgres    false    262    3578    261    262    261            "           2606    29266    mrr_desc mrr_desc_mrr_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_mrr_id_fkey FOREIGN KEY (mrr_id) REFERENCES public.mrr(mrr_id) NOT VALID;
 G   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_mrr_id_fkey;
       public          postgres    false    268    3590    226            #           2606    29271     mrr_desc mrr_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 J   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_permit_no_fkey;
       public          postgres    false    3530    226    227            6           2606    29276    mrr mrr_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr
    ADD CONSTRAINT mrr_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 >   ALTER TABLE ONLY public.mrr DROP CONSTRAINT mrr_dist_id_fkey;
       public          postgres    false    268    246    3556            7           2606    29281 ,   opening_balance opening_balance_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.opening_balance
    ADD CONSTRAINT opening_balance_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id);
 V   ALTER TABLE ONLY public.opening_balance DROP CONSTRAINT opening_balance_dist_id_fkey;
       public          postgres    false    271    246    3556            8           2606    29286 -   payment_desc payment_desc_transaction_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.payment_desc
    ADD CONSTRAINT payment_desc_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.payment(transaction_id) NOT VALID;
 W   ALTER TABLE ONLY public.payment_desc DROP CONSTRAINT payment_desc_transaction_id_fkey;
       public          postgres    false    3596    272    274            �   �   x��ͻ
�0 ���+�%�Ds�Y�Z����$b�_ӭNR���K#���!�R
������:7� �	7m�~0���)�)Lc�3R�<a���2ԙ�R�\���p>�1jkRlX���-�w���/��d��o֘�`�\l�
�r-�T�|}�)!�PtZb      �   �   x�}�1!����W�'��':�4$��"�\j��� �����`9Kp��WHӽK>���7x�Y�g2���z�F_�t+���u�T��n��Z�2�NG�g�l[�V����?��F
�Q�k�Bޭ>D      �   v   x���;�@C���*ңٞ�k��(�_ �R��k��Fc5A���}avU�#A��u�d�/�5�:�0�DJq�Yᗜ+H�$����!�By^gjx�%��!"���E�[b�/sO!���6      �   �  x���k�0ǟ�E�V�ܝ,��2V���&c��t�7m\�n����;۳��X����F'�N'}?��M���l���3�	��tV���{Y|Υ7��榺ϫ4��W����������ӌغ	}4#���1��9G�d2��-ҋ��B�S0B��������dG��lS4����_�9�^k�5���M§]�Q����Ƅq@�D�dy�+���x��=�aV.�o�V���^6wW���<B� f���g���d:_��=Yd.�kx�W��C�3�`>�¢�� ɒ��0W�C���{\���;J��J�dQ՗��� � �սmF�$��UQ��&���#2��A��Evg�og�yT���j �PꈏN�P����¡iGlq�>�vp<�)(!J'X���A��y���t�>{��P>��v����\ZO�Cy$1�K9�l���i�XE"�ʄ�فFHa��v���ye8��n�_��p
;�K�1Ϋ�w�<��N%n      �   x  x����N�0Eד������mUJ_<�&"Q�D�*	����VM��<�����v��\�r��M���t����U����x�hC�LӪ��U�V�`2_�� 2_����I7u�]��>_o�❼�`��F�!�,gVj�Q�Q�xt{�H�ڟth~���-5Vr"9;j��"�ē�&L�����uZL��Eʛ���e��ҖT[��jstS΍y�C�b����7���@�C�!���2I8�y":SEY�~k��p�r��dNi�[Pt�'��"1��ډ9\�V��k8�k7�D�QQ�;�h��}��ECX��D�_ ��G�mVuVg+!�$��3oKH!A����߲��Y.�1�p8��\�Fq�B� ����      �   �   x��Ͻ� �����^
l�,��qc���M&V�׷lF��'�|9�3A��4��$���Ϸi�АCT��=�\��]�a頒5�Z6��ʓ��%쎧6��J�C�B5�'-�_�J��JjO�o� ���`�} �Vg      �   A   x�s	3�t�K-J�,N,����r	3�tL/�W�ML���T��!B�y�%@�	�[jj
W� �
�      �   �  x��[W�Fǟŧ�=gDW�]oج/���B����/�@r��������%�Z-��q�3x��3��7U����  P��:>���+�z����_�9�W�m��X�+�߽����㳟��?;-��.N�/~-@J-�(>_�v�>�98������	�(��+�N)^_^�|�������~w�}��������Tu_#��U�n��S��Ж�	�}��4�������H䮐��b"�+c�L��=&�+��r�����*��*f�L$��N��1La�Z[	0o*JW�L�r,���҂¢�"��	�����z���zE�R�^��y_N�KcR���#U�/�Q��
ȝ����d!�6=T�D��u^|-���bfҭ��P�g����i~��k��^{�vZO�w�q
ءSH-�@�E�x=��������N�:����x9�]�W���6���j�.��|�~���;ϳԣ�&�M�G �N�i�h���ҕ�$�l�v��_���i[a��P�o�RHX��~���f%�ਛOֿ����5��
Eq��ɫW���|A��B��`Io������ן�ȑ�}7I��W+���u�VzD�?��ey@_+��w�z�9v��L�&ɪF���!=D�h���U��v5�����Q��N!�������"V� ӻ &,��y�(IRZ�&%��7���Q)Qi]*�i`z;`�6���1��qlkc���e�l���Ͽk��㲱�S�U�[�o7V&���N�y��8��:��}N	��IX�����
L�?+��R8�GRQ�TڦI�!�ÓÛ�N�����(���<���������zP��UMl��}w}�~�J��j�W'���-�i\̰x��ב�L?�,���̴1�!��P!<�c�ͰHc�� K��9�L�]^]^|
�)b�+��~�!����`��L;/�P~��2�/d���� �a���N!{W��G����B}Y��_�V�}���ԕ2���ˡ��%��n,{d�.�M�C��F�G旙�?N��!{�F6��X��F�4#���
����ʂ��
�'0���Q�(�a��T��'�>��D���`�����J2+U<=���B[l�%Jђ�,�#�������!�D1��㑿Ը`�S��эp�WǴ@|a�j'�A����,�y��XMX�!Nį�q�;ywxxX��/��������^xG���H�>;?သ�#�LJ���Vx�	�4yI���*��NP2+,%4/�)�s#���2rAR�!��A^	�%�z�3H�Ho��)S"H��;�5&	�`�!����������U&',����Os�:�WF�X�"K���%8r�U*!����.2,��ڧ�j�:���smt���!���j��:�Cۂ����� S�fM
�ӘIH����%��aE�M9pi�����CO_h�d&��P���-����b���6^;�ʚ�h�� �c:}Z�����0�X��쳧�&�jA9��u��A�k``�0�%1�,kd�*�F�fFZ��VK+m�]�͐��V*�A0��^����ɬ��"a=�r��v�i_���N9u���O�U��R�k��Rϕ�z#˖ve%�����knD�,����C��)�83yA����F,s��Ϟ) 'l��r�D	�m��?����L�����44�0�if+�ʏ��?�z�޲�W�(��8QPl�$�-I)�2��!�����ԯm�*�>/���a�[>�{�
spxM�Jb]��=@&(9��7Ԧ�h�9�h(�Ik�hEa��dy�5	N#q�Z�b��:|#F*Z��u?T)\n%�(.N5��޼>:�7VSД�؜(e�)Gn��]�A\F���V�W{�.0z!j
�p>N5f�Cd���_͜�,��Ih�Ѩ\h�\���4�ڭ�	h~ �f6�lj~'c��C�#�}E�{���)bQ�k^�Q��W=����C~�U_ \V�Ӟ�Z�)�)ϋ��K׮��UVd�$�3�U��zu���6a�[��W���<}a�Y�������I�Q��������>�@�}�k���������#)]�o�K*Wc��#A��LR.��=��gB�츜�������P��6H��m}Fz��$d^}&H��o���0LRǞ\}��-��.��y�ۜ�ˣ�(bj�Ѧ<j+t��=$��E�gfhu�2ݪ胮�p5�8�^�5R�9��b�rU���9��#L��+/l.�Wb\���r�Z�|ml�!I-�)�.��ncH��Q�^�����zm�a5���p9�j���Y�w²B;�T�)-�ŰnNoNYG������-ګ��/��l�GTXe�%K�<�Bs�V���O���y�j��sNE���'�|�����2XîN~�1���:i)(�	Nʐg)6�ꎽ��Jk>���qN0�O��O�A�v�N�+����9�EM��*�8r�Î@��F�v*r',D�Q���@<�Y~���T��4�*��e�z��LLu�&��Ze=7�>���Jis�v��(�N-W��| Y*9��fts��
�N���-h1�帿����X
-�mHu�U
�<�I�lb���p� e�²D)�>�Rܛ�\�}�Bg/���)�._�l�D�/nB�jE� ɼd�jE3����&��>]��l���Ç3��WF����ִ���)u���0�{��a�)ʫ�Í̞�H�����G�ߕ�C����\y�����,�|���4�Q��	-�3L�#�\���٤*2/z���>�Քd֛�^nI���������˼��.7�+��%(?
����ۊ�QUL��F����%z�6��r)�Y�\�л<��#K�7��t��m����A� �� ���'�tl;n Dj�B�%�N(�L�i�a+P<�I5rhW����5�~�T%٢��
G�G���=qu՚��|��G�-ЍF)i���]�Ł�P8��ҍT�A���&�LJ����b/>�ˣs��>�Kw�HmF�ܸӀ�4� ?�����+\?tЛ�c�-<�E��^-^���{ۿ�}b��:�Rt��)m�H�%4�#iڀʝ�f����))p�*�~��
Ȕ��ƦUi���r4���yz�%ַ�Pq�%�#T,ϗ���b�
�w:^.�R����S���B�*��-��F�RPK����?9��{��!��~&�������k�\�Q�,�Ǣ�>Ct��j֔��r.s�B��d��bx~��q���qS�6^Ќ4����-0|�'I�QjD-ׯ��j�"��S��pư��>��,��	�����;?�?]ߞ���������XRW$��%��������4!�%����Sl �hQ�,��pׯu��%�:sS���Q�� D)�}uc����Q	z:˨���4�#�- �j<��NE7׷]X��«��:�FW���!2�^�7�%a)JU�7q�2u��� K@���H��Afo�⹑��H����L~��)�0#�~c ��,Et��r�;��	��MNU��b��&Û�L�� �֍;ظ�R˥��c�TJ�|k�r~�g/{�lCO���"���ic)���w��� π��#��H(e�6�h�̆����N?����ܡ���;
7�+��tX��~��i[	[*�%�zXD� ۴��-�����ޗ{{{��jl      �   �  x��SMKcA<w~E�b��3=�Q/�'/P�(����ѸK`�g2�목���8����U�j�����z&"$�RK��k?O��-��+Sf���O��rX�N'�XTN��lss���g��������u�����,�Nŗ�N�BC�����	�D\̻����݀oo���n��&p�) WL�k?�R|���P�=�:�d�|48��
���̺,6��u|��%����KD�P{�@���,H�k?�E|;`�Y��ы{�~)�]n��,�'�|1�,[<���K@���Z�l�@X�ׁ��Ic�<�Յ2Q�H0�c�!���LJD�.2�(����X*�E����?��$a��*�"H�а��8Xs��귳��s��s��\Ăcc,m�'�4�ly4k<���j�U��      �   O   x����0���0=LJBw��s��%�:!���B�72x���
>���d�D�h����p�l����h<��^$?�`      �   �  x�ŘMo�@��˯�^y�������!49�B��ʅT�z��O{�u�qkţwf�w�#h�����������z����M��������9?�brU��W��nng�~*n�O˟b�����������<��!j��Ig�@1����7*e �?h�j�x��r�S�(Og�H6HTy�v@+|�j(���b�X|��(��}��lÝB#�Edh����T����N 6U�o�g�+�?I�5#�HN"َ⯤M!��&�J]/�:-���Ȉ%#���2D�A(j�7�/��bۣ�<=ʃ��t>أ��#hiT�m�w�vw�w��>��hP̀�z�CD�k���\dV�V2a5
���ٻ��:s��� OZQ��ĩ����D��:9Ϣ�Ѥ�I��j����8����R������B`�*�!03F �_3TXaHڨZ�DYl� ��~��M�]�"���K��JKr;��Y~S��V�N�%��Ǐ.;�!���FRټ��n+�:�gDd��U��6=]�}��A̦~ы�@b�<���Qҩ,�Y�b�YQM��<,��7	/�Ȇy dŮAf�N�bWL��B�(Mzi �8��JU:�گHm� �p��>��t6��<4]t��V�8������\.���!x�Ǹ�&�SB�rY��M>��]���? �X{�K �ik���l"o%�l4o��-q��Mf�rL�LP^-t�Fa��UX����y�S�%��vpRS�W����`�T�D       �   v  x���Kk�@ ���W�^\wf߹��B�/)^Dc,�DP��ͮ�s(4����M��$&���l8�O'}�=���A.�(���\�0�a^+X��|��?���GI�do �8�s@4h�Q�Zr��-�U"����x��׽u�f�@~ߩ�[��m�W��1*&4>r�$M{Y2zJ����g�rI/��2�Ө5My�iаsZ��YO��to���д�i��u�-h/3^�2Q��4���EpZ���cql��_�OG�j�\0e�!�9-�k����dR�kKs�%�aS�۔�mu���y���Λ�:l�#���6�9-�J�M���
)���C�D�~�s$:�W���MݯD�R�ԌS��^�Q�hɢ(�n^��      �      x��]ms��|���I���x�7Yr[Ŷ�l%�x��Z��$�<������� �tG�h��m���Z���<���lxu�����~ |�^=��=�yq9�a���v�O�����}r���y�m��t��?^��V�{{��V}uqY?;�}r�xwrp�������C��#ar���x���������/M��VFk5c���ZU^	f���L���
����+k&@q_YX�u������g@��_��U�_g�_�������|~9���V���8�'�O��_O_�M�|~~zv�vA�7�l�v��?�N�W�p�io;}��@?�P=��v��������{�Y�_U�>\^��E=��07ar�����`9�ǜ�C�� ��u�E�;�-��xܟ|���/ޝO�����_*ń��g�-��IJB	�P��"	⢢�f5�$��Jhe}e'�0�bc����#���Dl0"��h'��(}�	��ݧw�<y�aM��?���Wg���9���?R���Ϫ�g�]�������n��_?S3\���O�nk�*�%������ ��D(*5Cr1�I���ƫ�����j&���I�I�][��T�p�;bj]��U/�*���Y���q<T��4 2�4&�߲v��A>�8oq&��(�r��Ԣ�{y�ǃ��g?=:�����������E��������/����ٯWg��;Z�[��t#>X#u`���?۫G�c��%�d-rAk? �k�jx@��Mm���Ն%�nĴė��F��f���$�9*U��Ä��PS�kJ# 5��
qBA��y9ΰ"�k'5 ��2��׷�;D�+��ZH���b��_S�؏o2(�����z� CNk�c�-�[��7���NNN���������������O��9�2�B8 �Y&je�K��#��:�K)sCt8��k/����3��>˷���yoT\��r3��uAϷ��"� B
��_9��R!եB�
I¯)!��T7���T����"���VYk*��
�]��Z#�϶��_�̊�j�O�N��M3m��ϯ��k�!T0���ܲ��7a/"2T�h:����s�FZk�������#���������.gf��e�5Z��wGh'5i[t$�h3.	��[R%���I�Qi;��B�✯嘢����Z�h�k�+������E��7�1:�����M7����)�>3p����x��m֩�A��w^i�vv����_9�x���4��V"S	��E��*ݕg:k.���U(l�Pi�D�H7���l�'/{Hy��]�ughI�
G3��bHy��h���h^=���oKG��_O���..ޟ}�tu9�)H�&*�?We���Z%E��Bv�PY)��}e�TS��h��Qӻ�O:8������ÿ�|���-Q�E�֑-�H+*h��L(b�K��(wIPs���[�Ό�'o��gx8����z���&�j�?@^N^��O'����IF�t��)�2̜��Rp�4jTQ�,**����JBCo0��ں1ES߷�P>U�Oi�~���bh$(--k�ⵘ��K���DMj+tG��K�olW��'�5��"��)�01�������y��c$�R�A��>sC�T�VX�Qy4F�P�g����ŀɶ�%c����(#�RS�Rb�p-Z�(���V���N�Z�($- �IeV*G���xWI"�	�E�a8����f�?q-_*��N��7����!�U�!|̭n���6p���a2�06�-�Jx�E� �*�Iߤ�w�#��0P��KyhY
Q[5�e�x0E�/4/
��li�8��h�W�nn%�<c��B���?�������p���#�5�$\���1�7�Cn�W��u�[2��8�a!DK�V�i��EJ�r�<Vn����Xh
4\B���*bG��v���~��˧��k�G����7��M�����Dr
���H|r-E �V�-
�9(**�D.3��PYs�/Ä�c�����0�5�ebw��
#�r�,*icAat[T���o�ȤB������Dc�ȶ�o2&�Ls�2�yUQDoS��N����*\]���Uɱ�2
��*���(���T}s-���T���l�T�-�ᣟ���=n�x�}�M����Y
�j��Fi��I�%C�X&dG��z_?}���{�pʯN[�8;�뤢3��n��29���]�o'ޞlt�*ع0�9��qԎ���$U#��( R�[���s�	���7����:{���S&)��9ucb��(�{GY/�\H2��Wd��ڲ$�j�]b9�.���X�)�F��.~��󮒘������8���l�t��2Y�W �N�dm,���jF/��5�(�;
��񍪤v���A�����/N���n4Q�ڀ���Ǖ2�(�(i��Wk�W���mߧ)s�s�½���T�>�Q� ?X*}��h͎�q{C�����^-m�2E3b�7ǰ���L*�{����l�%�$�{GDe��|c@���Ѷ<3&O|.� ���+��n }}�`�j�&�r��1��B��֨�}��6�T�f����x&#�E�
	�b�7Bb��_<�)�=p�����]恴��&h�\S��P��Ô��Q KN��wD�������m�E��T�Z8�y��4����	�2��ߢ��}B�M�����@7.J��(P�Nu�8y�2C ��v�ػG�3;��4���pn;y��.F��qc���h���ۡ=�`&�����ۊ�W�yp0��M$e��=��`���Ū��^4oz_�rޫ�%n��j׌��N�2�q<E4os��Dq�	��6��"T��T�W�ᬋM~=4bQ�d�,խG��XDZ�5h�5��-A4F�x\A����tJ�4�V�tKSF�������J���G �'�� �s ���1 ��i@��Ի��Tz���Z��3I������M�[J��Xjn�z�YMD4�&��CwhƌB1� $͗Q�X&(�9��s$�8 ����C�j+c�=�b�BSc3I*ݐ�$Z@�F&�tʴ�Eߨ������P,3���m�r���m��t�x�������u�+@0}ؘ��\R&>g�U=i�w���>\�b#Pf��crP1�,AɺX�`�^��x#<	&��t�x*�=V�M;���r~��p��ӗ'�8��]'~��CH+��*S��N��gG�.U�"�eûg&�-	����	�O@]��@i�o���5#5�X>6�`J09|y����=���C�(�e�]K�i��l�$��k�ci�р�t�!�ZB����`&Ȩ��oO��b�߇zh�R������C�A������꿕�����S�?ߴ+-::��-�H4L��m�̆��%��0&��pW�A.Cy�I�[g���+���DY.�:�ZTS!k��N8]�n����۠�I�B�qXS��bՕ��-�*T�~O�z�<-��ֈ�0�W�y�u���[�u��M���_*��n�SkGZ0JH�@)o���uZ�X��0��G� �WGz��7L����2�*�"PE���w�̊�����]�t�#B+��Ţ2����M�R��2>w�gK�8�9�����4~c+�p��{�ҋ�������WC���GO[p�m�xdCst�6W�U�,���e��v�"��w��GX�?���=ʶT%$��r5��獍����V��T�u�?QJ�ݚ���g�je+c�|~�k7�e��t��d"�H�_�jH�p�#(��@�#�X��m)�tt���VX�N(��G��6������ �&U/�g{a9��l� �q��bWU�jQlm�o�1�� ���!Eŭ?"נ^�,o.!�ɲ���cݸb�p��������=U0��lzk��s�аC��%�����!��n�� �C5��!�X�,��dU��Ata+<��K{���Q����k.�E�5�kK"يH3:�u��֖'�'Yӣ���:��WΠ����֮wQ���Z
�6[��r��)y�:��@{-^�9��W�rHZ��� ��}���ׁu'҂�ގ�׮� �  ��h��}?Gp?V.>�y�6��PZ'�Ʋp�M���M����%����O���W�\�O�Ď�؀���W�,
G �Y�Ah�#�#F@��.�r��(wF@0Y���RJ�]���r��Ǜ(
Oєr�-�ޮ�o�-��Xp������7�&��lO�m�A(6�2G]�Zn�=�=�~Y����o����[_�[G��9:'u��K_]h�q?���vV���� k��:<z�t&xc{�q࠯��e���o�3C	tF�q�<�Uˑ�+��\jͯy}��|�v������dm�t��E���L~�:Ki�{/�����V|�e^�":b��o�V~���~C�Y3~	ƨ����X�g��������!��U������<c      �   >  x�]PIn1;K�����ȉ���K/R���&9��"%S́P,2�$�T��6�N�%���yk���^a]�4����G��2�2�����d�ذ�z�Z�G�,���VB���ۥ��@36>�u�6;Zn`��e���|$��D�|��ъ��K&��*���%n�X_(�tD��]E��D	ѳQR��a��Yʰ��	B��=Q���K���J:n;x
�~nu��vlz�Wt�A����>�zW듍��b�3U�h]ܲR�B�!�1ԑC���`s��Dn�RP�|�ѻ8{�zy�O6z�֧���Ŀ_��̓y�      �   �  x����n�0���Sx_a<�e�]���v�J��1I{H�	
��_sQB���������go#)$�!��s��`\W�g�e�iZ����1`���a�M����|��������qa�@��NކQ��5����L@�6�E�¦8�@���0���^ G���oN����؏�f���g��u_�����]!!�4'����$L�Wڱ	g�g�G��DI������3��P,Y�ŦE�v���U��h3��&eZ�D�!Z�0�I�W�������JyD.4�	;P}P	��/a�8�mq��"+Wl^�"]���}LQ�n��h����Gõ��вM���=˅���˴[�wR�{�͋�z~(�H��I�}�����׆;e��u'1N��t\�?�`0����      �   �  x����o�0ǟ/�S\����6��۪j��j/)jCV`ڔ�~i��
c��������8����y<��+�N�ᶬ�y������%7^O�	��#����/q�J���e�YSV���
�3��}���;.�+�h>o��|a�nw�n�u���'�cΪ�9�"�@Mvv��%�w�6�^e>��@�c��,��4��܇ɔ^:�9s�zm�Jk��S��$�����*l�c�B/=C��(�a�����Aؤ�4��_�gQ�z��á�l������C���>��X|?�+:�X�S�'�(��;��!�0�bA�b���!��{����e�'��XΕ��	;�c��t��xƏ9�	>�St|�9�G�$ʱ;�?�Fs���Í��Ej/�)=mEB������e/�VwK�'��KŬTcr�BM��5�h%��i@z4^hf�}o�[,�`離      �   �   x���;�0��>��"�HɎ�ct�����A��6�E�Ah��b"g �뒶'Nsm�X�	��m�~�����^,I��:��k��LP���\����ډ�~�6��m���u$1�Z&ڿ=z{��o9�+#��>r��	�م2      �   �  x���[S�H���_����2������ /e�y	0*����~gDd�-L�aB�M���y�^`��9�D��Z����.�go�h�������>�'�9�X(t+ug�!h&�$�N3�z�[�~:�h�N���9�94��?�V�1�[���T�+��^7�tg��9�R��A�Z	xy]�ߣq�����t㗸��N<$��Z�p �(��t��F�C��='`�C(�<��a���V��Ss�n��n���!���8�~;�՝�]T��f�O~�-$�ݝX�#��Ȧޙ'Q;+���xM>�&�'΅TP�F�e�O�P�n�T�����I�F�f���O6�O?��QC�]�����h	���J3�aVY�J!�Ac*��q�`)�C���s
E_�a/P��(��a�z���0h.�̕�H�R%оzt��/�������ի�[�j�0l�6 湭��}�B���_�#�(U�>r��/�C<]�F_��v{u�q{�=,\�w�}�?�~�t�3$'�ڰc;lEAp��������yZ����[��ZLK-�t�{\�ԩ=qIBen0}]ʞh�<�C��"�c�іYv�%��F@�0�=!|{{�h�H$���-7k��k�O\J.��r�L���!�0X�a#�.&���N���R��B�xQ5�j�� ���0̍��+�\���H�͏�_��#���٥
���CE`3⚱�$Ǜ��	�2���T��e����P��vѬ~�r��U'R�`�aS��Ț����3����<ޮ��L)���ւ�},��s��rނ+�o���E�*0��RbY���� h��FI"D$G�J���J,�G.ju=����'wH��])l�R����2�dI�������$v�F��6O�.�Y��-C-�`���('�(?��A%$���C;�L�:q�`g�<�\	ץ��)�:f`�W<4p���ܣB������Hì$��)+��<�O�T�r]����K��ʯ˚�n��w}]�<���Vq"����<�j�L^��+{=��+W�����h�D��!�������:q9DA�ܴ����Y��~6wA�{,&%f��OCM���)tPX"G�a�j��@���$Ր�����@u�E��y>ŋ쯘H��'IڍG�"�Gi2�T�y����қScy^(����v�y�<�����˳�w�~�ggg��3      �   V  x�ŔKk�0��ʯ�}mjɒ_��]vY��2�.�0:�l���	i^-��������l����h���qWls ����[�{/�X�J,>���󰛤���tQl�M���(GJH���s��O�)b�ڰ�i��6n\HPM�(F�P/�d�*�Fr˕>ր7�@��5� /�1b��Gj�O�`�I�>�}L��:Cn��v`�������.sʷd�'{���y�Z��&WO���C8@J@�3&l�~�(⸼-��i]��R������>��S�X ��4v�5��r��@�I�C'��N?U�*
�K��N;���� .rr@$�\�e3p�fI��o�Z'      �   �   x����
�0E��Wd/M�I}4;.��R7nB4MI��_�c!�"�r2�{�@�e
h�Rm��;46G/*=d��>"]��ߟ:�F�;�O��ASi���*�+ QƁq��ݜ=R���l�A�kyP�Ш�ΫJ���(�YZ�VZ�����PD2N�����_�[Ӆl�G��JW���ݚ]/N`p�Xq	�������mq�7���B      �   D  x��Uے�8}��
}@L�07�	�����R�͘�l<�����6�`f�NiSP�D�n���Hd�$9���|:9wC�:�v�ʴ�n��Mᛏ�S��}��%߀��u�K>�h�Ͻm���x?,C�l����_��Q<�]��p@�g���㾻 U��1�!���[bL�p@�'��A5�ǷN� ��;Pm�`�%�����p���@9��q�����TX(��sk��U0Cs�娾�@C�=�C�+��bc�`�ʸo�x�p+�C�{ ���6����0D�?kkiC�V�=�]��(����G�,��&�V;�	�1ĮԀ�|���W�"��K�F��m���-�J�^6��Ma,���1!�>-���C��E��˪H��L�⬬��«��\q�)�T(�������(�Tq�J��{��7-��OQ�EB�i���Aul[3���l���fq��|��u�܌?�2���t��ǉ�~d:(�LQk�QلUW�#�wgA��Ԃ�=���'��g�%�OQ|���^0��N�:��m��M�ݎO��3��Ӻ��ˏ��3����} iכ�x��5Pn�{L�"'�k��ޖ�p6s�l6ʗB��g��U	7�t[1�[��{U5�����2@̣ ����vP�&��O�dJQ��������4����՛)�{Q�[A��E�V5� ^��ײ.�Y����%���P��"6u[ū��uc��7��D�&LG�*Ƹ�G(�ѯL�ñ+G{�ա�N~�!-��k�_/�4%ySt���)����0�t�8���Fh���e��������/w��      �   �  x��X�n�8}f�B?`�3��Eo�M�-֨�$��
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
ʜ��ɴ�JN���u�3݂�O�����x�뜰���?�^�9�����ݩ� �o�_�jp�3������ ~��й��ۭ�ҹnD����i�=����HCR��s҄�9i�v���>�E9�&�AeW| Dh���i�+L^���H	����)ѯ��Ŀ�M�\~����iI���������~��?��˯�o�So�����{B%G?d����Ӄݫ��Zk�3ɤJ6�6	���������������z�/��73Q L���FS�����w?/����̴p�      �   �  x��Vێ�8}v��0al��yZ'dCn���H����	�i�����oiu�vR�u�|���Z,��
��>����~����Y�M8#�M�����������R��YR��Ec1��f��"�i�̓|�!������P����bׄ?X�N�$� 0`�랖�@U��־��2�D��`�����
_ު�V8C$S�d��" 6�"jQz0GfX4k�G�aM��S�6!d�5������	ډ�F�UԲ��`��ط8��.\�����,bR��C�Q f�h����7�8��3 �l���G�a���M���N�#�C�4��~����%y��(ԭ[�ޅ���
��6��Ew���CK��!����C�h�q���Jo�j��b7۷:Ɲ�%��)-/�s��Uv�˪H����m��&���\��k*��Tj��A"<�<Mh�>?�O	�Ҳ��O3�}3�d�0x�ę�:���[.e�	o�z����#fx=�*��}�����}]�6�qf�٧5&�5ܚãK{+Ҫ��e��/����*ӫ����C%��d����" �ivʯ����^�n.�;|B���҃�X��E}�j��MY�E2Ƹm�K����́�3�8%p��aWݡ7b��������|J(&���l8�?!��9��Ϥ(Yv��:��<>ż=�G�yɞ^�Tlk�/��b�*N�\��Ef�-#��ٜ�@0��.14n(��#ح�F��[Fl���C�>����h߃f��.�\���*�eܮ��7�7�0H�ӨWg����,�j������kY�&A���뭄g";��F�`یS8�87l�N���9���3��gꉳ4��ۖ%���9�ߨ}�g�Uf�h�o�p����-�����)�1��u�5.=�oE�d��(��#&D�eqi��Y9�NL�����a}���d2��7
�      �      x����r�Ʋ�������w�H�0O*�L�W���,E��������q�Iyź��P��Fw��=sm���j/��Q���v���n�x�[��8�5�Vq���~%4Q:R�3I�q���r�R\B�էlR_)�����]�Q��+���9\��K�/��)Q1�,Q��#j��l�����׶���o�y���M������z�ަ�M����pE)A�����a�G/^���l�6]M��������L�0\���%S����q���t��n2˜A���f�\��kV�3��#��81<dOpԇ��I��n8���,]9@�XS*#���/wEM(�	k��	�Z�As2��5�y�ڮ�Y<�Φp���F����o�O`���3WE(M�cFٔ���!\��u�y:[�KFw7�Jj�\�=���5	������+|\�ট�m�.�W
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
&%���w1c�='�an���~# 3�Nv-�� �T�]`��>jÃZK��e��mV�N��BT�`����s�x���{���X��������&2x��*2�)�6�-�a��g����A!=� �l~�|�,f�i�A�)}�T�Ђ�����"�;�5����\^   �^�@���Q"�Q�3��	R��A�Jk&�R��cT�ń8��i��!��wF���6�q�\��"}n��s�5���/.�|=�Y#$��LW��2��N]��wwI��r�|n�S�sk�z�n1�Y��^�D����a��\����3�Ξ��ik�����_N�0s���[�K��y�Ї��r�}�y\1<��(G���&-�`�sȐ1�3�g������%1$ϘsJ���v�B!���_}���9hJ�Ϗ����Q��l            x�ս˒%ǭ-8������8���.��ud)u٣;�[���v=dYU���ہع3����#3�2k��B��;����{w>�#�#���wo���ǟ������?}��ۻwO_�|���7�s���ϟ?>}W��.�.��o��o�o���Ç��ɯ��
!f����
����	&����D}��Ow���X����wo��O����o�X�j�x���ǰ�Mk���a	��?|{~:��_���������_>>|}�A3�ɅZ'[hID�	��3DT�����b	f��G��Г��������J�ǋ�ڿ���
2&�JB�C,1���(�䄁B��pj[G3��bH��;yyZOa\��nx� �{D���Tr����l��)�c;'��MS������� ���������ݧ�_�~���ӣ &�H�T������,m5]�h9%��_~��&��9 � ���,.���z(��C��3hH��蠂����G��Q4C�3���Af�4�(.U�uL�돆�YC6V�<w��h����ϯd�7�/���97��t�����x�����{_���l����3��8�׵q�k���5��Q:�j�]�
d�P:���������.�+m���
�>���㲆�N\;G�tTV�c�5����S��\�;V�#�t<��+������{@�3嵣��{�;��j2A �w��<˪i�a5Hh��b<UsY��w�ք�o-�w��\hZk��8�xŹ���lj�O�A�	.r�qLBU�[Ë�1Ѿ����v��c���1�+m�b.4@�8�\m{�n�ɃG�&�9���r�y!;b��`�+����`�H�7��LVpD5x�.n@��f��5������G���@� 92��5d�{���	AC���<ƴ� �����������O����ݓ{�����?�����Ç�烆l~�������41
z��]%F4��{�6���T��mn[l~�6ť���w��?���h�޽����ׇO_y�۟���A����[��F|�}�c�vY�v=�u !tL��(�c\Mh��I��c����)��.�6���m�j���Q"�˿dh��Lh�b| �櫆��DﭾO�D�C`͂ �q��Ԗ���;'���n̬1+���E�	�xN��A��xv �����r� z�u��%_��Qb����
t1��*���L�3��#��=h�@1�K\��C�3h�]6�%q�#FI7���pa\c�85�0^r�}:��ӟ��˛?�`2N�=�����.7Ў"GS�3d�v�.s��G��3�Q�>4���
��2<Jb�1�%ŀh#�X��˼�#�=0�~-7Ҩ�	,W�zLBǙ�K�f���|)�n�V��fvfn��_I�@�1�:�P���~�:�I�	���Cc�l�sQ�k^��#F	=04�-�j����\�<���͏������h�įۉ�]c/7`�����'�hҘ�c����_��ȑ�!�������������~�M~���[��͟�hշ9062k#+��yOޒ�EYɗ��]���s���y���z�d�n	.��iDxđ���Ct�x��p��H(�K�[w{�v�d���#��F���m�HYn��#��[��o�	.;윘��4���]�b��E� �ݚ��vG!�5�#BJ���H�ف�# _)	��G�"V���f�As�˻J�f�80j��W��9�GL�I��90i�,9�����IW^c)�{������=������9!������>>}����ß�����Y~��_?(����w���ݗ��bν�\j����ʗ�w�ӎ8W���rW\ٽ����������K�:�_�����([{J&��#���S���`��Q��؛N��t��)������O3q��q2�6����U:+e1g���ڮ�)����%�@���l7p�4�e����çwO��w�#�l��a�=1�m���:ccu\%z36V���J0���0���h�U�k���s�������p9U,��>[ܨq+�xkXR���1�X�1nҸȯ�>Z�7+��9��E��G����I�z�������<��W�����=.�+�6�^�U�"�4�Ǿ��?�?��5wC��,����^�p8?�yo<l�������|�|���P��QS'����:zMm�[�����F� ���y�03z̓Q�RRN747gfIta����L	L�l���Mǯ�y���'����"�g�3s3��������_{�M��i=r�&�m������c}�'1�#f����Y̱�g-����z>v*�vLΙ��c�����3&��y?�N��s��$2�����F>c�8�3�Y�W�D0J.Ġ��l����5����M�׌�`�l�,��zC&j2o&����fbU��I��%Y�$ �������7S��$5���V<0��a�>n�Ў�E�5\X�r�Rv4,e�q��v��B��ÅuY����#�|1{�G�HŽ�L���112�<�-ނ{�/GV��ƕ��X=�c���3Υ���X[�����l�.�j��Ny6�4�O.[�� R�������Ӈ��zzf��ݷ/_��<��$Lʏ���?l~�o_�~�r�m���eA�Uɸ-�)\�� _�#��J��������?�=s��ï��k:8�1';�۲�-f��?�����,=&�x��������(`���Km �9/�����y8����_�|��Ǜ���r� ��v�<����}��b�FGx�u��p�(Y�\�vZ�I��1�y�2.���?��NB$��6L��.g�L(�<m���-7�<�\�ھ<��$������
yV�X�땎�?���b���J6��zDhޜ_#	o��C�6H��ks�O-�;��P�l��]C�e���b�I��*��֝�A��#�/͠I����2s�I��mOˢ=i"5Q�gv�f�]I�7�`�4uq�4�q!8��I3�x���)��4k��"x�v�pĠ4�p��Y�h7%�7�
G� -OmI��P�SNJ�9il��Y�,.=<�a���g	�XN��9b�;����V,<i�'$���<Z��i�9Y��"�����)��kDQ܊]���˖������M�G��="�@�S_A��P��c�4�8��G^�r��C�%��I��'�+iD�䀮�p9Ĭ��J�!��m�T�?��M�]��5��^��v��t/A�c,~ܮ����r<���ࠁaв=���`��8t�8We{��5����G,�+�z�S�I����\�h�9�IKX��Yo� gE�8��Gz
p��M0����N�8q|��Y�j�j�Tϕ�?xJY�^�\�k\AK-#{2����C��j�rew�߆8NJ�����_����??�EQ[�� �)�R��R��T$mQf5��JO�����C�f�h�
�g+�SQ�c�:1+NE�^[T��O���>�krl������v�v
F?�����R���<��S�50W#4�����M�&V`-g���27��!���q�I'.�4w���8�V�K&9���1�nhVe"ʣq9O�ㄹ	�n�!�5��g�=�LC�M������4�F�����]Vͼ�z���,M�QZJ��t}N�t�U�谓�]X�i���:��,���Aɨ;[X�)+̤���O��I��/��<	��A�$�Dq����Y�m��d�w�2RMX$%c�Fe�;�+���cȗs�O��7�v�O��K3�Y�W��uLAh��lR�T�9��Mָ����-n��M�V\���Q���#��ж0,3|V��A6B����D���.���ŁA��]:-5�`M��բ����vY.�������o��?�\͟�g��P�Ms5�F�'𣭽�e5���K�X��4̈Q�	Li5]T�>�Yu���>Q���u�ؑ5�HCvE��]|r4s�St�|Q4s�^ۄ~q��KF0Jr4��QS(V�ٲ=�f@W=��    B�`M���W��,7ǚqP��������m&����M������?����,�I��X�8��-��N�,r�Z�2�8�DE�*����	KԨQEӇ�QI�rS��|���Q�u��";7��e�Fk��w�[���j`�ݕ�5y�*	l�W[ԠP��׷
��jnB��ҍ�_P/j����@G�4yqcU~ԏ�5K�7�h�F�t�4�a���l�34�a���Z'��qLҤ�.��*�� 5��+��t�ָ�;;�F��ڬ�����;�/�	�̚��4n1s��f3N�z1\ά�jPB/pU�ʚ��UX]M6�o�$�ऩ��%-k����絩?X3�`�>�u�Y֤�24�j�Ak���ir����L�3d�4O�+A�F�F��c�40q��/�i5�<O�j��J��҉%�V�t0i`Q��l�*IW~��[v,�J\��y�j����wB]Y�l�\�UE)��ݻ����v�B�U!����<��йw�Qi��N����E4��QM��p\��y+�(;��{Yc(��A�(-s��1B��Hձ��S���Vx=O&��>�9��$;�j�4AF��妍~nl�4�r��0ܲ�S��{ɡt�����,�>yiT2���F˩��O��)q���-��iT��
��W���>e��ǌ4(�a��$Ϣ�8^��&5�`�Ħd�Ҩnc�a9��&���h��Y�>�Tq�(�Ɣ��	`�9*����"��i��AA�������:����1���c�p��0�im���F�I�VF3�0i�)���rj���A�j�wF��7���e��� �Ƭ��T��/�#|��ǻǧ���3��?����������[	߾�����_A��iU���߇A�}��;Q
�KWr�T8*x�@V~%�B&;LP�Q��bT��$4giڗ��Q�À	r���u���$��x��cEUρL�(�d��r�YA�tl;k��-
3��]�<SG&�q4��'�l�bp?�Q��������k�K�H�<��_�p�) !�Q��,��~����:�8�)�ʚ|^>6�����{�b)��ʱk�����_���Ƿ����cdΡE"eW�!AG�ҙv�LI��Q��,W)+DD��}<3̢1�ci�p�Q{�؍�x��1�:�ؖy������:��6���E�n<o�q����~n����������>�q�#��w����߿��_��;�����/|���?c�P��ٽd���oT!*C;���f�>��dp�~�Q�M)I
�����`�M�ۿ�������_����9J=.�NU���ǻ6� �S�����-
7��'L�4�*��w�~~��������Ϗ���Ѓ��_sD]��	���T�<|�T= y���uۙ#��%���n]l�PP�T���ۏ�~=.WҴo�5n�㕛��N�Qt"�Ԝd[\Ҹ���l���u�g̻D�n̨�b��5�z%osT�1�E�k�Q<:xi�m�*86�e)�CWaT�����{�V��Q��M&V�%6v�
�{*�s7��f���S�����Q��`h����m�������U�&�Q%�`l;\��^&����ݧ�߽�����T=>����3V�a�ײ#��6�BwEZ|����C{�����F)�e����iT*��d���c.=�Q��:J$�W��JF^1��X�>���������������������q3��]���ϵ~�Qɫ��۾�؛�nCZ׌؛�J���P��>�m��TA5�-?���n��5c�q ��}���E�����fc]+���Ns1�5c1J*^�77�[sJ��`EeXk`��{���.�ǌ8=�u(W��8cFj������ԓƗt�z����!��]��E鍻��َ����4`S�h��(*�
y5a����ҧ�t�ȩ�n�Q����u�GF�A�ڱ'I�%H��.��jǕ�H;����T;~$>�k��H�ZСv<���~��tM�:rM"�d@5�cRn#/}��<PjǮ���=BW9PjǸA-4�T֎p3w��Q��_Jsi�eM�w�e�>q��;�̜��@fw��;��|�pwŏ#��U %Ze�ho+�JX���օ�ݑ4*e���"�3��&؃��-l��46����3^���#2$ɼM����4�v�Y�$�o�CW��nO��H�ڗt���d�&��yI"a���	4܋b���<��Fu1�AѴ�0����Qs��vih9F$�KN�Q������>��Q�̀�>Uu�N[ܢp�X��rd�[.G��/F۔�4*���o)�e�4��DYlS,ҨJf���vwOָ�q%�h��f+B7V㴽��XX9H;+[\�W$�]h��5]q�Tr�ZO�PZƳ���ȽI�O�20C�ˮ�H����M��-8R=�&��v��qq�L������{�L��QA.z���秨^c�Q�;�?3pR�0���8kT����*�Ɋâܹ��^r�S�bYA~��$)�G�������:��|!�].��8ٍ���3��ݻ��*�>�`��c#wu�A�[|�K1�ַ�%y=s�|�K1k+��)an}�s�҃Bc,�?��&K�A��'��"�x��";��:��L��<IOf�u�
�0u<Y�`�bRG��G�V��:�,\� ��)�:���f�]��8��*�&�\�ϝ�>6��
kҊ���u��ңM��b�$��|'MW���Z���&,��fC�DŐ���
I+�W�{��I�65�b@�lȶV�jI��4��Kt�9�I�!G}C��ٳ�'M�,�����ڥǞ5;r�9���5Mra}�x�.FYS-�����.FY�3I5I�tlrG�QR�WH-��f��A4u]sG��?!&}�w�)�^_n�\��ʕ&��+rG��cA$���t�Z�:P'y/����5*kʆ �3A��Vn�q�Ƌ�/�W�cK�:��٭�t��Ub&�E�t���q��4�+�I�2T�Iں���z=m�Ө�cc��Y<��+�N�:��|��}q�6>�ݯ����oϓf_�:�͏��HG��{Dߦ�ƨ(_4�������`Q�<�ݱ�jJ�����y�t�aL�`���o�cC��4���b�¹os*����0�=YVi$�F��-���\������S���t��-"Nˁ\�9k��Il����jPVqEVr��iT���d���JJ�1���g���d��G��_N���6q��VPn}���ڦ4�2�6eJ�R?����EҦ�u�e*����hw�d5f�s%��&�z��N��,�z��]��/w��^+��,do�Б��`Y�,p)�q��곯3��{gWf��W���#:��/8�z��5h�ۊ���/zʩ9Ȇ�y[+��Kq�-y�$��T����aL�`�9��n䖔�%%/v�A��b�p�g'y��Pj"���Y(�uA�ØUc��p���-d�����
�Ki���☠0���׼��B���I礈S�Mk��p�L�	MN�,jˆS�P�"���>�f�Iarc�ડ�c��c�0�^4��f���닆d���'�
��B�]!���c��j;
n`{ h�$�\ʮ�;����=\����G��bΣ�i�8�i��c��I��δ���
���qۻ����8aI@~9�:��rL_13��V�A�FgkF�3f�rê�9ew�n~޺��9�6Cr�s���f�����}u��+/J�fH�6_���^�Q���=�o����Ð%����8��m{Ս�����F���e��8`U��������Ͱ_�kq3�6�JYXy�eF�)��tklFUf Ȣ�uI��2��Os;p�]
ڌ���İ�~ͯ�e�}͛_�7� ��Nd���y��Bm�e�[+����)���
�3�f���46��U։��8���y�d��#S֘\��||�1������ư�N���P����L��t9y�͢]0t�3�.cl��H� 6W���C?n�.u��[��������y�����~{~���/Owr;�y�j�����_��_6='M�\d��/u�h��L|oq�{��L�    �y��ݥ-�Q�|�&��gL㎶w�L�ߞ���.�O�ϟ����Y!�%l7������[8vzo}֊�\�����l���<W0/�����͝/Zs��3r��+�frd�Am?��+�2#O�_�9j3��q�;y&mF��&Z7��5sIԆu5�s�$�EY�U34#7_h�t�����*���E�.H<w�Eє�^����,E�4�\}�
�2a��"\QP�}�r��\˗W6����]����H���Xf�>�o��cCpXg���J�M3O_��^{3л�UU��k���\9�--�5����i��L��x'��2�cV�)�ۻ�Վ���
v"{����മ_X;.�R<�/7�_�u�r�H9�G/j�7w��sgN��+�X�v]|G���`����|]9�>��<��O^��-f�L"w�ƧT<��͵a�����O($��E
�}��x���>~Ze�IasRHj@�O��y�q��촣��¾��q�)�vF��4nB��mSud(�*h,L(������2.���>ճ��c8�w󎗅�'f&:�?�a�3�`_�V��ܮ����ך���4�ڳ���U�֛��F�,]��{p1�O�*�ee���wj�W1�h�⠲j�+��6�f��v5^��i�m��c��P)�b����w?0v��7�.����D/	u���`?������JTCi�`(�7�)�ڿ�����n�v���P�S�n����аWz�2�k�G�
�����E�
��Vb�0K����Lc��jܟҼ�B�>�Yf��=׈�>lP�i�1�m٩OA`n�u[v�c�ى��o�]�N}��Y�f�1DM�(�>�ж�����$0�.pf]t�+�B�����68��Wȅ/1(l]�ZV-E�ؒV�-kGQ"j�
�&�\B��5������2%�ǁ{�1)�ǆ��&%k�H�:����ǎ��=�V���K�`�W��W؜�
�
�N46�9"���-i\~�nW���f5��o�HQ���k�H�tɂ{�ym��4v�}3��M�;���� ǚ�9����o aT�@"�L�.�Se�P�sv/�l�KSy����ֹ�b�)���Ue�ⵒ@C�q�0�=6�����&>��q�듸���Đ����L�5'&)�L �΢�56���ƫp�0j�U7���!��f9N.�Y�r��ƎR����Z`��y4�*ef̠��ü��1稱�.3�[�rT�a�J���X�ؕ����;�����
��
Xwz�)�����5RrU�1q���+��f�Ŵ¸˔�@4LXbl���A}A�RPa�H�w����Ç�_??�O,����������ǝW���_s�5}�y�|� C�z _j�PG�a�_4��7���	4��p�TrX6�-%��]��}2K�������(�2Z�y�)S��{�l��Po?U�z=��7��з(�Zj���FU�mn�zP�KF~���6�Gm=��G�>�۴>*�/���`�������G�>ʥN���v���o����%}��\ې������2��ˉ�s/'@�	t�7�P]�Lj�=g�!���>1��O����A�d��8z븄����g?� �:��v������u��C�Z��/ƷQ�B�W�W��$��B]͊��:�4����ͽ�|ɿ-b+�H��so��	�'G���S�Τ��'�(�:�G�z�9���_Ϋ�R�>�H�r���[\Π�/qݲ�F�
�K�e�l�B
ӓ2�,ftpK|��qx��jnnr�I�"z]���e���˳n:�[COι���w�}�EC��9�v^uKWed���)��ག�������-��09�͜s��h�Z�3��⻟L�1=�m�\���ֵk��N�T�B�on\��;и�2q�ER�Ռ�7_�@��?o�MMO�6J-vح�p#��H������͝OX��C�z>?��!�1?��W86������z���9�@J���Mh��s�N�����j����k##���΍1����YA�������H�������=4r��[���|kG�N+r�O�c�*�Qd��cG��3�]�5�,j��"�M���U�Լ�׫��l��Q�v$y+�-bw����6IOar�\�H�ȡ�X8xG�c���MҋeOq�5&.k#��%���W5�(#�jD﬜����#�{I��	�rAx�3��]9�����)c'	�g'ԟ =4��w<c �Z�J=�?|S���$���&���;%�b�.��8QV�\5�\9;}���CǸ��AUA��������N^AsԄ*�_�f3�!ix`|n$Mf���Md~b%�e1�]�����5�m���%�ɇ�ʤI�sKЭTH��8���Wݳ�5=��َ����"��G��s����#O��I����9��,�������隻%m$r^
3��r�p����b�ca�EA����\��p��D
iIe�	ICK�7��ҭ9���]��䑜��Axp��p�QzT��Z������n{E�!��+]/�k�0�Tެ�r��h>l\`�Z�kBф+gs�ܩ�i�A#�z�?��88њ��,�J꥖)6����V�:zBn\���
�]�}t�Б�+xv�����ذK�о���~�J}�1�נ��HB�Kd�z�.4��**�v���d�/�]��&{�j��!��E��d�i��mc3���"�@g��b��	�1���
V멉(J�=nǴ�z����b�(.�~w|��i�B�Q�����V/=��f�(%�]�O0B�Ij7��S�y�c2���Ny��K�j� �噞�xJp�^T����傣�=hL�#�k.zQV��ΰ���2\��>DՊk��C��y�!��V��
�Χe�R�� �չzt'�4 ;�8Wǲ���juٟ�����R����dЗ�Y{ڒ4S5���z�*Z����pP���f,�&*��4cq/9`���C�̄R]�_�۟iVB�-�99���45̶�XW� aJO�5@�$��`i+HYC��%�`ň��(��K^�u�6�"++P���@'��(�
�N)�_�'ז���h��S>� yA&����ss\q2�*��9Xs�Bo*��r�:��T:~y��I�`Cŉ�u�St�o�η4�4����=������%^��+:x�=2g�����X��E��b�=Sko*�t�Ǎ�Ϙ�|�n�ԠM��L�yy�`*(S9~����bo*it{s��B\���9S�Yº��avs���GD6�:6P}�0hv��/�E}�pl-��uY���D4�==U�9i�g���f�Uon4�q),䂍U���I�V��j+2��d���T��6+��R/Nø)3I�Y%K��Y�k�9�[�R)�����5���J.椉hF�)/'>�%�bE�:��^o7�4e�|ҕ�!W�����������K��d~�O�i����]��Q��Q[!�y_��K6�_ξ���>���[Q�O��m�y�5�p��f�6��n�B�7cb�&&�r|�ko"�~ՠe��
���v�[�D�,��em�(Q��'�e�Bm�d�.��v�bo����̓&zN�mD�ak�>P
iY
ᖎ̬O̃��w3�i�RI�Ҿ���\�TH�Z��-�4�Br��4����\۞����E��V����
�.��n��!��@��I�;&6/"���ۚ������9@s�P+@7�)�ӣ��_5"]:�b"�\�+LV��z`5Zv�8Y5h+���$�kL(3Y�9I�횓��\,�E������ ��,��d��"�W�1+������Dj�Ͼ���Dem�Cutk|U��8�r��7�j3I��1\��0��̔W:\5
��xbE�T������x�Q^,�%�]c�P�I|����Z�a�f�Xѭ��&"&����X�ߩ�/�A֝��T8��iM�8xM�$: e�u��;�o�捃q�|^Y��u�o�u,���l��.�i����7����0 �)GN�A�*s��C��_�n�ҠIA    KTҕN � :ihfsk��BȽͽ��z��h3+� RY�� ���<�lދLɓX�0��������c]�E��Gm%���@	��g0Hl
{�6���S�	����v��b��D�q �Y�=��WB(�

�������!N�\������w�}z[tG`��o�ꑋ����2#�����߃��I/.=��᱌�5�`��e�O3��yy�iOʊA �~RZpro ��,hD�8�@J�$
T� ���T�0\)�?i��A+�Vp��v�o�PE�ü�p��-�L+�>�{��W_����9
�cӆ����/���(V���[dA� C��gP��Y�zW��M�]�9d��S��}���y\�V�*��]+*袡�Q���jhֱv ��Oa\�V�B�$J��eT����X]!k���(�92Win��C3q��eTB��FQ���~���_�|����ǻ��||����L3�ѕ0�\9M�I�w��>�Q�CK;.N]a{����FuF�\T�7�⇝������oF;*�z�Mr���.TGR�#��0甴�J�OP�8��E�˞��wS덜����8���9�@�Czsg3���4$��l�܍���H�JF0�J�Ǖ� ��,8Ԫ!�� �-�jG�H[H޵h���ʢZ;^Y�\���O���c�
�$�O�^�f���rH(h���E<'������'�k4w��p�9tQ�A|F��3��|�,M"9e�g�2��ۭ0���4�������G�Р�Y����U�0tb��Ls7訠�Y�=��B���?��۟��j?��U������Ѽ�m�NZ��B���Ӓ�mC�Pҟ�5l+ڶ$�C�f�k�V�m�]�٩|=ӪצUn����װ-(ۆ�d,;�Ժg�	�M$�wo�ջ�5#5���ihw({���չ^/��7ǪI;��W�WUU�v�\�Y��/.�9y����-�КrI�����$��ɔQ�Kd-T^s��	t�������I��X����Hқ
V���ɏ3����j;�O�?%ʡ�r�/�~3I���X���>i+"S;���>k+H��W-�_z+�A\׊��DH�Y؊��AB�jOA[��M�vc� ڊ�5�e�8c@�1cO�&�v1��Eo���	6��ȚA(ٲAlC�$Ȩ����nvM��������A����"�ovФנ9p�8�T���R��q�4A6�?aw5��m�;�hm��"������>]`J�E�Q����FF���
�YC�,�D�C-!R���Y�)������y���Qy]����:(h�v��??�{z����_�?>=�=<������/d���������,����⇛߿{���! (㣴�@�\9@�Y���q����$H�[�&��l����;�r�0*��ݷ�ahL���Q�� �E����0��`��_��K�aT�����m�K*[n�Gu[T�������|�Q"F���Y�+��66����2i�|��x����w�>}�Q=~|�I�w��o��	�zQ㿕�@mF���d�[�<*�0菖�GN�ɮKf�P�F��6�Y��+��3�i����I�>+[ ���]�$Ģ!�o5q�dՐC���n5����Df#'�hP�v��^3�f9��`G�	�vr����H37df54��kR�R�^��gM��xsg; M^,=�����>������&ƫ���k���7������Lym(S
����Rr]�� �א,䶇�d��Wu�O,Q��Boq�o��A�ba����ē&$�yG�a�W���Ccs���|�,,H�L��.=��$,W�D���R�ˬ�������N6���q5�5n�}�j`\���')�K'����10f�C�������+\��0E��fַ�=Az��p+���(���z\4��앣|+�Bھ���lgE�/7��!�sӢ���T�b�[4�6��Mg3�e�����M�x$/�K	�@��,�=4���Yne���Ky�����{XN�ٔ�~6��$6�ْzX��oŧ*Y(ﰉ����6B�[�[��)�{�EѴ|�f%H����v��F=b@G��!�BɉyѢ*j4��t�._c��*N$���W�te`MZt-���]�YCK�Z��r\�(hV��.̥�,��u��Y��f�(��e+N�r��&+V"az�PKF�y��a��9�g~JZ�i �����F.��SW�i =%�,-���ܨ\�ԣ��C�| �YC"�$p+G��wUf���l��ڣ�-F�
���V����G�׿4������.�x����<|y��D���ur76XL�T�����'b ��v�6b�!�Q�8�ոpÄ���v�@���@=(6 �)���Rp씿������L��,o�̢͔��Pnl6�2�U,�Ծݒ�0ag֓b��i!��19���1T!�6&s�&�X*��l*��*�F,̗�f��A
�݁ ���l��G�v6������I��F�v� ����EaJ�(�� ���~������1^_
�������B��ETXr1�Y�=(��A�G�p����<W�����_�vOqԣ�>z^�L\��@�������f�*����v��8.���Ʒogd]?1�%5�a�A�1���⸒�1Ge����kHI��U>฾f��Q����+Dx��7/�pՋ�V�i\�C�)�Av;r\��ɹ��qɍ@6_��W���K=$��Y��b�A�6�v��8����c���h,I<\4������I>.���<pҀ�,;�p\73��t��gW� (H�<O�= � �h�q�xx����\��Lù]&�ʯd���k���M�,5vU�(p�w7kP.,�TF���<�2�Y#OX)H�Y�f}\�>�c���A��\�?8����K�̇�GT������c#�B�ĳ�e���5�3hم��()hnGZ\�������Cj8�^�B:��.Ĺ0�V�Q�q��IEA��Ӥ�}�ÈU#�z��pY�S:.*ЊH��؃׍��C�!"����$*HNW
mߜ���0d�!k�Xl�h�����2NI��D�
ϾM��2q����AV	R�]�ݙ[���A���sDC���`�aHАR� �kYPC��E�&�L�=�F#;�+S�����e��sI
��5�K�G3CNX y�)�Fi�IN�V������ت!%�9���V�!�2�/Js2(H.1�A#ǳ�3HԐ�c�Ы��	�+����p�� ���N�Z��py���}���i�]�&|�L��si�AB;�e�o Az��e��5���_ђ����sG��-bU�k/Nq=:JF�?M�����v��׻��@mG��.�1���n~D��Ue��ș�É`�4t`����CgR��5 X4�pl�4�0��Bq�N��挌�l��D_{S	��{{��Me�,Gs�M��x�\��Ve���Z�������4*h�Aj��@��DG�Z9���ł��L� ڂ\��tRБ�k��2�4v�u�A�WpF��[h~r�������j��m��8J��@�rZ�ˊ�wp�k��F�:	p����
�)/J�.�wihT�Q��R�k�F����Ǟ�G��2�cQ;�WX�4�Μ@m��F���O\ةxq��I{[��Q��ƴ��V�k����^5*}�t\~YF)�[+��&X�Ҏie�oh^R״�`蠑g�T���G��xh��yx���1jS+g�s����B�QY~�.��8��4Ƕ+<���YW�6{�e־f�5)��E�H�d���n9ā�_�&�i�E�	iO�e���L;�E5F���ɜ����S��jE��(]�p��_x�℠�������O��'�⦥M�f�$1���X���zH�C�dҐ�#}>�%�Ę{H`9��kܦ�����{�b�����������������={4!�X��C��?�M��{�3����C�f���������mAdj�ϘVF-Cnh)h[��|�H�C��ͮ$i��.�)�fW�h��ӣzF�9=]ˈS�)    yH�G;z$�ȌG�V��q4��zp�.E#R�ȑ]d�y�����[��a4=�cefG�nozR��t��J���:R&Ib����(�X4�F;JN%'���Z�[�����V������ļ\nrzF��\��t�媌���(h��@G�>abT�1@�?9�눹0��6��������M}C\�����Q�� ���YX27�h^ �o�Q����Ko�]{h�@KQ�+]'��b���[V��Y#����^�����L���.�
E��<⨴�ЧX��{TbR`)�ί�9�JM6����͡QC��Hv��o�>��t�vY}�����<�l7x�������߾>|��������8����H�	aT�2 ���ϩ�.v��lA�����qTѲE曀�RAմl@�B�5��FU.[#���U��yk��7 ��.�t���)#�M�D�JΗ0hԡ��kSQ!s�85d��F���	T��5b%M~(�wk����h)�Zl�:���=���K��h+�->7�j-J�=�:7s�^Cs%x��s�򡷔��.[�Q���G��8�\��X�
�؛@��̼�4Z]iD�u�״�� ׀�i��Q���.��C3h3��qΝ�K�]�g��.S^�7�����͉���J�0M�� L�ng�iQe��J1�f�.�+kʋwN�[{��#F�b I�dN�僧GL�%��=ih�m]���4��Κ5��q�Mݤ�s����m	�fΠ��q�N�$Ws
\Tp7;I��R{T�����5�o�q��0_40�5���׌�}��r�}/͸��|^@�h,-p%:a�P[���..�Q���(l���F�Y�)'w���Y�x��2t�*Kެ�A5k"��p�?����d�]�ޢ�)�߁`��w��fCFM������84w�7�S��N�D���2���� 5���G�AR��/�'�G� 9���-s؍ۡ���sdV����7\ʢ!���k� Y5�\1�Z2p<d�PR�Ts��S��N���9�ti� ��l��r����M����e8HL�Q�(�Q�qV �f����������?X����xOK�Gn�[Sؤ`y�ѥ��S�"��R��Q�ڨ���������>��mT
�5�L�o�v���eJ���}=~iF5+4��qިfe�,�V�~�>5�t!������b�ҕ��!�' .��Gm۟��',M�#9ҽ#n�#F�(��W�%�SWFs(�Z����OX�)=JZ*[Q�V�)_J�tl^S��V��b���$G)�;��(#Oq�4\T�>g��bvJ؛Y�r)����5��*�tA��	KDZ���ٮ8���w�l¦�CGϯ ��-3���b~j��#�̼z,7��g@��x���㇞��B4�9mq��:Co �s	fK�4�4���[p��������>a�!�Ը|�(�4r�Ȓ��������F�50�F.
� Ƈ3uLO@�90r�^$ha��52��l�b�(A#G�))�|�h��S�]��.��$
�9H'X��i�,ǳES�x`���]k�#���]�GQBt`��5�q}~i�{�����\�ƽ��������/5h����x}���������R��B�^?��R"2���������r_�Km�+$�oW�nEb��&�1��^*I&v��!�tz\��#�o�.Pv��dm�D�㾰�b,/'c39a>.��{p��I�,	-��H92*�C#܋���+/�|Ǵ�3��,yM��q��Xl�v4srj�w�z��f͍FT�NY��r�w���HN�F�N���'el�ŝP_��wS���*\����li��!a��n쀦0�'iD��.�B��0]��-�l�w�u��fAR�}����~�.��\z���M�)0��7��w/�w�<�����[���992R��5���O�&V��7�+7mtRF�d��Ic�%����pZך�V�+��5ic��������h�������C�(�E� LВ(ⵃ�{�v��xy���f�U�K{[�mߞ�4ckivY�䮍�&h�ʃ�F���O����'���oys~oah���O�~� ���{Jh���{4�8�E�����m��u��@A!��xv���
<]�k��h�sd���τQ��Ff;/�6ԣ�v�.�Vpx�4�՜���5�޸\2�ɿ�����5�qS��B
�)����N����z��%ra�V&j�d��X�`�5ir��a���As��ճ��0v͡�m����\ơQs(eQ��kh���h��>��*��5o�&pˠ[#�����#-�t�jJ�,���7n"M�ڎ\2�����	۲��N�@î���mh=t��\�(�ܵ���{��0�Ij\��pc���bo'V�]율�lc�6b�"����[z�O�g�DGC�ɂ��,�����Չ,����')y������r����փs�BoE�2�ꊥ)�ra����7UŒ*3�Y��yݷee�V"כ�����d�i��G=DU)��.Pc?a�g-��M�Pg�hS�4O��K)���8C�64e�#Cv�LoPg��9��"8dWv��&� �P<������a�B�NrK�5c货B�fj&F���~��̔'T̵D��ھiZ�z��2"��i�iǍ?m pJВ���i����F�'���	���B݃c/��&�:[F�n׀a���|����׵T.�9=��z�|/����z��4�I�6�i����˜fP��Q\/=�Wf�N����z���e�O�����'Zp��hu,ki�'0*��@��F����l�Btpj���Di����?6�
r�Xd��]B�\v�Ȧ�������m�C'>i��m�l��jV��`��mib[�L�j'��f-�D��iI��̠&���]��
�mv~�V�2��|�m${?cf9�.��jez��D��3{��҆�[�m��Ge����f�ю�3�A6D _R�pI�V~���,9��w���)����Q�C"�/s3?0���zg��0����<��	�}�F����Ӷ����_��C�&}����������>|����Ϗw������?pT߳U������+��B_6���NB��	 �c��T+���q���mҀ��q#�&�R9\� -�8bT�����<N�|�w �����.N� V�(#�Ȕ�3�k�¥��[�sC���xG����Q��s6[G��J:r<Nl�DM9A"'��� � j�a'0[~�I�[��vP�ͪ����c�V��sD^ߣ#C�aGN&h��X�)����A�!3GM7A*��5ۀ���xID�6Ĝ�j��D����%�N���dp�aP�)r����4�l�	��㇧�E?�$��5�����أG5��d1a4#먹e�X,/j^a��<�O��1[�N�
�3C���O(�<~t�W����dǱi��Ps����&�&��N)�?~R5�D�\n��f��}��G�\���rϐf�(�`��4�,�A,<i���u��j�a���Jf�F����A�`��Nj�5�J��>��p���H�PH�S����$�U_J��Pa�ٵ>�<b���R�`�		M��D�v�ޔ����Mj�`�~�t���1�T4l��p��պ��s�~�|-�.w�S���I�����t��'$Y��fi2��.N�5��1T�I�d�f:��tH�Lb�E՜�A�㜬9g�X-V�h�!�Iv����r���(Z��ESU�ωv����f@�`+*�i0.c�\�)�dQ6�Sm���<b�8�J��Gp�I�5��,��Mj��&�f�2�Nj�
����V�E���k��d:��P������p6�����k���ԪIG��8Lv;U�1q<�xM:�z���KY�&N�`�S�I-^����/^S̀u���9#Ԝ�$���u���oD����q΀N��;�)C�<�9��F �7�;���e��4,
�Y�u���"YLj�L�`�<��j΁�!o�.A�� 8I�ZnN5 H  Ӽ���A3�.L�x��F	�n6�d�O���f ���I-As.T��*�@�7�X�)�A�9��@G9����� ;�ـZ=n�(g@�x1.�)��¼c�x��i�� ��MM9j�H2*�)����)�f�P����q6�&w)�=\���97���W��[DwJe��Ӽ��R�+��s����T�o�)��d�-j���U1�IS0����P��j�-*�x�H)xEes�9�2f�t�2���&���(~��!�U\9G4�f�ٞ��o6�&A���f 3u3�f�A�+Y,~bG7��RSڱ� ��/<Ďi"W�Uo�J��f�0�:����A�$)�1+�*��̀h3��i�jJ��r�$Ù&��Hg�j�S;�m��#ѱ�#+��^G8�r.X�R�3X1��	�\��EQhQ��CY�e�p,�c=��7�*��.e�<�4n�Pi��أ�f�R�s��`Ю�jr5�Q�2{�VDQ��#�����Ȳ�rVe���V&~��aO�k�Yz3cひ����=Ug�.\���>�fG�ژ��qѭ�͚;5;8����5w6+��Q]\�y�4h�d����~]S'�̛�k~��x5u2j��t�cK�V�%w>綂�yтC��ǝ��y�dg����64c���v�&66 ;��4���촴@��C��b���@A��T)���0(jHdwۃ�W<��.w�s��\�n�K�(�X���N�q����`��'�$ש��蝼��*=b���^ێ�*\B�ӡIs��tG��i,�����$*_ �6,LK�]���^�0І��j����6�H<�O[���ȶ�{�:e�,"��M��kai i����TSoE��Hk� k�1�9J�>�R����vr��Iko*6���kS��Q��c°@��)�V�!Gi���l+�]6�k�U=��Y�-V=�.� �#���%[�^��� )�*+�^��� l���>k�Iæ��.��w��5�e͇����,�L����댝�j0s�k�=$��x|5�9+4'rMG�����Ġ91T.�*��}�ќ��ݢ��/τ��1�������(��%�Rԫ����Å��Q���k.�~�z�i(� 
l �L���P{3��Uڷ�V~Ƃ�6�� t�K�~?�/_ځ������w����Q��]S����\��1��Ī<�[�̸����;B%�׃�z4��������S M�Y�?�$묑j�#i#Qt�҂����?��쬁v�|��R;:�N��w�n�cGg�R@�����������?��O��w��X�o���j�}���%~g��t�޵.�%iؘ�7�]z����r�Q���̽�uk&V���KM�բN��[7���ߞ��՜������bP�%���U7�\ˠ�A(i�%錟�
� i��j3�ʮ�o/�E'G�ɣ n]�.�ܖ���ԇ������=�ŝC��������k��F�"����;(
ޚ��7�S�j������fWs��RFE'[dH=��)�J���I*��VfT��m�yU?eTŲ�BQ�f���V���FI��ɧ������{.��-+5�ysg����]:Gs#�u\h�Y���I��`�h[bءصW?6���&v��|ɮ+�Ѧ%M����37:t�~���k��C{��w��/?�����I�> ��RԳ7o�Y��Brאgܗ�
���k�|s��#�]���٭ϒ!k]��n̵M�@�lwt�g�*��s��I^N�>��0;'}00rr���sm�>HH��2#ڹ�I�$����X~��>8LE��ܜ�O6�}�kiԬ�����"Ys3It���
�D��7��:�zZn���_����6�)         �  x����n�0 ��~+�I���ۀ����^T�$�Q�����D���l@?`LG̛����(bX^_�V�`�@F�s^��B5�����hދ�D�v���6f���=n^D@���kJ�Xa�*:Ѕs�9i�������ۄ�<�Qg�`�8�������xh矉�D�a��;I'R/�O��3QA4!��Хۊ�~�3��Ic�3伭��l>�����>�<���{��`[��K�ɇAahyv��Yݖ|�f�G�z�Tͫ�ity��u�����Jy|z~Oӆ��ڬ�C6��|�܍2V$m�z�dh37�ڂw1V&oL�5qD�rnSwW�nqW�l��5��3�\�Tf2�LZ��6>6=��:E�ʬ��]�s6X�A�R��r�.�ȅkuX24cQ!Y�nl��*��2f�Z���,U��4��,}��&L�3����آ`�(�&
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
=�J�+�ҭ�[aa$�A(���z)1��8{���g��!Uaag���N�l>���W&���b��/L�$ﮢ�5�AM�_	����c����|9��Y&\��l�W��Ȗ	��$X6��-�M�*�����c�qm<_D	_��S��O�;m���f{N��>���=��������~���q�k��ۛ���&�4�]�֊��eLӀ����	�l��b+_�������IM��i��9�=ó�m����������|��珛��f��*|��m��m*�ů�O�l�t=m������q6�K=���DǓ!�NyP����ix&\��]�a;<� L�	|_��(Y���XExB���������n�o�j�����?���� �O��Hihi _7��$����K�	r$��5-���O��h)OV�4ԇ�p��$�(���yu�@��'Ê��AD��=�����fX.����*��T"eՖ<g���Ʉ'��!��_k ��d�����OƑ6%�\�D5�ӿ��Ln�z�^��o5Ǵ=��,ҿ����7�2����n�p"j�te�@�Tù�A,T���ߠ��Ԗ�鹎�m����Z&-���|�A�ʤ��a�M�a���<g�	B�(�%�v��+%�@��R��B���ޜ��� �g�~?5o@�Ts�4m0{ɼϔ�󹖆�|��Y��:x�͆<i���2�Y�|B@S��7io�$�0}"z�|�
0��[��'ѪN��`$A�#��k^����8�"|���_��r�P��3�y���p8I�G�S�"�h�6I�ޔ�9��o6\�\8O*��_�4j=���]�]?滟��p���.~�'R�T��s]���f��Z���~�I�W���2b"i�����,�Q�$¹���Kƀ]><*�~!d���f����O@�p���:Ϡ�e2�j��&� z�n�>��x�~%ф_�G�3%xq8_�q�A@��$�x!��+����X���|��:��II"W^���H +
�J�3L⹞T �پ�P`�
�hi�$��3��(Fu��m��y̗;(z�}6���I��Y<�X����A<�VO��n�_�==~��6ۛ������z�?6ݷ�G��>�pΈw�q۶�9���Z�e;
~.���Z�L��
.�LB�ǂ=.x��d��E.F��s#��&p�k�b�r���2��'�ođP�E��L�2 ��L:fu�T�h�%`+H@4�h�Ǩ�/�%�1\��^��g��Ǯ�z���8!.�Y,4�0�DA�˨8��R�A�
�Z6t�$hՋ��m�Q��G���xGBs��?�� |���M��]|=�#������Mד&5"KO��)�ГD��!H�E��N2�u�ԑ'_����F�v��s�K��)��,����◸�=E�X�`ĳ}i>���w�_'D!��庮�~�0|�c-��	��^�|
�b�OQ�sDξ��p�p�����*E���Rc?����1&����VJ�I�T�
��*�mP��pp��iT,h�'�%Wѯ�
_h<�/g�2����aUJ���C`��"GQ偄�2�c�6��YE�ySR�O��}�ئ$!�dP����6�=9&��X ���-�gZ@�4��tݻ�C���A ���FOG	�� OGVT��k8#M�a���J�/����:�v�&5,bY��{�l�\�TQdm�1G�
^�K`AE��u���GO�1$��n\	�G��G}y²Ã.7_���SD@���I�2aYd���1���r�J�_���1$�ߦ��n�9ż�D�ޤ����[�s�8"��*6$���P�? ��Qӑ�K}�W%�|��\�1���lyj�<Ҧ|52�sPutD������=��h�'|�O{�n$<<}|.�/O�Q9Z@9�g{yݓg2j+2�K<��z*f���i
��9�-�������:>�L�T �<�B4����>By�������Js�BLe5�
/����C$4�Jۇ�u�<o~J&�
4�zTG�#j�	���-~TK#�n�xZ��M�r<]Pe�s�ʟwA��D��n����|�#��1ƍ>�1n�5��C�w�,�y�\���-P'��HY��Tq�&?�T�6����W���3��c�e˷-S�~,
�)�GY�� ��N �0*�߀M�R�Q=��O �[���B/�*�O&��Id����P�<[ ������c�h$�Ri�f��	%�r�'!X�e��k��q*��rD�~������9������?{�7��U��^��f���TLT�<�=FÇ�[���aqB��������{�
6.��ϰqa���z*3Ee&��ΗD[A�����w_������7[�o�$�Ʉ�. |?�V^�t�*��T���q�PjP���9�8\V�q��aD;�p��Q�n�:��ޅ�ɸ�y�� U�}H	����ҞI�	ND�޽���B7!��0�v�E�=����/Ϣ��c���������=��o�m~���u�j�~��<�ʭ-��0��)z�e��/�HJ<HY�<�!t�pj�i9�I˶�|s�^�+����6���@"N�(:5�!����1V��E ��0�&�Y�-�FK��h����t��a���;8��E=q��p�&V�xE+BD3\���	�fj��Û�����9���:�e;Ҵ���o-G��?R>�b�-u%�rm\�^���j��ӷ�[Wz��x�C������)�_�T��ϒE�e�����cb�Ԑچ	��*݉Z����6���6Su�`�����Fi�v��]�qQy�v��5�ٵ�1P����U�7J��ː1����pAj�� �yP�Ja)�\�*E�D�D����8�Ǉ?>=��׻rB�W�*�x
x����>~x�9H��,���A�m�V [�>�PSZ��	�� �7�6%Yѩ�#�/'���1�A�(�!��`���	\��ׯ�@k`�c�
�4 �����W\����}F(Mn�"�mٮ���Xγ�6DD �-�N�=a/@i�1�Sdg0=�/D#O��i8�|s�{��	+I6�E�(�hl`;�k
a�>�1>Q[9������\W%c�0_#��N��l���}����j��۾���P�� k��:�:��ۃJj$����q�zP��3�H���Y:],;��@�2[j�'��><����e���o�$���&�]~s�8��^�K$-E>*�g�HP�Vڴ��o	�NO�K/X�Q�n��]�}:}��b".)�p�Yn:��yw������;˳� ������BЕ��A�_�EY>�M��̏~͠F7�-5�e�Oো����D�1|�&�cِ��)��h�5Cj#~������0�<S"Z��,����}�yp�{�(Z�L@ٻ�*Q;`;�<<���i^G[>�Y�{>��_��4��E!�$�Rx
�{�B�>�H_��b�O�:&{Y#��ZΖ�6M2��m����
�k6Φ�+%AT�%��x�8�� ����>i�;���L���5�Q����1�p�=z�i�D��1	��g�P[�����	����W`��S 1�w���qx"Z�clx+ۉF�^�e�ο�w�;}�B��7��k�R'���.P�S� ol|&�8`�~�p:����L�4���,�y��R��aT������-��jsw�����Z����q�����7��1����?ߥ�V@J�@�(H�mx'M�ڃ���Ӈ� ����0�H�H	[�L&+���l����4��	[�u0P���vs�E#�^̕�7�}��N�j�:&/D�e�H����W�W����C}�@�7,[1 �ͫ{�f��Xb��u�����H�S��\쐿m�4���o6���D�U8����f��v49�������:��Q�G����`�A�!er"��lU�=u������v�1�볇[xyXC�o7����SW�������J!�HG��[�3xu��Y]�?�1l��V��@Y���I@�� <  b>s�ň0��;Q�u^=׾&Sڃ߯ASZ�)#�#�>?Lj�Q�������Ɩ�|[�
E�tH6���k���)�,%�D^�����8�ӷL�D|Z!(�VŰ��l`5jE�@����Q�@���	�d�Ͱ�e-<Rӵ��o*�ۮ1,��AE?c��bnL������M�:# m��w�a���.�]��W-�;���T�*�9�@�l��ΑA�t,�@��[�^ �c�|7H��E�ȶ�ڰ��%��GOp��"���.k�aℒ��(��T���?���N	���������r��)�j�*&kv��fl	t= .�|~��`-���n��\��Ow ���nvy�D�S_�f�(�� zmZ�r��I{�"�hS�D��N���|�����M��ƤqA��D�ヺ�[FЖ֣��s��9XN\��1����a����m7`)�zO�*K߿/�����˗/=2�E�"�d>�,��x��>��]�E�nѾ� p�P�CJG�^㢛��e�O�sN���A#�Q��`ؔ�m@r�uX/ݖ�*���ɗ�n�-�I�!�q>wLӽ6�i���3)S�R_�m�9��W_�1fI�!��P�"t���F�F=xP50Nq I��'*�L�a�J# %���]eUV�|I�NA�$,���rL$��B��>��Z��ȓЁM��'�"s5[�-ǀИ���mǪ�{�~�Y�xY�V)�,Ds��>T���98&"�sFsxۋ����/�v�ڋ����g���'G���k�*H�`4���֑��낅^b0�r���G���L"��7���} I�F� ��������!��usQN���y.��m%�:/>Ad3��v����g%�D��V���A0C��	J[߀��\S��w�n���w\⣄zo@����+\�0;���a��X�~K�I��Is���^�NmK��U�,�"���*�Cl&U�,F �k�����tʾ��m�q0$��-�v�\�A�q�d���cyК���������dvU.#���^�>D��OH�|[E��So �ؤf�M��:uF����N�љ��SaH+���;`@��y�j'�f�hrtξ�X�,�X�%/ʿ,�5�����Β�~�6Xe6�7���l1�P�oh �h��g��z27t�����(�y���qS�L���b~\�1{Y�%�<�J"%�M�窀�LQ�OV��&�`M��V-1T�P��d���%ń�J�(�,P�ٶVۿg`DF�{�|ECC�'5���9܎y�6�n�z�Xo���SG���S^������1['s?��t���,b^&x�~��X�⫼.3!���cae������J�{�o����m���żႃ�I�jۮ�[�����JS�g�-�v�; p=ն��,*B�<۳\m��ׇ�W-�<�̷���>�p�q�bCëv���BG��iM�����⮟%t�m���<�>�����cl�A��[�%q�8��|���J\H!������X�Ap�R�m��'5�<������b�p��4�H�+��lBT3�l,�����(�GK�b�Im��!U�xU2��Qʟ���+q�졋�q��2��{�
�Rۑ�x9�(��R%߁ �}7p{M9�THc��p��+�~���*_�����]��3��17#�o6�cq݃\z�k��yP*���v����(���Y�"�y�L�@�I�%
y��x��"��i�y =8!��xb�X*��(̥,�����a7PkU�_0/��/�&�t��E�S���N���Z<�hVa�2�������o���\��t�o��:p�@���C �`E�ȘhD)��_J������)�VBG%�D�3���7�&��"DYBҪ]Kk�sZXm�t�7�Ġ�$�<��l�Yra�T����c$����	&��91Z5V���W�жc��$��7ǟ��Nׂ�����'(�Q��}B�����0�R�x�Q .ٱ:>{u�R�����}������yŤJ;���\��b>�i8R��#<թ���2�!/�E�Z��{�D�'k�)k�R�l*s�clp���)�MĲD�Ev�����S'Q��*���18�{��ٔO�{d�hV d�pAŉM�詘d�l�F�,���"��q��N��R)`�KXz�������Ǒgz:6��.���=`�ޔP�m�Z!�bLt�'�-G�L#mR�.ڏ{Mt���>i�s>|�2f�W'���`�\�>>C��I1�; ;T���㎰���,��#�f��FD�����n�M��lWj�΃<���E<�%��s=BHS�&���'��g�����+����Jo����i{SOF5p�$w-E8?
�:��b ���3	��GΞ4r�г�+؎lB���Q]�cᄔ�1F�و��6��^�#����iO��=UA���-�>[Ln��c9�����%�1��Z��D����s�b��kc�"DQ%=UYު��1�b�,;3��T�#�yE�ڼb�m��:�^*m`/a��*E�!O3���oܑ�{JA2 �eAE��R�S������||�����-�uj���u�c�0��+�(���oX@}��c�xY�ӧ�NI�a���_�������pAE��B���Y9��rw@�Qw�����e����e�K<��@���kr-��G�������@ �:]�+GK����"]X����!Hڬ�>���t�uPI�po�0�#���㙊h�������냒���cC%h��Y�		+���s�.w�M'�)^w�{[�����>�_@_���]!�zT>��ھuԕ��S���# ��·X�E���
��0u�<!C5ZFo��#�W$S�,(�Գ��cQW޼ב�$���<~��[�{V-��Z�hH&����*X�T�F,1/�m��H�#fo1K��l�6����ɬ ��������I�c��d��: 8�3��(���I�E���� ���o�7��� �Lƿ��� �E��K��Y�L-�ѴY��x�����㠷��%~9���(x�H?�7���ɗ3E��qyjY��}�G7�Ұ|��R\y!����wY+s+>[���h�O&c�t6�R�l�dl��y��_��@�4���	:�7p��y�J(��[F/�B� 6X��T�d~��G��)U�EN�F
�zpl�����|���3�O�����Cw0�<i~.Oڬ�>�?�}�|�s��_�- ��i�>j���`&s\��_!r��Z�ǌK��?�p���/���F�G�QO�O2z�����T��Q�A;��(�<�M��wi���P�����`�fb;�BяgI&����m�+���^Fmr�&3�h��x�m�`��QQ҉�"��/��DS��&�)�"�EY��G���1�5��Nj_�u�԰Uc1H����S�i|��_��,Mq��
�T�?�QN�����	?������Rŉ'F1,�.���giu�krU����Ī�*����C4䂣�a�� o�$���+�O�)�*���;d1�G�I{�/��~�?ֿ��            x��]�r�6��=y
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
Ħ˪�(y� W	  �G����E[̑Tj����w��ވ��Z��T�W��~DB2�"
�ފ�?���7��?5/?!��Tt���EL�H�_�|5��YDb�Vk�#�*J�q��J*�����/l�_t����I��Z����@���4�t�K6B�cA1����;�EB��\�pww�9�`rl$T�nC/
E�0�OD��pr���Y�a3��Q�=5�����+�̸\n�+�H����2��,�b+P��uf+�`�6�]s�Q��h���,?�,�8��T����k�j�K��QԸ�(}0�h�8𠐏>�8�1���m���v�i�C�������W6����?J��$��Ӄ~�k��s�ݥ�G�)����Eg�+|i>!����J?d�z���1~���P�0�#�����J+����-}\d�_t;U)$ۍy��M1/W f�G-�s�����4��rw��7F�!�q�ckҢ���z���D�`\}�c ���*Ws��1,����ص�Ͽ~��&��϶=���X��ת�_��	.��� �jC�8&���[V�h?k�%וc�� �ǆTN+@%��Tt�FX�_�صl��46��{.V�R ?�z��"�؝y�WQl��l�?2�i_�t�. �`^l��� 1�7��5`���춛G��v����5
k"R��\��ژ�O�a��K3�A�R����<���7�v)sMҎ�(z �Ц*>\��p�0Ϟ��d���N0��3�r��%)��<����׼`,w��u���Q݁��]�7qI��$���-�I�ƥ?�%�Ԛ�e󶹦��AOImlk����JA�20��j����?��5�	%[�#Q^+�䛞�pA�����M'b0�����l�`�z^�	�u�?�J.�K��rQ�Q��m�+�8�*��1�c�N�ra}�9�7�.N�%Z��Z66t���U��^G��i�2ದ��hH
v���Kb [�*.�:�������	Y��m� 4��	�E�"�=�ՑH�$��W�ZfŎ���$������@��\8 ���}��$&K���T����c֘���s�{��)�,Kg���z�U�7���N��k"���|��c����Y}�2�17(ӓ�Y��o&�����!��˷����7��?S.�|.���ֽ)@�p{C�k_���IR�)'I�I���i��[��9���Q��@�1�\"�:j_#3��J��/2F=D���QAl㆔��a޺b��U^b��ŋg�NP��β7%Z�-�P��"~��)������V|�P|������)Ġr�b��z��=w��ӹAj�F�D$�f�������`ͪ�:�0s@ GV���
C�s��
S��Of�3W��p�(z�v��n��'��ܘ�Y�vy�� ���	��t���Qn3J�lO6�-,�tLÔ>�U�>{1�0�0��q�)N�D/�Y�����;�r�0*5�F��B>p����J	����P�,�������)� �F����Z~�R�eKEi�����bPE�.'ך*ofI|����$:O����I!�%�=���.�j�1#� $����LD�K�DB�g��	�%���敖�H�A�![Ϟ����:�^*#T��7;q�:m�����W�*�۝ �v�����Awq��ԏ�׏?͎����{-	�HK$T�w=���h����%	�E�_}o%V����mM"�$̢8EU�]��^��ՙ�+$�/f�$NQ��3���������5MA�q����1n����'F7��p�l�V�"y(��0�ݰ_��w��:�}��mJIf4� }px�h���ϭ+�˽x{�i)��So�8��>"�_P�l�@�C��H��t��^�P��0��7)@���e�3J+<<j��
��B����a�%��k�G������2��X�M%�Q�3�c�4)-%��v��b��n�J���" n���-L��K��,���fY��2��E�}�+�2��E�:+],bK�N=aYT�e�H�^�I\\߼Q�Dߌ�C�b��~��yOy��K��M���MI�zo�Do�<�U��Q�vtN�ae.�b�H~IjT��f�h7�('r���9�H��c������ys��\���49+RNf�-�X��0�#�[ˠ�<�)�q�+7䍏6�'������2)q�N�u��`(�䌋l%��{�.��A>���������	V�p�g����ʢ���v�YD��gXDɌQzy�g��Di�(�|��9PB�2�N���6������4�}�8F)g8�P��)oM�6jK���´L1Q$;hRU�rY��Lܖ��A��a���#ag�Mޙ�-=8rS�<�`O��29�2��3��Ә"ݐ����/�Q"            x������ � �         �   x�e�Q�0D��S�	����g�L��]�Ʋ%K!r{������f�E�IOaF�T�ғd�>a�ohh7����a$u�h.J�3�̉T����a�,cv�H�mR27}�*y♂k5�%|��:I���^�L*aL�z��ߖ��r���i�JK���xsF����>	-ߎ��q�3o�͑�콲־ Ƀt8         ,   x�3�tK,�U�MM�H��,N,����2��J�rS22�b���� ��         5   x�3��/-JMNU0�2������lc.8ۄ��6�2��͸��ls�=... �{�         �   x�]�K
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