PGDMP     	    *                y            oaic    13.2    13.2    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    33602    oaic    DATABASE     `   CREATE DATABASE oaic WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_India.1252';
    DROP DATABASE oaic;
                postgres    false                       1259    51443    sequence_increase_demo    SEQUENCE     ~   CREATE SEQUENCE public.sequence_increase_demo
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.sequence_increase_demo;
       public          postgres    false                       1259    51435    SequenceDemo    TABLE     �   CREATE TABLE public."SequenceDemo" (
    "UniqueID" character varying DEFAULT (('VR'::text || date_part('year'::text, CURRENT_DATE)) || nextval('public.sequence_increase_demo'::regclass)) NOT NULL,
    "Name" character varying
);
 "   DROP TABLE public."SequenceDemo";
       public         heap    postgres    false    268                        1259    42998    StateMaster    TABLE     y   CREATE TABLE public."StateMaster" (
    "StateCode" integer NOT NULL,
    "StateName" character varying(255) NOT NULL
);
 !   DROP TABLE public."StateMaster";
       public         heap    postgres    false                       1259    51321    VendorBankAccount    TABLE     j  CREATE TABLE public."VendorBankAccount" (
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
       public         heap    postgres    false                       1259    51319 #   VendorBankAccount_BankAccountID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorBankAccount_BankAccountID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public."VendorBankAccount_BankAccountID_seq";
       public          postgres    false    263            �           0    0 #   VendorBankAccount_BankAccountID_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public."VendorBankAccount_BankAccountID_seq" OWNED BY public."VendorBankAccount"."BankAccountID";
          public          postgres    false    262                       1259    51284    VendorContactPerson    TABLE     �  CREATE TABLE public."VendorContactPerson" (
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
       public         heap    postgres    false                       1259    51282 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorContactPerson_ContactPersonID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 @   DROP SEQUENCE public."VendorContactPerson_ContactPersonID_seq";
       public          postgres    false    259            �           0    0 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE public."VendorContactPerson_ContactPersonID_seq" OWNED BY public."VendorContactPerson"."ContactPersonID";
          public          postgres    false    258            	           1259    51348    VendorDistrictMapping    TABLE     �   CREATE TABLE public."VendorDistrictMapping" (
    "VendorID" character varying(255) NOT NULL,
    "DistrictID" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL
);
 +   DROP TABLE public."VendorDistrictMapping";
       public         heap    postgres    false                       1259    51271    VendorMaster    TABLE       CREATE TABLE public."VendorMaster" (
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
    "Turnover1" character varying,
    "Turnover2" character varying,
    "Turnover3" character varying,
    "Password" character varying
);
 "   DROP TABLE public."VendorMaster";
       public         heap    postgres    false                       1259    51300    VendorPrincipalPlace    TABLE     �  CREATE TABLE public."VendorPrincipalPlace" (
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
       public         heap    postgres    false                       1259    51298 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 B   DROP SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq";
       public          postgres    false    261            �           0    0 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq" OWNED BY public."VendorPrincipalPlace"."PrincipalPlaceID";
          public          postgres    false    260                       1259    51335    VendorServices    TABLE     �   CREATE TABLE public."VendorServices" (
    "VendorID" character varying(255) NOT NULL,
    "Service" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255) NOT NULL
);
 $   DROP TABLE public."VendorServices";
       public         heap    postgres    false            �            1259    33603 
   acc_master    TABLE     c  CREATE TABLE public.acc_master (
    acc_name character varying(225),
    acc_id character varying(30) NOT NULL,
    dist_id character varying(2) NOT NULL,
    dist_name character varying(30),
    acc_address character varying(1000),
    acc_mobile_no character varying(15),
    "UpdateOn" timestamp without time zone,
    "UpdateBy" character varying
);
    DROP TABLE public.acc_master;
       public         heap    postgres    false            �            1259    33609    approval    TABLE     H  CREATE TABLE public.approval (
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
       public         heap    postgres    false            �            1259    33615    approval_desc    TABLE     �   CREATE TABLE public.approval_desc (
    approval_id character varying(30) NOT NULL,
    permit_no character varying(50) NOT NULL,
    serial integer NOT NULL,
    mrr_id character varying
);
 !   DROP TABLE public.approval_desc;
       public         heap    postgres    false            �            1259    33621    approval_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.approval_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.approval_desc_serial_seq;
       public          postgres    false    202            �           0    0    approval_desc_serial_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.approval_desc_serial_seq OWNED BY public.approval_desc.serial;
          public          postgres    false    203            �            1259    33623    approval_status_desc    TABLE     ~   CREATE TABLE public.approval_status_desc (
    status_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
 (   DROP TABLE public.approval_status_desc;
       public         heap    postgres    false            �            1259    33626 
   components    TABLE     �   CREATE TABLE public.components (
    comp_id character varying(10) NOT NULL,
    schema_id character varying(10),
    comp_name character varying(30)
);
    DROP TABLE public.components;
       public         heap    postgres    false            �            1259    33629    dept_expenditure_payment_desc    TABLE     �  CREATE TABLE public.dept_expenditure_payment_desc (
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
       public         heap    postgres    false            �            1259    33632    govt_share_config    TABLE     �   CREATE TABLE public.govt_share_config (
    sl integer NOT NULL,
    fin_year character varying(10),
    head character varying(30),
    govt_share_ammount integer
);
 %   DROP TABLE public.govt_share_config;
       public         heap    postgres    false            �            1259    33635    dept_money_config_sl_seq    SEQUENCE     �   CREATE SEQUENCE public.dept_money_config_sl_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.dept_money_config_sl_seq;
       public          postgres    false    207            �           0    0    dept_money_config_sl_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.dept_money_config_sl_seq OWNED BY public.govt_share_config.sl;
          public          postgres    false    208            �            1259    33637    dist_dealer_mapping    TABLE     �   CREATE TABLE public.dist_dealer_mapping (
    fin_year character varying(10) NOT NULL,
    dl_id character varying(30) NOT NULL,
    dist_id character varying(2) NOT NULL
);
 '   DROP TABLE public.dist_dealer_mapping;
       public         heap    postgres    false            �            1259    33640    dist_master    TABLE     t   CREATE TABLE public.dist_master (
    dist_id character varying(2) NOT NULL,
    dist_name character varying(20)
);
    DROP TABLE public.dist_master;
       public         heap    postgres    false            �            1259    33643    dl_item_map    TABLE     �   CREATE TABLE public.dl_item_map (
    fin_year character varying(10) NOT NULL,
    dl_id character varying(30) NOT NULL,
    implement character varying(50) NOT NULL,
    make character varying(100) NOT NULL,
    model character varying(200)
);
    DROP TABLE public.dl_item_map;
       public         heap    postgres    false            �            1259    33649 	   dl_master    TABLE     O  CREATE TABLE public.dl_master (
    dl_id character varying(20) NOT NULL,
    dl_name character varying(70),
    bank_name character varying(100),
    dl_ac_no character varying(30),
    dl_ifsc_code character varying(30),
    dl_mobile_no character varying(20),
    dl_email character varying(100),
    dl_address character varying(200),
    add_date date,
    modify_date date,
    "LegalBussinessName" character varying,
    "TradeName" character varying,
    "PAN" bigint,
    "PANDocument" character varying,
    "BussinessConstitution" character varying,
    "GSTNNo" character varying,
    "GSTNDocument" character varying,
    "IncorporationDate" date,
    "ContactNumber" bigint,
    "EmailID" character varying,
    "InsertedDate" timestamp without time zone,
    "InsertedBy" character varying,
    "ModifiedDate" timestamp without time zone,
    "ModifiedBy" character varying,
    "IsDeleted" boolean DEFAULT false,
    "Password" character varying,
    "ApprovalStatus" character varying,
    "ApproveOrRejectDate" timestamp without time zone,
    "ApproveOrRejectBy" character varying
);
    DROP TABLE public.dl_master;
       public         heap    postgres    false            �            1259    33655 	   dm_master    TABLE       CREATE TABLE public.dm_master (
    dist_id character varying(2) NOT NULL,
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
    DROP TABLE public.dm_master;
       public         heap    postgres    false            �            1259    33661    farmer_receipt    TABLE     J  CREATE TABLE public.farmer_receipt (
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
       public         heap    postgres    false            �            1259    33664    farmer_receipts_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.farmer_receipts_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.farmer_receipts_sl_no_seq;
       public          postgres    false    214            �           0    0    farmer_receipts_sl_no_seq    SEQUENCE OWNED BY     V   ALTER SEQUENCE public.farmer_receipts_sl_no_seq OWNED BY public.farmer_receipt.sl_no;
          public          postgres    false    215            �            1259    33666    head_master    TABLE     u   CREATE TABLE public.head_master (
    head_id character varying(10) NOT NULL,
    head_name character varying(30)
);
    DROP TABLE public.head_master;
       public         heap    postgres    false            
           1259    51398    indent    TABLE     �  CREATE TABLE public.indent (
    indent_no character varying(255) NOT NULL,
    "PONo" character varying(255) NOT NULL,
    fin_year character varying(255) NOT NULL,
    "FinYear" character varying(255) NOT NULL,
    dist_id character varying(255) NOT NULL,
    "DistrictID" character varying(255) NOT NULL,
    "DMID" character varying(255) NOT NULL,
    "AccID" character varying(255) NOT NULL,
    dl_id character varying(255) NOT NULL,
    "VendorID" character varying(255) NOT NULL,
    "PermitNumber" character varying(255) NOT NULL,
    "FarmerID" character varying(255) NOT NULL,
    items character varying(255) DEFAULT 1 NOT NULL,
    "POAmount" character varying(255) NOT NULL,
    indent_ammount character varying(255) NOT NULL,
    status character varying(255) DEFAULT 'indentInitiated'::character varying NOT NULL,
    "Status" character varying(255) DEFAULT 'indentInitiated'::character varying NOT NULL,
    indent_date timestamp with time zone NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255) NOT NULL,
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255),
    "IsApproved" boolean DEFAULT false NOT NULL,
    "ApprovalStatus" character varying(255) DEFAULT 'Pending'::character varying NOT NULL,
    "ApprovedDate" timestamp with time zone,
    "ApprovedBy" character varying(255),
    "IsDeleted" boolean DEFAULT false NOT NULL,
    "DeletedDate" timestamp with time zone,
    "DeletedBy" character varying(255),
    "IsCancelled" boolean DEFAULT false NOT NULL,
    "CancellationStatus" character varying(255),
    "CancelledDate" timestamp with time zone,
    "CancelledBy" character varying(255)
);
    DROP TABLE public.indent;
       public         heap    postgres    false            �            1259    33672    indent_desc    TABLE     �   CREATE TABLE public.indent_desc (
    indent_no character varying(30) NOT NULL,
    permit_no character varying(50) NOT NULL
);
    DROP TABLE public.indent_desc;
       public         heap    postgres    false            �            1259    33669 
   indent_old    TABLE     �  CREATE TABLE public.indent_old (
    sl_no integer NOT NULL,
    indent_no character varying(50) NOT NULL,
    dist_id character varying(2) NOT NULL,
    indent_date timestamp without time zone NOT NULL,
    dl_id character varying(50) NOT NULL,
    fin_year character varying(10) NOT NULL,
    status character varying(30) NOT NULL,
    items integer NOT NULL,
    indent_ammount integer NOT NULL
);
    DROP TABLE public.indent_old;
       public         heap    postgres    false            �            1259    33675    indents_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.indents_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.indents_sl_no_seq;
       public          postgres    false    217            �           0    0    indents_sl_no_seq    SEQUENCE OWNED BY     J   ALTER SEQUENCE public.indents_sl_no_seq OWNED BY public.indent_old.sl_no;
          public          postgres    false    219            �            1259    33677    invoice    TABLE     �  CREATE TABLE public.invoice (
    sl_no integer NOT NULL,
    invoice_no character varying(30) NOT NULL,
    invoice_date timestamp without time zone,
    rr_way_bill_no character varying(30),
    wagon_truck_no character varying(30),
    challan_no character varying(30),
    challan_date date,
    fin_year character varying(10),
    dist_id character varying(2),
    dl_id character varying(50),
    bill_no character varying(10),
    bill_date date,
    status character varying(30),
    rr_way_bill_date date,
    discount character varying(10),
    indent_no character varying(30),
    payment_status character varying(30),
    items integer,
    invoice_ammount numeric(100,10),
    invoice_path character varying(270),
    gst_rate integer
);
    DROP TABLE public.invoice;
       public         heap    postgres    false            �            1259    33683    invoice_desc    TABLE     �   CREATE TABLE public.invoice_desc (
    invoice_no character varying(30) NOT NULL,
    permit_no character varying(50) NOT NULL
);
     DROP TABLE public.invoice_desc;
       public         heap    postgres    false            �            1259    33686    invoice_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.invoice_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.invoice_sl_no_seq;
       public          postgres    false    220            �           0    0    invoice_sl_no_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.invoice_sl_no_seq OWNED BY public.invoice.sl_no;
          public          postgres    false    222            �            1259    33691    item_price_map_1    TABLE     �  CREATE TABLE public.item_price_map_1 (
    implement character varying(100) NOT NULL,
    make character varying(100) NOT NULL,
    model character varying(300) NOT NULL,
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
    add_date timestamp without time zone,
    update_date timestamp without time zone,
    "InsertedDate" character varying,
    "InsertedBy" character varying,
    "UpdatedDate" character varying,
    "UpdatedBy" character varying,
    "PurchaseCGST" numeric(10,2),
    "PurchaseSGST" numeric(10,2),
    "PurchaseInvoiceValue" numeric(10,2),
    "PurchaseTaxableValue" numeric(10,2),
    "PurchaseIGST" numeric(10,2),
    "PurchaseSGSTOnePercent" numeric(10,2),
    "PurchaseCGSTOnePercent" numeric(10,2),
    "SellCGST" numeric(10,2),
    "SellSGST" numeric(10,2),
    "SellIGST" numeric(10,2),
    "SellInvoiceValue" numeric(10,2),
    "SellTaxableValue" numeric(10,2),
    "TaxRate" character varying,
    "Taxability" character varying,
    "GSTApplicability" character varying,
    "UnitOfMeasurement" character varying,
    "HSN" character varying,
    "Division" character varying,
    "Implement" character varying,
    "Make" character varying,
    "Model" character varying
);
 $   DROP TABLE public.item_price_map_1;
       public         heap    postgres    false            �            1259    33697 !   jalanidhi_dept_expnd_payment_desc    TABLE     �   CREATE TABLE public.jalanidhi_dept_expnd_payment_desc (
    serial integer NOT NULL,
    transaction_id character varying(50),
    scheme_id character varying(10),
    scheme_name character varying(50),
    comp_id character varying(10)
);
 5   DROP TABLE public.jalanidhi_dept_expnd_payment_desc;
       public         heap    postgres    false            �            1259    33700 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 C   DROP SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq;
       public          postgres    false    224            �           0    0 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq OWNED BY public.jalanidhi_dept_expnd_payment_desc.serial;
          public          postgres    false    225            �            1259    33702    jalanidhi_payment_desc    TABLE     N  CREATE TABLE public.jalanidhi_payment_desc (
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
       public         heap    postgres    false            �            1259    33705 !   jalanidhi_payment_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jalanidhi_payment_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.jalanidhi_payment_desc_serial_seq;
       public          postgres    false    226            �           0    0 !   jalanidhi_payment_desc_serial_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.jalanidhi_payment_desc_serial_seq OWNED BY public.jalanidhi_payment_desc.serial;
          public          postgres    false    227            �            1259    33707    jn_expenditure_desc    TABLE     �   CREATE TABLE public.jn_expenditure_desc (
    transaction_id character varying(70) NOT NULL,
    item_name character varying(50) NOT NULL,
    item_price numeric(10,5) NOT NULL,
    quantity integer NOT NULL,
    serial integer NOT NULL
);
 '   DROP TABLE public.jn_expenditure_desc;
       public         heap    postgres    false            �            1259    33710    jn_expenditure_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jn_expenditure_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.jn_expenditure_desc_serial_seq;
       public          postgres    false    228            �           0    0    jn_expenditure_desc_serial_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.jn_expenditure_desc_serial_seq OWNED BY public.jn_expenditure_desc.serial;
          public          postgres    false    229            �            1259    33712 	   jn_orders    TABLE     ~  CREATE TABLE public.jn_orders (
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
       public         heap    postgres    false            �            1259    33715    jn_stock    TABLE     �  CREATE TABLE public.jn_stock (
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
       public         heap    postgres    false            �            1259    33721    lgd_block_master    TABLE     �   CREATE TABLE public.lgd_block_master (
    dist_code character varying(500),
    block_code character varying(20) NOT NULL,
    block_name character varying(200)
);
 $   DROP TABLE public.lgd_block_master;
       public         heap    postgres    false            �            1259    33727    lgd_dist_master    TABLE     |   CREATE TABLE public.lgd_dist_master (
    dist_code character varying(20) NOT NULL,
    dist_name character varying(200)
);
 #   DROP TABLE public.lgd_dist_master;
       public         heap    postgres    false            �            1259    33730    lgd_gp_master    TABLE     �   CREATE TABLE public.lgd_gp_master (
    dist_code character varying(20),
    block_code character varying(20),
    gp_code character varying(20) NOT NULL,
    gp_name character varying(100)
);
 !   DROP TABLE public.lgd_gp_master;
       public         heap    postgres    false            �            1259    33733    log    TABLE     �  CREATE TABLE public.log (
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
       public         heap    postgres    false            �            1259    33739    log_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.log_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.log_sl_no_seq;
       public          postgres    false    235            �           0    0    log_sl_no_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.log_sl_no_seq OWNED BY public.log.sl_no;
          public          postgres    false    236            �            1259    33741    mrr    TABLE     g  CREATE TABLE public.mrr (
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
       public         heap    postgres    false            �            1259    33744    mrr_desc    TABLE     z   CREATE TABLE public.mrr_desc (
    mrr_id character varying(30) NOT NULL,
    permit_no character varying(40) NOT NULL
);
    DROP TABLE public.mrr_desc;
       public         heap    postgres    false            �            1259    33747    mrr_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.mrr_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.mrr_sl_no_seq;
       public          postgres    false    237            �           0    0    mrr_sl_no_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.mrr_sl_no_seq OWNED BY public.mrr.sl_no;
          public          postgres    false    239            �            1259    33749    new_item_price    TABLE     ?  CREATE TABLE public.new_item_price (
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
       public         heap    postgres    false            �            1259    33755    opening_balance    TABLE     e  CREATE TABLE public.opening_balance (
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
       public         heap    postgres    false            �            1259    33761    orders    TABLE     n  CREATE TABLE public.orders (
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
    order_type character varying(30)
);
    DROP TABLE public.orders;
       public         heap    postgres    false            �            1259    33767    payment    TABLE     .  CREATE TABLE public.payment (
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
       public         heap    postgres    false            �            1259    33770    payment1_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment1_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.payment1_sl_no_seq;
       public          postgres    false    243            �           0    0    payment1_sl_no_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.payment1_sl_no_seq OWNED BY public.payment.sl_no;
          public          postgres    false    244            �            1259    33772    payment_desc    TABLE     �   CREATE TABLE public.payment_desc (
    transaction_id character varying(70) NOT NULL,
    reference_no character varying(70) NOT NULL
);
     DROP TABLE public.payment_desc;
       public         heap    postgres    false            �            1259    33775    payment_desc_2_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_desc_2_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.payment_desc_2_sl_no_seq;
       public          postgres    false    206            �           0    0    payment_desc_2_sl_no_seq    SEQUENCE OWNED BY     d   ALTER SEQUENCE public.payment_desc_2_sl_no_seq OWNED BY public.dept_expenditure_payment_desc.sl_no;
          public          postgres    false    246            �            1259    33777    payment_invoice_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_invoice_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.payment_invoice_sl_no_seq;
       public          postgres    false    201            �           0    0    payment_invoice_sl_no_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.payment_invoice_sl_no_seq OWNED BY public.approval.sl_no;
          public          postgres    false    247            �            1259    33779    payment_purpose_desc    TABLE        CREATE TABLE public.payment_purpose_desc (
    purpose_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
 (   DROP TABLE public.payment_purpose_desc;
       public         heap    postgres    false            �            1259    33782    schem_master    TABLE     x   CREATE TABLE public.schem_master (
    schem_id character varying(10) NOT NULL,
    schem_name character varying(30)
);
     DROP TABLE public.schem_master;
       public         heap    postgres    false            �            1259    33785    source_master    TABLE     {   CREATE TABLE public.source_master (
    source_id character varying(10) NOT NULL,
    source_name character varying(30)
);
 !   DROP TABLE public.source_master;
       public         heap    postgres    false            �            1259    33788    subheads    TABLE     �   CREATE TABLE public.subheads (
    subhead_id character varying(10) NOT NULL,
    head_id character varying(10),
    subhead_name character varying(30)
);
    DROP TABLE public.subheads;
       public         heap    postgres    false            �            1259    33791    system_desc    TABLE     u   CREATE TABLE public.system_desc (
    system_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
    DROP TABLE public.system_desc;
       public         heap    postgres    false            �            1259    33794 
   tax_config    TABLE     r   CREATE TABLE public.tax_config (
    tax_mode character varying(2) NOT NULL,
    "desc" character varying(100)
);
    DROP TABLE public.tax_config;
       public         heap    postgres    false            �            1259    33797    users    TABLE     �   CREATE TABLE public.users (
    user_id character varying(225) NOT NULL,
    password character varying(300) NOT NULL,
    role character varying(20) NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    33800    vender_master    TABLE     '  CREATE TABLE public.vender_master (
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
       public         heap    postgres    false            8           2604    51324    VendorBankAccount BankAccountID    DEFAULT     �   ALTER TABLE ONLY public."VendorBankAccount" ALTER COLUMN "BankAccountID" SET DEFAULT nextval('public."VendorBankAccount_BankAccountID_seq"'::regclass);
 R   ALTER TABLE public."VendorBankAccount" ALTER COLUMN "BankAccountID" DROP DEFAULT;
       public          postgres    false    263    262    263            6           2604    51287 #   VendorContactPerson ContactPersonID    DEFAULT     �   ALTER TABLE ONLY public."VendorContactPerson" ALTER COLUMN "ContactPersonID" SET DEFAULT nextval('public."VendorContactPerson_ContactPersonID_seq"'::regclass);
 V   ALTER TABLE public."VendorContactPerson" ALTER COLUMN "ContactPersonID" DROP DEFAULT;
       public          postgres    false    258    259    259            7           2604    51303 %   VendorPrincipalPlace PrincipalPlaceID    DEFAULT     �   ALTER TABLE ONLY public."VendorPrincipalPlace" ALTER COLUMN "PrincipalPlaceID" SET DEFAULT nextval('public."VendorPrincipalPlace_PrincipalPlaceID_seq"'::regclass);
 X   ALTER TABLE public."VendorPrincipalPlace" ALTER COLUMN "PrincipalPlaceID" DROP DEFAULT;
       public          postgres    false    260    261    261            %           2604    33806    approval sl_no    DEFAULT     w   ALTER TABLE ONLY public.approval ALTER COLUMN sl_no SET DEFAULT nextval('public.payment_invoice_sl_no_seq'::regclass);
 =   ALTER TABLE public.approval ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    247    201            &           2604    33807    approval_desc serial    DEFAULT     |   ALTER TABLE ONLY public.approval_desc ALTER COLUMN serial SET DEFAULT nextval('public.approval_desc_serial_seq'::regclass);
 C   ALTER TABLE public.approval_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    203    202            '           2604    33808 #   dept_expenditure_payment_desc sl_no    DEFAULT     �   ALTER TABLE ONLY public.dept_expenditure_payment_desc ALTER COLUMN sl_no SET DEFAULT nextval('public.payment_desc_2_sl_no_seq'::regclass);
 R   ALTER TABLE public.dept_expenditure_payment_desc ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    246    206            *           2604    33809    farmer_receipt sl_no    DEFAULT     }   ALTER TABLE ONLY public.farmer_receipt ALTER COLUMN sl_no SET DEFAULT nextval('public.farmer_receipts_sl_no_seq'::regclass);
 C   ALTER TABLE public.farmer_receipt ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    215    214            (           2604    33810    govt_share_config sl    DEFAULT     |   ALTER TABLE ONLY public.govt_share_config ALTER COLUMN sl SET DEFAULT nextval('public.dept_money_config_sl_seq'::regclass);
 C   ALTER TABLE public.govt_share_config ALTER COLUMN sl DROP DEFAULT;
       public          postgres    false    208    207            +           2604    33811    indent_old sl_no    DEFAULT     q   ALTER TABLE ONLY public.indent_old ALTER COLUMN sl_no SET DEFAULT nextval('public.indents_sl_no_seq'::regclass);
 ?   ALTER TABLE public.indent_old ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    219    217            ,           2604    33812    invoice sl_no    DEFAULT     n   ALTER TABLE ONLY public.invoice ALTER COLUMN sl_no SET DEFAULT nextval('public.invoice_sl_no_seq'::regclass);
 <   ALTER TABLE public.invoice ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    222    220            -           2604    33813 (   jalanidhi_dept_expnd_payment_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc ALTER COLUMN serial SET DEFAULT nextval('public.jalanidhi_dept_expnd_payment_desc_serial_seq'::regclass);
 W   ALTER TABLE public.jalanidhi_dept_expnd_payment_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    225    224            .           2604    33814    jalanidhi_payment_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jalanidhi_payment_desc ALTER COLUMN serial SET DEFAULT nextval('public.jalanidhi_payment_desc_serial_seq'::regclass);
 L   ALTER TABLE public.jalanidhi_payment_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    227    226            /           2604    33815    jn_expenditure_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jn_expenditure_desc ALTER COLUMN serial SET DEFAULT nextval('public.jn_expenditure_desc_serial_seq'::regclass);
 I   ALTER TABLE public.jn_expenditure_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    229    228            0           2604    33816 	   log sl_no    DEFAULT     f   ALTER TABLE ONLY public.log ALTER COLUMN sl_no SET DEFAULT nextval('public.log_sl_no_seq'::regclass);
 8   ALTER TABLE public.log ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    236    235            1           2604    33817 	   mrr sl_no    DEFAULT     f   ALTER TABLE ONLY public.mrr ALTER COLUMN sl_no SET DEFAULT nextval('public.mrr_sl_no_seq'::regclass);
 8   ALTER TABLE public.mrr ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    239    237            2           2604    33818    payment sl_no    DEFAULT     o   ALTER TABLE ONLY public.payment ALTER COLUMN sl_no SET DEFAULT nextval('public.payment1_sl_no_seq'::regclass);
 <   ALTER TABLE public.payment ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    244    243            �          0    51435    SequenceDemo 
   TABLE DATA           <   COPY public."SequenceDemo" ("UniqueID", "Name") FROM stdin;
    public          postgres    false    267   ΀      �          0    42998    StateMaster 
   TABLE DATA           A   COPY public."StateMaster" ("StateCode", "StateName") FROM stdin;
    public          postgres    false    256   �      �          0    51321    VendorBankAccount 
   TABLE DATA           �   COPY public."VendorBankAccount" ("VendorID", "BankAccountID", "AccountNumber", "AccountType", "BankName", "BranchName", "IFSCCode", "BankDocument", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    263   W�      �          0    51284    VendorContactPerson 
   TABLE DATA           �   COPY public."VendorContactPerson" ("VendorID", "ContactPersonID", "Name", "FathersName", "MobileNumber", "EmailID", "Designation", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    259   �      �          0    51348    VendorDistrictMapping 
   TABLE DATA           [   COPY public."VendorDistrictMapping" ("VendorID", "DistrictID", "InsertedDate") FROM stdin;
    public          postgres    false    265   <�      �          0    51271    VendorMaster 
   TABLE DATA           �  COPY public."VendorMaster" ("VendorID", "LegalBussinessName", "TradeName", "PAN", "PANDocument", "BussinessConstitution", "GSTN", "GSTNDocument", "IncorporationDate", "ContactNumber", "EmailID", "ApprovalStatus", "ApplyStatus", "InsertedDate", "InsertedBy", "IsDeleted", "ApproveOrRejectDate", "ApproveOrRejectBy", "WhetherSSIUnit", "WhetherMSME", "SSIUnitRegistrationCertificate", "MSMECertificate", "CoreBussinessActivity", "Turnover1", "Turnover2", "Turnover3", "Password") FROM stdin;
    public          postgres    false    257   ��      �          0    51300    VendorPrincipalPlace 
   TABLE DATA           �   COPY public."VendorPrincipalPlace" ("VendorID", "PrincipalPlaceID", "Country", "StateCode", "DistrictOrCity", "Pincode", "Address", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    261   Ό      �          0    51335    VendorServices 
   TABLE DATA           _   COPY public."VendorServices" ("VendorID", "Service", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    264   ލ      K          0    33603 
   acc_master 
   TABLE DATA           ~   COPY public.acc_master (acc_name, acc_id, dist_id, dist_name, acc_address, acc_mobile_no, "UpdateOn", "UpdateBy") FROM stdin;
    public          postgres    false    200   }�      L          0    33609    approval 
   TABLE DATA           $  COPY public.approval (sl_no, invoice_no, fin_year, dist_id, dl_id, status, approval_id, indent_no, approval_date, ammount, transaction_id, deduction_amount, pay_now_amount, payment_status, remark, dl_remark, paid_amount, pp_id, pp_status, dm_approved_on, bank_approved_on, items) FROM stdin;
    public          postgres    false    201   L�      M          0    33615    approval_desc 
   TABLE DATA           O   COPY public.approval_desc (approval_id, permit_no, serial, mrr_id) FROM stdin;
    public          postgres    false    202   ��      O          0    33623    approval_status_desc 
   TABLE DATA           A   COPY public.approval_status_desc (status_id, "desc") FROM stdin;
    public          postgres    false    204   �      P          0    33626 
   components 
   TABLE DATA           C   COPY public.components (comp_id, schema_id, comp_name) FROM stdin;
    public          postgres    false    205   k�      Q          0    33629    dept_expenditure_payment_desc 
   TABLE DATA           �   COPY public.dept_expenditure_payment_desc (sl_no, reference_no, transaction_id, source_id, schem_id, comp_id, head_id, subhead_id, head_name, subhead_name, sd_path) FROM stdin;
    public          postgres    false    206   �      T          0    33637    dist_dealer_mapping 
   TABLE DATA           G   COPY public.dist_dealer_mapping (fin_year, dl_id, dist_id) FROM stdin;
    public          postgres    false    209   �      U          0    33640    dist_master 
   TABLE DATA           9   COPY public.dist_master (dist_id, dist_name) FROM stdin;
    public          postgres    false    210   �      V          0    33643    dl_item_map 
   TABLE DATA           N   COPY public.dl_item_map (fin_year, dl_id, implement, make, model) FROM stdin;
    public          postgres    false    211   ��      W          0    33649 	   dl_master 
   TABLE DATA           �  COPY public.dl_master (dl_id, dl_name, bank_name, dl_ac_no, dl_ifsc_code, dl_mobile_no, dl_email, dl_address, add_date, modify_date, "LegalBussinessName", "TradeName", "PAN", "PANDocument", "BussinessConstitution", "GSTNNo", "GSTNDocument", "IncorporationDate", "ContactNumber", "EmailID", "InsertedDate", "InsertedBy", "ModifiedDate", "ModifiedBy", "IsDeleted", "Password", "ApprovalStatus", "ApproveOrRejectDate", "ApproveOrRejectBy") FROM stdin;
    public          postgres    false    212   �      X          0    33655 	   dm_master 
   TABLE DATA           �   COPY public.dm_master (dist_id, dist_name, dm_id, dm_name, dm_address, dm_mobile_no, "UpdateOn", "UpdateBy", "EmailID", "BankName", "BranchName", "AccountNumber", "IFSCCode") FROM stdin;
    public          postgres    false    213   ��      Y          0    33661    farmer_receipt 
   TABLE DATA           �   COPY public.farmer_receipt (sl_no, receipt_no, fin_year, farmer_name, farmer_id, full_ammount, permit_no, implement, payment_mode, payment_no, source_bank, date, dist_id, office, payment_date) FROM stdin;
    public          postgres    false    214   ��      R          0    33632    govt_share_config 
   TABLE DATA           S   COPY public.govt_share_config (sl, fin_year, head, govt_share_ammount) FROM stdin;
    public          postgres    false    207   ^�      [          0    33666    head_master 
   TABLE DATA           9   COPY public.head_master (head_id, head_name) FROM stdin;
    public          postgres    false    216   ��      �          0    51398    indent 
   TABLE DATA           �  COPY public.indent (indent_no, "PONo", fin_year, "FinYear", dist_id, "DistrictID", "DMID", "AccID", dl_id, "VendorID", "PermitNumber", "FarmerID", items, "POAmount", indent_ammount, status, "Status", indent_date, "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsApproved", "ApprovalStatus", "ApprovedDate", "ApprovedBy", "IsDeleted", "DeletedDate", "DeletedBy", "IsCancelled", "CancellationStatus", "CancelledDate", "CancelledBy") FROM stdin;
    public          postgres    false    266   ��      ]          0    33672    indent_desc 
   TABLE DATA           ;   COPY public.indent_desc (indent_no, permit_no) FROM stdin;
    public          postgres    false    218   =�      \          0    33669 
   indent_old 
   TABLE DATA           |   COPY public.indent_old (sl_no, indent_no, dist_id, indent_date, dl_id, fin_year, status, items, indent_ammount) FROM stdin;
    public          postgres    false    217   ��      _          0    33677    invoice 
   TABLE DATA             COPY public.invoice (sl_no, invoice_no, invoice_date, rr_way_bill_no, wagon_truck_no, challan_no, challan_date, fin_year, dist_id, dl_id, bill_no, bill_date, status, rr_way_bill_date, discount, indent_no, payment_status, items, invoice_ammount, invoice_path, gst_rate) FROM stdin;
    public          postgres    false    220   ��      `          0    33683    invoice_desc 
   TABLE DATA           =   COPY public.invoice_desc (invoice_no, permit_no) FROM stdin;
    public          postgres    false    221   �      b          0    33691    item_price_map_1 
   TABLE DATA           |  COPY public.item_price_map_1 (implement, make, model, p_taxable_value, p_cgst_6, p_sgst_6, p_cgst_1, p_sgst_1, p_invoice_value, s_taxable_value, s_cgst_6, s_sgst_6, s_invoice_value, p_igst_12, s_igst_12, add_date, update_date, "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "PurchaseCGST", "PurchaseSGST", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseIGST", "PurchaseSGSTOnePercent", "PurchaseCGSTOnePercent", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "TaxRate", "Taxability", "GSTApplicability", "UnitOfMeasurement", "HSN", "Division", "Implement", "Make", "Model") FROM stdin;
    public          postgres    false    223   ��      c          0    33697 !   jalanidhi_dept_expnd_payment_desc 
   TABLE DATA           t   COPY public.jalanidhi_dept_expnd_payment_desc (serial, transaction_id, scheme_id, scheme_name, comp_id) FROM stdin;
    public          postgres    false    224   �      e          0    33702    jalanidhi_payment_desc 
   TABLE DATA           �   COPY public.jalanidhi_payment_desc (transaction_id, farmer_id, farmer_name, implement, make, model, serial, project_id) FROM stdin;
    public          postgres    false    226   ��      g          0    33707    jn_expenditure_desc 
   TABLE DATA           f   COPY public.jn_expenditure_desc (transaction_id, item_name, item_price, quantity, serial) FROM stdin;
    public          postgres    false    228   q�      i          0    33712 	   jn_orders 
   TABLE DATA           {   COPY public.jn_orders (fin_year, dist_id, cluster_id, farmer_id, dist_name, farmer_name, status, date, system) FROM stdin;
    public          postgres    false    230   i       j          0    33715    jn_stock 
   TABLE DATA           �   COPY public.jn_stock (fin_year, dist_id, dl_id, system, po_no, cluster_id, farmer_id, farmer_name, implement, make, model, engine_no, chassic_no, status, receive_date, deliver_date, dl_name) FROM stdin;
    public          postgres    false    231   *      k          0    33721    lgd_block_master 
   TABLE DATA           M   COPY public.lgd_block_master (dist_code, block_code, block_name) FROM stdin;
    public          postgres    false    232   �      l          0    33727    lgd_dist_master 
   TABLE DATA           ?   COPY public.lgd_dist_master (dist_code, dist_name) FROM stdin;
    public          postgres    false    233   ,      m          0    33730    lgd_gp_master 
   TABLE DATA           P   COPY public.lgd_gp_master (dist_code, block_code, gp_code, gp_name) FROM stdin;
    public          postgres    false    234   3      n          0    33733    log 
   TABLE DATA           �   COPY public.log (sl_no, date_time, user_id, action, status, ref_url, route, ip, browser_name, browser_version, fin_year, remark) FROM stdin;
    public          postgres    false    235   ��      p          0    33741    mrr 
   TABLE DATA           v   COPY public.mrr (sl_no, mrr_id, dist_id, invoice_no, fin_year, dl_id, date, items, indent_no, mrr_amount) FROM stdin;
    public          postgres    false    237   b�      q          0    33744    mrr_desc 
   TABLE DATA           5   COPY public.mrr_desc (mrr_id, permit_no) FROM stdin;
    public          postgres    false    238   V�      s          0    33749    new_item_price 
   TABLE DATA           �   COPY public.new_item_price (implement, make, model, purchase_price, taxable_value, cgst_6, sags_6, invoice_alue, selling_price, sl_taxable_value, sl_cgst_6, sl_sgst_6, sl_invoice_value) FROM stdin;
    public          postgres    false    240   ��      t          0    33755    opening_balance 
   TABLE DATA           �   COPY public.opening_balance (fin_year, date, system, dist_id, transaction_id, ammount, remark, purpose, reference_no, "from", "to", head, subhead, payment_type, payment_date, payment_no, test) FROM stdin;
    public          postgres    false    241   U      u          0    33761    orders 
   TABLE DATA           �  COPY public.orders (permit_no, permit_issue_date, permit_validity, farmer_id, farmer_name, farmer_father_name, dist_name, block_name, gp_name, village_name, implement, make, model, status, permit_validity_1, permit_issue_date_1, fin_year, dist_id, engine_no, chassic_no, ammount, remark, expected_delivery_date, delivery_date, c_fin_year, date, system, paid_amount, order_type) FROM stdin;
    public          postgres    false    242   U      v          0    33767    payment 
   TABLE DATA           �   COPY public.payment (sl_no, date, reference_no, transaction_id, "from", "to", remark, payment_type, payment_no, fin_year, purpose, payment_date, ammount, status, system) FROM stdin;
    public          postgres    false    243   Y-      x          0    33772    payment_desc 
   TABLE DATA           D   COPY public.payment_desc (transaction_id, reference_no) FROM stdin;
    public          postgres    false    245   �B      {          0    33779    payment_purpose_desc 
   TABLE DATA           B   COPY public.payment_purpose_desc (purpose_id, "desc") FROM stdin;
    public          postgres    false    248   �B      |          0    33782    schem_master 
   TABLE DATA           <   COPY public.schem_master (schem_id, schem_name) FROM stdin;
    public          postgres    false    249   yC      }          0    33785    source_master 
   TABLE DATA           ?   COPY public.source_master (source_id, source_name) FROM stdin;
    public          postgres    false    250   �C      ~          0    33788    subheads 
   TABLE DATA           E   COPY public.subheads (subhead_id, head_id, subhead_name) FROM stdin;
    public          postgres    false    251   �C                0    33791    system_desc 
   TABLE DATA           8   COPY public.system_desc (system_id, "desc") FROM stdin;
    public          postgres    false    252   �D      �          0    33794 
   tax_config 
   TABLE DATA           6   COPY public.tax_config (tax_mode, "desc") FROM stdin;
    public          postgres    false    253   �D      �          0    33797    users 
   TABLE DATA           8   COPY public.users (user_id, password, role) FROM stdin;
    public          postgres    false    254   E      �          0    33800    vender_master 
   TABLE DATA              COPY public.vender_master ("VendorId", "VendorRegNo", "DateOfReg", "Name", "FarmName", "IsVerified", "IsReject", "RejectRemarkStausId", "UserName", "Password", "Type", "IPAddress", "FinancialYear", "UpdatedOn", "UpdatedBy", "DeletedOn", "DeletedBy", "IsUpdated", "IsDeleted") FROM stdin;
    public          postgres    false    255   ]G      �           0    0 #   VendorBankAccount_BankAccountID_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public."VendorBankAccount_BankAccountID_seq"', 17, true);
          public          postgres    false    262            �           0    0 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE SET     X   SELECT pg_catalog.setval('public."VendorContactPerson_ContactPersonID_seq"', 19, true);
          public          postgres    false    258            �           0    0 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE SET     Z   SELECT pg_catalog.setval('public."VendorPrincipalPlace_PrincipalPlaceID_seq"', 20, true);
          public          postgres    false    260            �           0    0    approval_desc_serial_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.approval_desc_serial_seq', 99, true);
          public          postgres    false    203            �           0    0    dept_money_config_sl_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.dept_money_config_sl_seq', 1, true);
          public          postgres    false    208            �           0    0    farmer_receipts_sl_no_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.farmer_receipts_sl_no_seq', 474, true);
          public          postgres    false    215            �           0    0    indents_sl_no_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.indents_sl_no_seq', 235, true);
          public          postgres    false    219            �           0    0    invoice_sl_no_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.invoice_sl_no_seq', 324, true);
          public          postgres    false    222            �           0    0 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE SET     [   SELECT pg_catalog.setval('public.jalanidhi_dept_expnd_payment_desc_serial_seq', 12, true);
          public          postgres    false    225            �           0    0 !   jalanidhi_payment_desc_serial_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.jalanidhi_payment_desc_serial_seq', 24, true);
          public          postgres    false    227            �           0    0    jn_expenditure_desc_serial_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.jn_expenditure_desc_serial_seq', 36, true);
          public          postgres    false    229            �           0    0    log_sl_no_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.log_sl_no_seq', 1911, true);
          public          postgres    false    236            �           0    0    mrr_sl_no_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.mrr_sl_no_seq', 206, true);
          public          postgres    false    239            �           0    0    payment1_sl_no_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.payment1_sl_no_seq', 1045, true);
          public          postgres    false    244            �           0    0    payment_desc_2_sl_no_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.payment_desc_2_sl_no_seq', 91, true);
          public          postgres    false    246            �           0    0    payment_invoice_sl_no_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.payment_invoice_sl_no_seq', 107, true);
          public          postgres    false    247            �           0    0    sequence_increase_demo    SEQUENCE SET     D   SELECT pg_catalog.setval('public.sequence_increase_demo', 4, true);
          public          postgres    false    268            �           2606    43002    StateMaster StateMaster_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public."StateMaster"
    ADD CONSTRAINT "StateMaster_pkey" PRIMARY KEY ("StateCode");
 J   ALTER TABLE ONLY public."StateMaster" DROP CONSTRAINT "StateMaster_pkey";
       public            postgres    false    256            �           2606    51329 (   VendorBankAccount VendorBankAccount_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."VendorBankAccount"
    ADD CONSTRAINT "VendorBankAccount_pkey" PRIMARY KEY ("BankAccountID");
 V   ALTER TABLE ONLY public."VendorBankAccount" DROP CONSTRAINT "VendorBankAccount_pkey";
       public            postgres    false    263            �           2606    51292 ,   VendorContactPerson VendorContactPerson_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public."VendorContactPerson"
    ADD CONSTRAINT "VendorContactPerson_pkey" PRIMARY KEY ("ContactPersonID");
 Z   ALTER TABLE ONLY public."VendorContactPerson" DROP CONSTRAINT "VendorContactPerson_pkey";
       public            postgres    false    259            �           2606    51355 0   VendorDistrictMapping VendorDistrictMapping_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_pkey" PRIMARY KEY ("VendorID", "DistrictID");
 ^   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_pkey";
       public            postgres    false    265    265            �           2606    51281    VendorMaster VendorMaster_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."VendorMaster"
    ADD CONSTRAINT "VendorMaster_pkey" PRIMARY KEY ("VendorID");
 L   ALTER TABLE ONLY public."VendorMaster" DROP CONSTRAINT "VendorMaster_pkey";
       public            postgres    false    257            �           2606    51308 .   VendorPrincipalPlace VendorPrincipalPlace_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_pkey" PRIMARY KEY ("PrincipalPlaceID");
 \   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_pkey";
       public            postgres    false    261            �           2606    51342 "   VendorServices VendorServices_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."VendorServices"
    ADD CONSTRAINT "VendorServices_pkey" PRIMARY KEY ("VendorID", "Service");
 P   ALTER TABLE ONLY public."VendorServices" DROP CONSTRAINT "VendorServices_pkey";
       public            postgres    false    264    264            B           2606    33820 "   acc_master accountants_master_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.acc_master
    ADD CONSTRAINT accountants_master_pkey PRIMARY KEY (acc_id, dist_id);
 L   ALTER TABLE ONLY public.acc_master DROP CONSTRAINT accountants_master_pkey;
       public            postgres    false    200    200            F           2606    33822     approval_desc approval_desc_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.approval_desc
    ADD CONSTRAINT approval_desc_pkey PRIMARY KEY (serial);
 J   ALTER TABLE ONLY public.approval_desc DROP CONSTRAINT approval_desc_pkey;
       public            postgres    false    202            H           2606    33824 .   approval_status_desc approval_status_desc_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.approval_status_desc
    ADD CONSTRAINT approval_status_desc_pkey PRIMARY KEY (status_id);
 X   ALTER TABLE ONLY public.approval_status_desc DROP CONSTRAINT approval_status_desc_pkey;
       public            postgres    false    204            J           2606    33826    components components_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.components
    ADD CONSTRAINT components_pkey PRIMARY KEY (comp_id);
 D   ALTER TABLE ONLY public.components DROP CONSTRAINT components_pkey;
       public            postgres    false    205            N           2606    33828 (   govt_share_config dept_money_config_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.govt_share_config
    ADD CONSTRAINT dept_money_config_pkey PRIMARY KEY (sl);
 R   ALTER TABLE ONLY public.govt_share_config DROP CONSTRAINT dept_money_config_pkey;
       public            postgres    false    207            P           2606    33830 &   dist_dealer_mapping dist_dl_map_1_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.dist_dealer_mapping
    ADD CONSTRAINT dist_dl_map_1_pkey PRIMARY KEY (fin_year, dl_id, dist_id);
 P   ALTER TABLE ONLY public.dist_dealer_mapping DROP CONSTRAINT dist_dl_map_1_pkey;
       public            postgres    false    209    209    209            R           2606    33832    dist_master dist_master_1_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.dist_master
    ADD CONSTRAINT dist_master_1_pkey PRIMARY KEY (dist_id);
 H   ALTER TABLE ONLY public.dist_master DROP CONSTRAINT dist_master_1_pkey;
       public            postgres    false    210            T           2606    33836    dl_item_map dl_item_map_2_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.dl_item_map
    ADD CONSTRAINT dl_item_map_2_pkey PRIMARY KEY (fin_year, dl_id, implement, make);
 H   ALTER TABLE ONLY public.dl_item_map DROP CONSTRAINT dl_item_map_2_pkey;
       public            postgres    false    211    211    211    211            V           2606    33838    dl_master dl_master_1_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.dl_master
    ADD CONSTRAINT dl_master_1_pkey PRIMARY KEY (dl_id);
 D   ALTER TABLE ONLY public.dl_master DROP CONSTRAINT dl_master_1_pkey;
       public            postgres    false    212            X           2606    33840    dm_master dm_master_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.dm_master
    ADD CONSTRAINT dm_master_pkey PRIMARY KEY (dm_id);
 B   ALTER TABLE ONLY public.dm_master DROP CONSTRAINT dm_master_pkey;
       public            postgres    false    213            Z           2606    33842 #   farmer_receipt farmer_receipts_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.farmer_receipt
    ADD CONSTRAINT farmer_receipts_pkey PRIMARY KEY (receipt_no);
 M   ALTER TABLE ONLY public.farmer_receipt DROP CONSTRAINT farmer_receipts_pkey;
       public            postgres    false    214            \           2606    33844    head_master head_master_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.head_master
    ADD CONSTRAINT head_master_pkey PRIMARY KEY (head_id);
 F   ALTER TABLE ONLY public.head_master DROP CONSTRAINT head_master_pkey;
       public            postgres    false    216            `           2606    33846    indent_desc indent_desc_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.indent_desc
    ADD CONSTRAINT indent_desc_pkey PRIMARY KEY (indent_no, permit_no);
 F   ALTER TABLE ONLY public.indent_desc DROP CONSTRAINT indent_desc_pkey;
       public            postgres    false    218    218            �           2606    51412    indent indent_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.indent
    ADD CONSTRAINT indent_pkey PRIMARY KEY (indent_no);
 <   ALTER TABLE ONLY public.indent DROP CONSTRAINT indent_pkey;
       public            postgres    false    266            ^           2606    33848    indent_old indents_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.indent_old
    ADD CONSTRAINT indents_pkey PRIMARY KEY (indent_no);
 A   ALTER TABLE ONLY public.indent_old DROP CONSTRAINT indents_pkey;
       public            postgres    false    217            d           2606    33850    invoice_desc invoice_desc_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.invoice_desc
    ADD CONSTRAINT invoice_desc_pkey PRIMARY KEY (invoice_no, permit_no);
 H   ALTER TABLE ONLY public.invoice_desc DROP CONSTRAINT invoice_desc_pkey;
       public            postgres    false    221    221            b           2606    33852    invoice invoice_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (invoice_no);
 >   ALTER TABLE ONLY public.invoice DROP CONSTRAINT invoice_pkey;
       public            postgres    false    220            f           2606    33856 '   item_price_map_1 item_price_map_1_pkey1 
   CONSTRAINT     y   ALTER TABLE ONLY public.item_price_map_1
    ADD CONSTRAINT item_price_map_1_pkey1 PRIMARY KEY (implement, make, model);
 Q   ALTER TABLE ONLY public.item_price_map_1 DROP CONSTRAINT item_price_map_1_pkey1;
       public            postgres    false    223    223    223            h           2606    33858 H   jalanidhi_dept_expnd_payment_desc jalanidhi_dept_expnd_payment_desc_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc
    ADD CONSTRAINT jalanidhi_dept_expnd_payment_desc_pkey PRIMARY KEY (serial);
 r   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc DROP CONSTRAINT jalanidhi_dept_expnd_payment_desc_pkey;
       public            postgres    false    224            j           2606    33860 2   jalanidhi_payment_desc jalanidhi_payment_desc_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.jalanidhi_payment_desc
    ADD CONSTRAINT jalanidhi_payment_desc_pkey PRIMARY KEY (serial);
 \   ALTER TABLE ONLY public.jalanidhi_payment_desc DROP CONSTRAINT jalanidhi_payment_desc_pkey;
       public            postgres    false    226            l           2606    33862 ,   jn_expenditure_desc jn_expenditure_desc_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.jn_expenditure_desc
    ADD CONSTRAINT jn_expenditure_desc_pkey PRIMARY KEY (serial);
 V   ALTER TABLE ONLY public.jn_expenditure_desc DROP CONSTRAINT jn_expenditure_desc_pkey;
       public            postgres    false    228            n           2606    33864    jn_orders jn_orders_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.jn_orders
    ADD CONSTRAINT jn_orders_pkey PRIMARY KEY (cluster_id, farmer_id);
 B   ALTER TABLE ONLY public.jn_orders DROP CONSTRAINT jn_orders_pkey;
       public            postgres    false    230    230            p           2606    33866    jn_stock jn_stock_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.jn_stock
    ADD CONSTRAINT jn_stock_pkey PRIMARY KEY (po_no, cluster_id, farmer_id, implement, make, model);
 @   ALTER TABLE ONLY public.jn_stock DROP CONSTRAINT jn_stock_pkey;
       public            postgres    false    231    231    231    231    231    231            r           2606    33868 &   lgd_block_master lgd_block_master_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.lgd_block_master
    ADD CONSTRAINT lgd_block_master_pkey PRIMARY KEY (block_code);
 P   ALTER TABLE ONLY public.lgd_block_master DROP CONSTRAINT lgd_block_master_pkey;
       public            postgres    false    232            t           2606    33870 $   lgd_dist_master lgd_dist_master_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.lgd_dist_master
    ADD CONSTRAINT lgd_dist_master_pkey PRIMARY KEY (dist_code);
 N   ALTER TABLE ONLY public.lgd_dist_master DROP CONSTRAINT lgd_dist_master_pkey;
       public            postgres    false    233            v           2606    33872     lgd_gp_master lgd_gp_master_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT lgd_gp_master_pkey PRIMARY KEY (gp_code);
 J   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT lgd_gp_master_pkey;
       public            postgres    false    234            x           2606    33874    log log_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (sl_no);
 6   ALTER TABLE ONLY public.log DROP CONSTRAINT log_pkey;
       public            postgres    false    235            |           2606    33876    mrr_desc mrr_desc_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_pkey PRIMARY KEY (mrr_id, permit_no);
 @   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_pkey;
       public            postgres    false    238    238            z           2606    33878    mrr mrr_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.mrr
    ADD CONSTRAINT mrr_pkey PRIMARY KEY (mrr_id);
 6   ALTER TABLE ONLY public.mrr DROP CONSTRAINT mrr_pkey;
       public            postgres    false    237            ~           2606    33880 "   new_item_price new_item_price_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.new_item_price
    ADD CONSTRAINT new_item_price_pkey PRIMARY KEY (implement, make, model);
 L   ALTER TABLE ONLY public.new_item_price DROP CONSTRAINT new_item_price_pkey;
       public            postgres    false    240    240    240            �           2606    33882 $   opening_balance opening_balance_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.opening_balance
    ADD CONSTRAINT opening_balance_pkey PRIMARY KEY (transaction_id);
 N   ALTER TABLE ONLY public.opening_balance DROP CONSTRAINT opening_balance_pkey;
       public            postgres    false    241            �           2606    33884    orders orders_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (permit_no);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    242            �           2606    33886    payment payment1_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment1_pkey PRIMARY KEY (transaction_id);
 ?   ALTER TABLE ONLY public.payment DROP CONSTRAINT payment1_pkey;
       public            postgres    false    243            L           2606    33888 1   dept_expenditure_payment_desc payment_desc_2_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.dept_expenditure_payment_desc
    ADD CONSTRAINT payment_desc_2_pkey PRIMARY KEY (sl_no);
 [   ALTER TABLE ONLY public.dept_expenditure_payment_desc DROP CONSTRAINT payment_desc_2_pkey;
       public            postgres    false    206            �           2606    33890    payment_desc payment_desc_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.payment_desc
    ADD CONSTRAINT payment_desc_pkey PRIMARY KEY (reference_no, transaction_id);
 H   ALTER TABLE ONLY public.payment_desc DROP CONSTRAINT payment_desc_pkey;
       public            postgres    false    245    245            D           2606    33892 !   approval payment_instruction_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.approval
    ADD CONSTRAINT payment_instruction_pkey PRIMARY KEY (sl_no);
 K   ALTER TABLE ONLY public.approval DROP CONSTRAINT payment_instruction_pkey;
       public            postgres    false    201            �           2606    33894 .   payment_purpose_desc payment_purpose_desc_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.payment_purpose_desc
    ADD CONSTRAINT payment_purpose_desc_pkey PRIMARY KEY (purpose_id);
 X   ALTER TABLE ONLY public.payment_purpose_desc DROP CONSTRAINT payment_purpose_desc_pkey;
       public            postgres    false    248            �           2606    33896    schem_master schema_master_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.schem_master
    ADD CONSTRAINT schema_master_pkey PRIMARY KEY (schem_id);
 I   ALTER TABLE ONLY public.schem_master DROP CONSTRAINT schema_master_pkey;
       public            postgres    false    249            �           2606    51442    SequenceDemo sequenceDemo_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."SequenceDemo"
    ADD CONSTRAINT "sequenceDemo_pkey" PRIMARY KEY ("UniqueID");
 L   ALTER TABLE ONLY public."SequenceDemo" DROP CONSTRAINT "sequenceDemo_pkey";
       public            postgres    false    267            �           2606    33898     source_master source_master_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.source_master
    ADD CONSTRAINT source_master_pkey PRIMARY KEY (source_id);
 J   ALTER TABLE ONLY public.source_master DROP CONSTRAINT source_master_pkey;
       public            postgres    false    250            �           2606    33900    subheads subhead_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.subheads
    ADD CONSTRAINT subhead_pkey PRIMARY KEY (subhead_id);
 ?   ALTER TABLE ONLY public.subheads DROP CONSTRAINT subhead_pkey;
       public            postgres    false    251            �           2606    33902    system_desc system_desc_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.system_desc
    ADD CONSTRAINT system_desc_pkey PRIMARY KEY (system_id);
 F   ALTER TABLE ONLY public.system_desc DROP CONSTRAINT system_desc_pkey;
       public            postgres    false    252            �           2606    33904    tax_config tax_config_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.tax_config
    ADD CONSTRAINT tax_config_pkey PRIMARY KEY (tax_mode);
 D   ALTER TABLE ONLY public.tax_config DROP CONSTRAINT tax_config_pkey;
       public            postgres    false    253            �           2606    51414    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    254            �           2606    33908     vender_master vender_master_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.vender_master
    ADD CONSTRAINT vender_master_pkey PRIMARY KEY ("VendorId");
 J   ALTER TABLE ONLY public.vender_master DROP CONSTRAINT vender_master_pkey;
       public            postgres    false    255            �           2606    33909    acc_master DISTID_F_KEY    FK CONSTRAINT     �   ALTER TABLE ONLY public.acc_master
    ADD CONSTRAINT "DISTID_F_KEY" FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 C   ALTER TABLE ONLY public.acc_master DROP CONSTRAINT "DISTID_F_KEY";
       public          postgres    false    210    200    3154            �           2606    33914    dm_master DIST_ID_F_KEY    FK CONSTRAINT     �   ALTER TABLE ONLY public.dm_master
    ADD CONSTRAINT "DIST_ID_F_KEY" FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 C   ALTER TABLE ONLY public.dm_master DROP CONSTRAINT "DIST_ID_F_KEY";
       public          postgres    false    210    213    3154            �           2606    33919    indent_old DLID_F_KEY    FK CONSTRAINT     �   ALTER TABLE ONLY public.indent_old
    ADD CONSTRAINT "DLID_F_KEY" FOREIGN KEY (dl_id) REFERENCES public.dl_master(dl_id) NOT VALID;
 A   ALTER TABLE ONLY public.indent_old DROP CONSTRAINT "DLID_F_KEY";
       public          postgres    false    212    217    3158            �           2606    51415    dm_master UPDATEBY_USERID_F_KEY    FK CONSTRAINT     �   ALTER TABLE ONLY public.dm_master
    ADD CONSTRAINT "UPDATEBY_USERID_F_KEY" FOREIGN KEY ("UpdateBy") REFERENCES public.users(user_id) NOT VALID;
 K   ALTER TABLE ONLY public.dm_master DROP CONSTRAINT "UPDATEBY_USERID_F_KEY";
       public          postgres    false    254    3220    213            �           2606    51420     acc_master UpdateBy_UserId_F_KEY    FK CONSTRAINT     �   ALTER TABLE ONLY public.acc_master
    ADD CONSTRAINT "UpdateBy_UserId_F_KEY" FOREIGN KEY ("UpdateBy") REFERENCES public.users(user_id) NOT VALID;
 L   ALTER TABLE ONLY public.acc_master DROP CONSTRAINT "UpdateBy_UserId_F_KEY";
       public          postgres    false    254    200    3220            �           2606    51330 1   VendorBankAccount VendorBankAccount_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorBankAccount"
    ADD CONSTRAINT "VendorBankAccount_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 _   ALTER TABLE ONLY public."VendorBankAccount" DROP CONSTRAINT "VendorBankAccount_VendorID_fkey";
       public          postgres    false    263    3226    257            �           2606    51293 5   VendorContactPerson VendorContactPerson_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorContactPerson"
    ADD CONSTRAINT "VendorContactPerson_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 c   ALTER TABLE ONLY public."VendorContactPerson" DROP CONSTRAINT "VendorContactPerson_VendorID_fkey";
       public          postgres    false    3226    259    257            �           2606    51361 ;   VendorDistrictMapping VendorDistrictMapping_DistrictID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_DistrictID_fkey" FOREIGN KEY ("DistrictID") REFERENCES public.dist_master(dist_id) ON UPDATE CASCADE;
 i   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_DistrictID_fkey";
       public          postgres    false    3154    265    210            �           2606    51356 9   VendorDistrictMapping VendorDistrictMapping_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 g   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_VendorID_fkey";
       public          postgres    false    265    3226    257            �           2606    51314 8   VendorPrincipalPlace VendorPrincipalPlace_StateCode_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_StateCode_fkey" FOREIGN KEY ("StateCode") REFERENCES public."StateMaster"("StateCode") ON UPDATE CASCADE;
 f   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_StateCode_fkey";
       public          postgres    false    3224    261    256            �           2606    51309 7   VendorPrincipalPlace VendorPrincipalPlace_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 e   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_VendorID_fkey";
       public          postgres    false    261    3226    257            �           2606    51343 +   VendorServices VendorServices_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorServices"
    ADD CONSTRAINT "VendorServices_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 Y   ALTER TABLE ONLY public."VendorServices" DROP CONSTRAINT "VendorServices_VendorID_fkey";
       public          postgres    false    257    264    3226            �           2606    33934 *   approval_desc approval_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.approval_desc
    ADD CONSTRAINT approval_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 T   ALTER TABLE ONLY public.approval_desc DROP CONSTRAINT approval_desc_permit_no_fkey;
       public          postgres    false    202    3202    242            �           2606    33939    approval approval_status_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.approval
    ADD CONSTRAINT approval_status_fkey FOREIGN KEY (status) REFERENCES public.approval_status_desc(status_id) NOT VALID;
 G   ALTER TABLE ONLY public.approval DROP CONSTRAINT approval_status_fkey;
       public          postgres    false    3144    201    204            �           2606    33944    lgd_gp_master block_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT block_master FOREIGN KEY (block_code) REFERENCES public.lgd_block_master(block_code) NOT VALID;
 D   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT block_master;
       public          postgres    false    234    232    3186            �           2606    33949    dist_dealer_mapping dist_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.dist_dealer_mapping
    ADD CONSTRAINT dist_id FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 E   ALTER TABLE ONLY public.dist_dealer_mapping DROP CONSTRAINT dist_id;
       public          postgres    false    210    3154    209            �           2606    33954    lgd_gp_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 C   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT dist_master;
       public          postgres    false    233    3188    234            �           2606    33959    lgd_block_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_block_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 F   ALTER TABLE ONLY public.lgd_block_master DROP CONSTRAINT dist_master;
       public          postgres    false    232    233    3188            �           2606    33964    dist_dealer_mapping dl_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.dist_dealer_mapping
    ADD CONSTRAINT dl_id FOREIGN KEY (dl_id) REFERENCES public.dl_master(dl_id) NOT VALID;
 C   ALTER TABLE ONLY public.dist_dealer_mapping DROP CONSTRAINT dl_id;
       public          postgres    false    209    212    3158            �           2606    33969 $   dl_item_map dl_item_map_2_dl_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.dl_item_map
    ADD CONSTRAINT dl_item_map_2_dl_id_fkey FOREIGN KEY (dl_id) REFERENCES public.dl_master(dl_id) NOT VALID;
 N   ALTER TABLE ONLY public.dl_item_map DROP CONSTRAINT dl_item_map_2_dl_id_fkey;
       public          postgres    false    211    3158    212            �           2606    33974 &   indent_desc indent_desc_indent_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.indent_desc
    ADD CONSTRAINT indent_desc_indent_no_fkey FOREIGN KEY (indent_no) REFERENCES public.indent_old(indent_no) NOT VALID;
 P   ALTER TABLE ONLY public.indent_desc DROP CONSTRAINT indent_desc_indent_no_fkey;
       public          postgres    false    3166    217    218            �           2606    33979 &   indent_desc indent_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.indent_desc
    ADD CONSTRAINT indent_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 P   ALTER TABLE ONLY public.indent_desc DROP CONSTRAINT indent_desc_permit_no_fkey;
       public          postgres    false    218    3202    242            �           2606    33984    indent_old indent_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.indent_old
    ADD CONSTRAINT indent_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 H   ALTER TABLE ONLY public.indent_old DROP CONSTRAINT indent_dist_id_fkey;
       public          postgres    false    210    217    3154            �           2606    33989 )   invoice_desc invoice_desc_invoice_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_desc
    ADD CONSTRAINT invoice_desc_invoice_no_fkey FOREIGN KEY (invoice_no) REFERENCES public.invoice(invoice_no) NOT VALID;
 S   ALTER TABLE ONLY public.invoice_desc DROP CONSTRAINT invoice_desc_invoice_no_fkey;
       public          postgres    false    220    221    3170            �           2606    33994 (   invoice_desc invoice_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_desc
    ADD CONSTRAINT invoice_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 R   ALTER TABLE ONLY public.invoice_desc DROP CONSTRAINT invoice_desc_permit_no_fkey;
       public          postgres    false    3202    242    221            �           2606    33999    invoice invoice_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 F   ALTER TABLE ONLY public.invoice DROP CONSTRAINT invoice_dist_id_fkey;
       public          postgres    false    210    220    3154            �           2606    34004 +   jn_stock jn_stock_cluster_id_farmer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.jn_stock
    ADD CONSTRAINT jn_stock_cluster_id_farmer_id_fkey FOREIGN KEY (cluster_id, farmer_id) REFERENCES public.jn_orders(cluster_id, farmer_id) NOT VALID;
 U   ALTER TABLE ONLY public.jn_stock DROP CONSTRAINT jn_stock_cluster_id_farmer_id_fkey;
       public          postgres    false    3182    230    230    231    231            �           2606    34009    mrr_desc mrr_desc_mrr_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_mrr_id_fkey FOREIGN KEY (mrr_id) REFERENCES public.mrr(mrr_id) NOT VALID;
 G   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_mrr_id_fkey;
       public          postgres    false    3194    237    238            �           2606    34014     mrr_desc mrr_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 J   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_permit_no_fkey;
       public          postgres    false    3202    242    238            �           2606    34019    mrr mrr_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr
    ADD CONSTRAINT mrr_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 >   ALTER TABLE ONLY public.mrr DROP CONSTRAINT mrr_dist_id_fkey;
       public          postgres    false    237    3154    210            �           2606    34024 ,   opening_balance opening_balance_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.opening_balance
    ADD CONSTRAINT opening_balance_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id);
 V   ALTER TABLE ONLY public.opening_balance DROP CONSTRAINT opening_balance_dist_id_fkey;
       public          postgres    false    3154    241    210            �           2606    34029 -   payment_desc payment_desc_transaction_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.payment_desc
    ADD CONSTRAINT payment_desc_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.payment(transaction_id) NOT VALID;
 W   ALTER TABLE ONLY public.payment_desc DROP CONSTRAINT payment_desc_transaction_id_fkey;
       public          postgres    false    245    243    3204            �   %   x�22024�LKB�00τ3=--=-�+F��� ��q      �   D  x�UQ[�#!��O���1����4$zFY���1�)����r��^�)�����V�"�ݣ���~
���a�w=�է	���xx�X�U����
KR{d���:>���2ݡ� �:�a������Ff����2z,���HF��Pg%����Yx��0�=���P{�*��hPs`Z�c�Tv�D><Yw���J���Oܠ� �կ�Z{�cRg\��)�T�9(i�ZOQ'�+&Tnd�6"�E�1h�[�E�C�k tQw��}�S��~%:�횮���1R�|���$��ܨ�^f�9��wT���g��?��w}JÌ>����U�����?
#y�      �   �  x����n�0E��+��0���xGa�X�U6��6�&��>���6�V3K�Ι�����
����T8������$*�ۤ?�Wu���Pb����pOL,��ެ�|�e��\�_V��aY"YD����Fp���T��I2](����D�q��4���ܨ��v5 �����1����o���g�b�dz�zDi57�p
%��A�݆�ک�I?��IC�$�I- ���à�-x2�v-L-l��?�%��rQ|���ڠ�E�ۏ꜉��kEz��� �h�j�:�� �Emدc7���u��P$��"��o��	�)�eA�j�uӏ}Fz�ʩ �M���5�.����4￵!v&�FH@OoX�g�#��t&;����^�      �   E  x���MO�0����-��8_'\Ah���Th�h��$�>�P�f"��c�<�뷙Ϧ�L�)[��mwMW�����v��	o� U
��.��}U��.}�ޟ��p��C���h��A�a�p7����#r �E��qO%h2t�ɀ.�y�Љ�%
*�0&���Li�c\J��]�4KF���R 3]�h
i�CZ��Ԧ��ÞY.J\����V�<3q����Sc��9���!��|p�c��~�:ш��lÜmXPIh9�E?�>��Dq���c�i%��1�o��؀*Iݓ�TSrZzR�"	�4`�'UU�'��r�      �   Z  x���Kn�0D��)�/�p(Q�ct�U��J	�X2�����C������p��3�'Jw�T<!+9~�G˳��u�����S�q�]�Pq��}f����!և��i
��0X9�/:�6�q��WN��Ǵ�#B��RV�Xq�����jnø�H^�e��|��6E�'&�h�~�r�>3wF��4q�Ye%1��&��8Wi�G��5y��0Z��T�&F�
�xhg�I�1~�C�n��LQX
����Hg��>O&�ce�R�7��X��Q��K�8����7eZ!�����ez���x	�P��o�uW�6���Т�؝��(�U_�H��?��,�/�{dA      �     x���[S�Hǟ�O��nm�9}��FQ�U�Uǩ��%P�F��j��o'�CH�$)o�_��{w�o����b��_'������V'�>e�ר��l�=<��~�ă���^�iO������YI�X��`Į����pк������g�Og/���������U�Ov~{g�Q�X����eq�P�:�Գw搰f�_ C�Zn���NǳY��6~y|B�?>���A2yf���t�c8`����=����dBa�z�y�a�>C���j��}}�a�Iz=t��n�S���C��wdFk5B0C:����8J@؄����~<�qh��}�FRzx���H�>-�b��Ih�Λ��/u��l�3���;��[��S!g6
�R��r���!�6�[b�*����(Nf�ӵ�qɺ�.��d���E�ғ!�gV���������Q��w/�뽣_�B>>��/{?���^~�|ӎփ�-t�t(L �^��-�y�Kv-�A��>kcp�1���t�#�[��L�_㗟u���Z5���$	jn�vbfɒVz��2E�0#J
�F�l��u�vs7+AH�tW0��I���K����$�z�^F�m܌�~�W���PVލ���;5Rru�!D�X����D�h���
�0�B�������mh��~Ӫ�j��i��0�!�ˌ�ֱ)v��[��>+A����&�6�F.�[����5&��=!���5�i!О�Gㆤf����������<��Pr=)����2E¦�X��ʀ+��Xq��OcΑv�����2�Ds�����7f�}��K&����U#Sq��E͉�l�ry��@��n��P�����y7��Z����ŋڳZc�\H�y?��2�
��H�P��� �Kd�CoAJ-��;��������eu�5W_;��Bp�*^��≽$�iv~ܺ�k��vt��P��A��6��1W�P=>+T���	B����#Q����69nȸ�j�\�.�:�����H��- ���;�e�����������g���c��P����&j6�&<fu{vr�ۉ�cm�;*���Չ}4m�����jaJ��R/z�'w�H�rǞm����<t�`��qlSFՖ�J�����*����.�$=*���|ts��^�.�zQ���J��lMz�:o»T�U`|zŅ��@�����e�s�1�/�\��O[MY�$�V������4��"\x!H�+�%���w�U�Z7�X��'�L�ʺ\�n��HW�d��8I�a��(`�r'��XB��.cl����o��0su�����l�^�Rg�֛��x�i��:�,;V����}PM��˘+��l��V6<�'�����{�+iB+Eby{�X��fV�0ݕ"
��ju).��+Zs��V�Ѹ��j��}Z^��
/^�V�*wJ8�t�H�Rn�-�SBeHi����Z!4��>�?Q<J7�H;RI�E_�$b�u����}��#���)%�s~��][,R��� �n��Yc�`s�J׊!���KW�a\1�r�z���S      �      x���=k1�Y�ޛs$���ҥKn�r�
	�+4-��uJ)���d҃$�q�ed�����2'`����˴����$)����~����]7v7O��s�y�b5%r��;����~�hƕW��Hl��b��X� �}����h�Qh������br�S��+On�U$v�
����ܓ��K�^��!w�&%v�='���@�-��`�-���P���@��X���6��,�%����(��h��1�пC�      �   �  x����n�0���S�^a�uǾѢJJE�z�R,�LP�>}*(N�c�i?���l��!` �!D�[n�/e��'� ːJ���3I��������U�0IZ�n��hetzȊ�Q�d�gj��řD   +C���i�6:M�`���N����@��>�	:�.�p,'q�0�,$��%��3qI"��47�+.u���j, wЕH`��"q�D�G���)t���7UK�Z⠋(g�@�.�F�Z�;��q�'k��s�f�luz����1��:G[��tv0Sy^�um�~}��7�nf��vT���1��1.�7�,$�Bno���en���\�h�� �Z ��P2���7rYXÜ5i���&���E]	����Ɏ�)���d�#�� ���      K   �  x��Uێ�@}.��@�����⊎�$�I|�Y���A�����Hc�8��T�9��2U�>�/d�Q���L��XD�xꂆ:2?B
;��^�L�dۭ� }�hC��|R,���H�Fd&b#�s`:�(Z)ȅXc�"]��.�Llӹ�ś,A|.|�m#�h��@�t���$�fY$��`d��������#1�6"S�s�	��Ffް�Y�[�����G�Fa�?�m���aW�����q6O��)��t^�O�\ g`d�ёb����m*835���+hw���R��M�Xq4�ц����XHtփw�F!i��u0�w�F!]�i�e�hE�d$��0����I�4��j����f��(��ܯO�My����`�Yr{� ZԆ0t�>uB\�]��?E�s}���ݦه&6�}=]7�Cа�̊?n��h�c��A����>����>����
�j�ͣ��r���U@9�-E�N�0>�o�ȫ��4ݸK}��8Q:`��~z�b���t�H�ǜ���ꨈ8�g2/�uu-OyE~��K1 ���\�$�˃"?�8]�2'�J�$�?��T�Wds�q��֩�ͩ�|�����S��7�¶�D�!�:�����M@=��[���F���U~��[*U~�F�2��fpVn����_���Q�wLM7���]�z�M�N8r�wy��n�����LY�      L   3  x��X�n�F}^@����^���AT��MQ @�TJlǱ��.����R/"Wr\JL�{Μ��YB�3N��0C���ӹ�b�?˛��oF�Anf Q�4ʹ)�W�+�2h@�����V3�����U�K�!+K�ϗ?>ݭ��i�QP_X_��\_�>����6�����k��]�=to߽t�3�&�Q�i�X~������)t��0�K��P&X���"�`��Bn�G.������ퟻ��Z����o��i<vn����d�1N;��P�CG>��܆���v#ZX߯n�|\>}\}�BV�TX T�*�,YRm�l�[��ʀ�R�}�>꼹�@}^�=v���>��O��Q���]G�AӤ�3l�ޠLF��á�����v=xڵ�f���K���@L`͊����Lr;���Pb^�ww[Q��:�MD�aa{��"j[z�8�a_L����]�1 ���{��c��H`|��P_��dW��F�; �y����X�e����YGʓMA��z<)���=�t|yxXE:<J�����C��Q�p*���i�1p�C���a[x�2kv#XP�I�a�|H$�,`*2��B��H�r/��~S$�p(�wN;��+��ǲ��\~�/&g�~���f�O���=��y�Z�R\IΓڀI��66��M@̈�"z�-@�G��r�̡+��B�������d)g��H(ɀv���e����-86ua�<��؀�{�E�&V6Z#sx��7J^6����<pS)�;�C
�Ti��F1�Kf���Ĩ�P�A.1�+��tgH�6`(:
��FJn_UhJ�R��ay������؈{r�H�-G2��&XÃ!� Kf�(	C�U�0K�	�e�
�x�uf$I�I�e�勲o}&��Bl%"XɜȻC$IUv��� ���<!�}�'0�pg,K�k=?��Z5L�׏V�����O7��j����K���	��8�u��
�Jce���g�U$�(�'����޶8� �sqvV\...�*N~Y�qU\��\�Żş�۫����b��Mn�N8xC-K�i��Y�A}�B��BOXAR��u��O�k��Ź����7��և#��b�G㒘`
�@��/��(���@��� ��V��mP��ҿ����e����J�����}������E�v1�%v�q�)]����u�!;)CJ��=K���V�`�y9���v5�G�<>>�������u)lewi���B!��;�T�}?�k#k�>� �JS��YIH�TI �r����mR����H��fT�;�7j�8rgG���MʀTŷ����㥇�8ji�5�݅�IHh����j������G�d���3��H�w�ǘ T��#L�uFi�J��IG�U}��DjM�_"$;��/p�|MMk�H���V4�V������'ܘAh��ߘ�;O�i�z�1F��f���cMP���C�t�.R�H	1����椘ZWb�@�!�X����w� �D�rJ 	_B��҅=���e���<���Oрd]|���F��rd����Ib'3s���F�*U��e�3u�?�P��9A      M   g  x���MO�0@��	��$v��i��&�vܥ�CU���Dcq�E��W۱��,FC�E��o_�j荵ֵ������z��%�k�&��%��h�;Co��#M�v%�g�؏�y��e�K�M��ba���>QL)��
�RB]	9H�d��]�{H��W|����ZFT��ňe �TQ�ŏH��<�y�T����?������|V�J��Z�ޜ1	5o���t�P�pK�4Z�*P*b0�[��mE��'A�D��V�TT��t����������ޟ��p!��Bm�vS,���`�!J���:�e��%W���&�L�b�6E����d���v���O!57g��U�4?�;�      O   U   x�+H�K��K�O,�O�����*\|�
rI�y�ȲN@>WAbf
gpirrjqqZiNN�BAbenj^�BI��KjbNjW� I�#=      P   j   x�U�1�P�9>L���ܥsU�?��b|r,+4���]�G�ü�ՙ�c�E#�l\� )%薭��|i�h�GS��U���fk>�&�ϋ�~ ��:E�      Q     x����N1��g�����ٗ![�V�����	M(QB@��g6����8(������c�<mc� g��fʰ�B�q~+�}�}^�7o��1&N�4���]�7-�q	��������%��0�JX��/O2V��<���%f �@�R��@��'�M�$^Z�f�=�����(�� �l�NS���%�m^�Iʮ���ث���F��o�Hj_Xc��8��m|b<� C�8���돴>[��9�t�p2��N���ǩ�yW�e�w���e�k�h4��(��"�:A8HՎ����.�����Мʡ$�\�'���sk�4��K.U*�P%+(�)
��d	2C�ԁ��A� ����~��(4��i�J&X�d�d"0Ȥ��Sb���F>/��,���f�{��r���CF�s�[.��a�f�p���tHe�DjWWD��ub��{s}�9u��1��o������7�k?!���`��A��[19kt�ﯹQ�H�zg�u�65݌��ե�%lߤ��c
�U�١;&�{�h�9�n:9�]j�&Pi�5on���N�}�=�T����ӓ�����dG��+��q��f�x\n���cI���e�^��_Mo�f�QWw����5������V��D��f�j��J������	uNEU*o���\r���k�s�U�ܵ#
ju�9J���O�[Ԗ���)j}���X�v��Z�[p�0�`Y��t�~E�����X�c�+{������u��`:������E��<      T   d   x�e�1� C���*6P`��#��稘*��)�	0��L�spք���r�p6�)"]�C+`��0�M.QLh{��{�n_�}�\-L�&�� ����9|�F�      U   �   x�5�Mn� ���a* �o9yD��8	������&UW�����	%�ihBȑMKS�����4ū6л�7ު������"g� Hl�8q/l�ֲbg�hE�}-�Y2�F���ZZ#�UB�`�ц���i�ENd�R�lG�b�5��PG��ڑ#,yag�������]C�^ג�SӮ�3�4A4Г��9P~�u>҅}B���E�!s-CW��*�[K��<��tW�a`���oe�PC?_��#�S�      V   �   x�uλ
�@��z�)��b���Dۙ$^@D��M�ES��ѷ�X��8�������e"��[�'��9L�����M�<<`+�xAX��x��~�郗t}���T͸Q�E@�������7�j>���7b &��9�&�*      W      x��]m��F������]��;��%1G�#�q����;H������n�MI��.P˱adz�L��������[�����W��94m�-�R�XA�?�����+%�1�PD�3;_��O�<��y���/�|޵ُ�������[�mڪ[׶��Z���|W.����mc���l�v�?�� ���*��]�N�u�,s{<4yW�բ̺y�q��Nï�(*��W�Hdݬ��)F0E#��1T\�ٳf�~<�vͼږ���|k��jo���E���JP-�Ԧ'�Qr}rU�ٶ���] 5h�U�fG`#х B'T��x�W��.塚:eE�:��e���U��e�xt�<�\FPRA��<�:y�m9��r��|n�MF��S/������ůN�Ɏ��曪��gY��/2b
)R�ɚv���+8��V#���|��
/��UF��y�l�����lak���J�lQ�����\�ZP�k�bk���zU�e�V��+�x��1n�*^ʲ{��/���z�z���\�gӊR� ����������kJ����<c\����v��v���D�l:�`wp���݃�-��"��%��.A\w��|z�KT��zyP$��|�\8�>q*��[��J�YwbbG]�l���)�*���6�@l�#5��0<K����00�Z.�U,��v3�K�5����_��A�� �q�.�,�^�D���z�t�3G��P~��P���Y�hv��C�X{'d��C#�@
|��.Ư���-��y.$�h�6ڡ���]1�QN_5�v�)�Dr��Z3D���$�5�@��r�]?T�ޜ(x��Gw�H�>�������`۞�}H2���n� q����  �]���@�-ץS�Y)���,ze
:^$xVE���_���ͱ;���1&�
x#����jxip��e�3ɻ�����M;��C#�q��=#�C�7`�@F�� !�=�0�kϹ��_\1��(|px}�h�,ˇ��k����q��3g���1�94T�RvO�O��D�S�
&��dP������ы��vg�0p��@�:���Gt�l�w���,��Y�@9���%AK`�8G<U&���@��|S-Qa����R�ݵ�4u\4�{e��2�ϭS�	�k^dư�����D�Q��xZ�A5��ܠ2��p�6�dU�������;�� �(�c@5\?��7���F^P�|����]�P.mw���m�YO^���������~�zG���14XYs}�b�����ݾ�Įn>��A�0�O���N�����D7~n��m�s�\�;�˲]�v���ZȂ�s��/B\�UGW5�����U����֑΅7������{�+ �W>JeѴ{�*EyV�,��aO�|E����+2������&A��Ҷ�g�P����`�����wmA<�+����'�MQ��X%(`I�M֫�O�)c��&IY')8P�!��9�G�v�������p���H��IM�+e:bg{�1_7�t�㞔�3d����L�^���ٷ�ί]���G����E��*�2�Ġ#�+	�&���
���⊄����� �3N��$0t�
%H���:Di�ޮ��d���j�\C]f�)i �ѽu�$AAS��._9n����+.e��d:	�)\\5�Z���z�/��]����G�HO �ډG�0;��.[/�_d�'�)��;s������k����X�;��t��r�#��� R-\�m"������Y�{gi1}�h�P�����������䅡|�Q��{��t�}G���&I�����ƪm�J��B�W�]l�"z<�>�1؆>
T�¹�+��`�'� �'����+�n�
b�C�x��{[W���Vq��._�q-���\�j�l ��	�j@}_)#�@�����\����-(^�I[A�fI*(�"kv�o����>�G�c,��O�2*�Pd���ӧ?��uG����T	'���t1\(�s}��ά�_�����=�X�4�� ^���p��=��N+ӈa%FR�_�����z�f��x��]��ڶ!�� ���u�O�-4�g<���\��6������A;Z�.$/���4-kT��G�u5�Q�YI�hQd@M{�y�E]��m�a}�iW�8:�u���$j|L���sTx�C e����_�D�[��
��c���Z�ϧam����)�����Cق��; �t�����P@���z}���_W+D����QmL��y�<$�����d��^Ë�Mo����om���L�
ql@��dq����3�Ht[S�Ar���a��s���^A^q���ߛ��w� I��.�WU]���*��ʕĠ����$a%���Nt�[���joA �$}��+\)�Qx~}���2hl�9<&	�Yk�V��v%0����x���F�7KPYԠ�K4���	�9�∂�MD5�-$x�6r�0Đ�Ŗ����!3��ק�y��������w�h�C'�L �0��G�\��1ɗ�<��L�٪y �hG0��n1k����Fa8���R��a���t��_�4����^�-
E�jz#����{��V�� ©�B�A����	SX�ĺ���&_4;�
%b�Bmz ud\jM���z�%�^��n��owq�"ø�B.F$�J W2:��pFP��l
�	j�^�C	uX�����gB�A}h�w�����l�ԁ=o��3�eo���!����l������X_��9B2�ޜC��#0�%���)�I�{l��ޯH�y߃Q%T1" �;R	��(d �rJ{�f:�A�we�(��f�zR�7��D�������u/ʧ��%������_a�[L�d(-��I�0�D���m6��pR�PB����4�@���a7X��k(Y�uv]��	�D1|x�qL��׏�H��r��{��@~ҭ�)Ji�|�����&�%���ls�KX��VW��Dq%.=5&��R�/�G��O���0�S�R*ڃ:���S&��V���v׺�asѦ[7�I��"��)��X�G�������)��$�sJ4|�sJS4oR���?��4�`�&GЉ�&�cA�Z���9I 6��q
a�C� G��K���ˇ��o����#O�����[���b�\@�BLb�5���0N0o��#�h�E���&�����q'��lVs�!�p�D��A�@�0�!�����~��Qb��ׁ�	:�G]�sϬ)m�R��08���M@�Pio[��eL���*�42��9G�
�F�9	Tg����e(���V[;�]	N��S_�
C���4�cl8�����;F�pq�]/b|w�1�ͷ�2C�kj�w�p�Oh�$�a�����s+����t��S�u!�t�oʦ�_�6�\�T�.��]�	O�'8c%���qH�� �<�1���tr��œ��Wh��c_ب�R�9�s�"����v��U��Z\�I\��`[V;��v���;'��Y�t��� 7��Q�Os���-��L�1�&Sܕ���y�Ժ%ؖry�ǝ�OJ�BaK
6�	J�T�-�k7��E��[�q�J+iF- h���m�1.Y�)����U��b�
3
��p�I3���	�K]��zH�2$���K:�/�́������^6�K�����.�gUF��C�"y!T��mD봡F`)�bV%�T��O��|�MP�=\LS��b�4q'��C��S��}w��-�*�Vp�q�4KаG������,��=c3\H��4�+	f*�u9���S�3}��ؔ(�	Q@i�~��u���'�@u���TR?�7)Եk!=i��3�'\�-�i�\2>b����N�R�F25��0l�k{�����F����ݙ ڜi&�t�J�4y���_@�柂k>m��`�{�Y�[��Q����� �����Z�
Z|�.}�U(rA'ZW���ٌ��i�R'P��p�^��ߌ�� 7����C=�    ���~6�y����D�K�	r?4��T
ˊ��G����ˡ&F��v�#��.X��!���N��LG�Z����)<j�;�PƝ���d��1�D�����	�+ܠ�6f�<�K!��HɈ�pJ�ʊ$c���K�/� ���a8�dp�÷O1�$�"�l	��޺)g�l�5�r��Ǚy2�$ۀ���pS:D�p�i�Ø�'��f���d&�!��8�+A�"���X7PJ�KLfƞUnv�/
�`�}A��4�D�yҴ�ë�7�M�Y!���mB���+d458I~��G�A�ѝ�&׉ES�� ����>))/f���WdW�0��ŉt����Ý��<��ۑ"��OL@9g�p��b*�7�����	�3��.�j�iC��ZEb��/̣���b��#&BIÔp.z���T�������-�^,N���V�dn|zl����$Z1p�zC ���j͏�����1�Z"I��#i�Y^�oTTrШbxG��X�q7�k8E�`Bk=�@c�x���,�c�2-2-�d���<�2� #�H]���6�$��f��bO���F��j�I�Ѝ��t��)b�]�:�G����~�&�~'ó�C�]�uel/X�CZ�-(@��4�h��i�Qys�I�3����=K&�@�I8O���)p	�>N�Es��<h��X"Lj����i�o?�Ť��q�FP��Ӓr�ɨ{��Iq^��M@�_����-Q�@�z��2���a����S�����
"��Ӱ�d�.c���ը�
Cwzu�@p���j�Uc���TRD���G<�|�M�Llި@@P���K�R���eg��Ѻ�΍�k���۪ω_��Z%d�~H�Ć�l��SlZ��h�2������xX٦�a��te`u�kA�<�	)�@< nE
��E��u�iFT���ͽ>S
�)Q����YE�;r`���@@�$8�8"1��ؤ7��n�pas��f&�#�8����~�Ӹ�#���N2ʶ�&0� �,3ϫ�9��'��\IU�$(�1�v�j1Iw��D���-���D,K�U� E�D��v��G���t��qD"{H�.��9�����m���>P�����:���n ��e�K3���]�	~UY;ی���c=B�|><�2J'�q3�j��E"
Ԯb�(���I�HC�a����*�q�ؤ��B9��Y��8Ş.�ĩmw�8Z���HP �8��`��P���nr��)�#�F�$ҋzLƻ� ғT�����R�����i�Hb�jcnμ�T�nf`L� f�b�.W)Ӗ��.�:��cBDsLY�g��jk����X��m��V��R�=���&����}��Ȏ�l��3h�bTƉ��a�b?��8������rxb1x�M�/�Z����)��~H��v��	<+�w���2o�K��]���Q2R�����F��h=�BX��#V�����I�$�y�u���UQ��\��K�*o����eڕ�=�~7Qsn9�9ii���+�:^ӝ��#:)��	� �w�O@�:����EoA-I*\��\�{l����2����'9��b�	�/a�E�*{+^�p�P{|̦~��"(D~X����|�� ��VEZ�A���c��e�/�#�|Q&ݲ���(h�:���c�G���Rm����	�"��p�Ou�0ޯ��Rn4&����}c��I� ��x&d�%֫�����=_�58�%�58��<������&_��[Bq���(�귄�ir�̫���+WͰk�7 ����㠵2{ܝc�p�@�DӺ�����m��w���[�����c
.�;[;���|��_�
G���	(�Q���1�K��6�r����~����t�F�PC�[�!�!r�g�����Σ�X�0*�Ņ����l�<��^5�v� ��O*�f�cI��7äI<N@��>Of��8..��Z#�@h�@���/���pq��c1�0�m�(��M�.�@�W��nlb����|�VU�ƌ�łS�O��/�_����}��$O���E�d�5ϓu���-�g����~�2����F�H������Ho�s�)�� g��>8����l#��kIb��n�Фq����\�\"��]��ΌR���3
��BQ���ٷ����Vҝc��k�����j̔pYD	ãX�;�/6ޜ���AVArHbΨ;��}�����]�v7��S���o{�B~T&�'X��yq�h;����z/'L���If�`I ~�W�'b��F{�+SB~]Ï� ���H�ۗ�j�o��n4U�P�ݬ��+�(<v�&�ʀ��et��Vϸy�(�a��i�X����Pl����h�&܏�
'�܏��-M����2_���Ch?i1�ê�0i�j�+,�g����c�m��3vYͣa�ٱa�, ��f��!g
�!����_���\/g1G�,���]���1x��s���7C�0M�_>�f�4�t(h��)L.6�N�G#Z��aH�KM�A]���%E�+6nM�
Qd1>5�g�@�\㸕��P���	r�š"�Ϭ4��)ibܜ�G��H��y�Hׇ�@<�$��CF��<����~`Rd،P{�nN����$˟p��/�Zk�=��6���w����vV�7Ug�f��Z
�vܡ08�8���D�?�~�-��b�g�,�/�L�~�m��A4�N����M���7t�c��ͭw�q�&;�qu7Y6��|j�B�!o�����&Bm'ؚ��!��y�A��I�wn#2���x��C�dS��k��K:�W�n]N�� ���m9��#���{/Pŧ���0��m�|���;���M�7B��ɩQF�.?��v�BF�p��T#�4����Db4�h��q7��NT�����qE�^�o�_�؎x����+�PVhbn��̩�N�pxb�7��%�RC'c{ѻ�lN������M�Ʀഀ#?�.����D�@K�FC��ȏ۩zV\b�)*B%��FG:!��fz*{�&�fRh�2�Ɛ��>n9��~6MF��R�M2R�$��+�c�`U��#�~��E�涞������2/.��*r��j���C[\���G8Wh�JW{7�P�1O¢<IYP>B<	Y#�p�9W������D����#�ɳ1�Qf,9N����0M�Ź���>g=���X"��_m�ht������D@��䆕6=��b�D5߸nh� ����x<���'�_�(�Jf.m�'BEy�I/��;���"��P���$���b�t�Ɂ��WZ!�;�,��g�|��H��Hd�_z���l�7���N
�{��L�ٺ�y�{�	0-
Z����=\Ut}����N��c�^��+n��'��f]p\�l^-1_"���铎Ҍ�=}X���$�`_̳��	a��B�1��A^��[0.�W��5��̭@�Ȣ0�O�3I�u���qy@7�_�gظ�kק+���DX�0JD O�¨K~6a����&OԠ¥�3l�6c��U�h��G2�qNF =��]i�)	���Ν�LQDű/~��4邫��}D�7h��Rl��	zp��Eyr���듣����K7ٷ�݂LW��:���~}��S򳘇/8c�$��O�cǱ��=����Oo��w�B:O&�����qB��6�\�946=}�\����m����q��)D4�4t�+��v�5�PU�k���(/)��¾�0[OP&��?�Mh��+�����>=����?��M���~�9�	�ߒ�[0��:J/Mw~�Wv�����Q�|KԷ�w���#���b$�=��±�ފʐ��B&��[e�K7{J�o�����V��KO�����l�oo?���/�>���������ӧ����矲�o�����9߾��������/�>}��l�������>�������_|H�'.rZ|��w�ΨW�����g,>��������������/�ѫ�w �  ����������~�����o�><���?����u����K?����a���)+�w�τ�Q��}F������o���}�B�_Z}��;!g�8x���.{�}#����O������_��4�^˷
�����3/��~�Z���ݳV���쯿���_�o'?S|�9�Ad���
�5_$u�����@Hb���H2��ل��l(��>�����/n������n�s����GV|G�������1��]!f����_f����� /^��ل��l`���߷?�������~�k���q�~}�K3�I�-f�)N�䳾�4���(�����>���ހ���A�7��{��V��o��~��}�Z�wo�*�����`~���/�_�S�      X   +  x���ے�0���S�d�p�WF<E����f��]E�|��!��ήX���u��i�Y�͓�G�4���͍ƚ�s��.�6".��� 
�(�#�ٸ�h�ݾ�n4���\����eT�+�9?��oax'9��iD���ק���笺cl�~Ă�5�P�$�~d����D���ِ��|P�Z<y[�`���!���J�H0��o���d�.#'i?X㪳d����`��,b<hJ�1d��!9`r�)37�Z���\��:��Y��5i�S0���� ՞�Rf�jA`����qS�%�4�`{OcѾ|غk,�g���mk�>!�3_T��/M�S^����)x�b��Q����i��X��b��vTH��K��(��7EVj��n� �{�&�ʮ��!.���۵+����ABA2��eCRfh��D Iy���nh-��_Ei�f�T��Սx���
������6MGsΑ	�{&
�g�*���;��R��(�l1���"��3qS[�`2x�BD�1K�qز�a��N��}9sJ/� |��u�	��C������W��mE�Zc��j��s���H�D��ژ�s�[�u٪��A�<�U���ڗ���Y��(
|=Ueq<U9dG؅Q�=��l�-38���ĽΊRخM���q��l�F���'���X��kE����b��q�D���G�u�w�_�e^e�g��*��r�� Ln����<��D�O��D⟪�(Ue_��u_��³ru�S�:���PD�c�&�Y�A�o���Lۜ�������t: �N��      Y      x����r�Ʋ�����վ4��"m�<� 2YZ��\p��9��,�T�~w�@`�Ii%����ɏ=���=3��D��j/��Q���&s�����ۥ���W�������Jh�t�g�F�����楸$���O�y�~����Kt]�|�"��4�:v�9�?#��_S6�b�Y�(#ZG�D��6���E��k������r+������뙻q���[\IxG)A�����uϨ�0"^����,�o�V���7}f)*=dv��7�C��O�|;���|;�NfiPf�hX����U|$�rDU�'���) ��p�7q�z�a�'3�*�fM���2�����'�)G\'�j���|b�'��j��g�x:��җ��J�S�_ן ���WM(M�cFŔ��|O�t�u��������Ս��ޮ���H@Ո��X� P��J�>���/�ɀ��W
�m�X��W�~�� ��q�7s�l��u��gn-+s�U����ެ>�l��LP#i��b�\���|V�m�������S詋�hhjM�v��?̩G�$TjB���9u[S[�*/�b�Ϋv
5E#h*\H�p ����v��s�T�DKc�`�2>�ٓNұ��8���56��)~��^jF�'J�@�C���dZi�՝��q��e#NI�P���}�_2r�(� �����Yr�����f�@9x�n�?U5g�I�H�h�j���d;�4s���mfi�F�9�RI��]�<V;���e�L9��K�m���8]Mt�ٺjBe�@f!��7!;�&1T۷L@	%c}9����-���5=s�U#h�^�o��נ��O4�DЁڶ��V�f.�γ-TF�-�|�*�B�U���z�|��O@:Ѡ��:|1���O�/n^i&W
r��?o���)�%�捻,&vDT�4	���d�e��YO�&��%���t���T&�+I���o�	^�U��ab��[_�lW��e��T�L�r
�P���`ʴ���p���]��(;���eǀ�*d�yU�+�ώ(�By��c�s1�l2�2XL0(Y_�l�F���b�����s�����*f	|��ǧ�7}l�-.7�eaA��2}���BO���}�O�=I��i��}k]с=��5Բ`��@G}�V��d��eZa	i��
�f��K_����00i��˄A˴y(�ٺ�ЗVd4feP��|� I6�`%-��`�
�}���l����L�<|P�BO�i�s3Pr�9�$��P��U�,�J���2�Rp��k��m��̈��S��1��ҧkE���&�bm{Q��W�f@����&Z3�t�Q������T^:�l^���P�Q'��0'I4#��X��1[eq/��8��x�Ux�����q2)G�p��m;b,a��E�����ZM�������,)9J�\�m�GS�t�0S�z$d����إ�Rk���+���{��t5�\<^�nZy4e������A]m>��l��И@.j����U�i�.%!%{B���)���Y��?�����������G��M�ui�@>�(6'���p�����t���f�t�y�9���� �)�&����^"���h�tJ8
dlD(�D�~��p�G���o���&�-לB�C]�C>ݬ�f���d�5{0x�=!Nȸ����Ť�%7	�(!�f���>&?�ɡ�OP��=�
4�J�,�1�+L�>��D��п�[0��pv��`��x ��}Oz���ҘP#鏎5���\~Z������@Bjr��⢃�T����A�S�����V��~w�!��fz9���`nAg��aX��ADu
Qf)�^����{k5�����7Y�X�ཊo\�N\\ʐ��J������:�.M��� )�`*��J��ю��g�T��e����oO�1R���f֑)��#ZK\�B	�S��4�� �.󵈵Z�����q+w�MVʡ}��������j��azL��
�D��*�Zʧ�Y���&U)I+l�{�=��v��M�O�߸CR���k*����%�����}{��ݽ�R�R�=�j�P
�v�;��+�i �n2��
X}��O�j�	�����z�cݯ�-T>�C
,�<�����Û% g��(��H-TT����PL�	J�ݷӠG|E�G��$D��	0`Z��5�����eK�+��V	�*a�8l�:���/W�������>��!a�<ƽaZ��h0;af�0�V��n��n�&�>�H��({~-�S��'�H5�9��&p�VW��H�U����Ͽ�8+v�xU�]<E���;���
"�U�/n���q���Q�G�s���0y��	|��]����J�Z����x#����^q���b���Ko�6���݂�HW���2��p)+󥊵Ru��9D���y	�w� oV�����mXWZn��N��z�[�
�U�'�
'g�T`ov��$&��sq_�8�1�o'����E�-�'_3���;���{�f��P�(^_�j��Z��NG��>!�-jL�0�	m,��ո���V�>o�-�d ����D��!^r&/?'�?��Fu0ܘԾ�q�-�IzSnח	¹�"��sf��bP�X�W\B��Ug���V���Bu�M�j�d���V�[4��:0մ=����a�V�`� O�}e㭲��oo�����c-xUFF�꿓�^6�����:�Ygn��W!f0����1���q}r�l�D�]�S(�`k,�
�]�5����5/@����G��B�7��]{�{�?����ib8�*��W4�*�	����y��ǧ/��	���� !�I��j@���0��������
��g�qS#���J��b�R$N.�����V�޵'Av�p��)�^��K&cFG�G&FY��F�����G�3��i��93�PA4�B����_l�׀�_pD+8����i�Hǘ�i��ÉI�"ڑ����*:�G�\&��Mp��\`_O�8���8���x����aM5�I)��Z���
�d�ݮ'�������v/����CEy|~|T3x��� ��*i��|9��������X����U�4�Pݔ���P��
��-_��Q~T��p�5a0~��8���IJ
��n5H]�Ѓ�S��lzƧ3{���z6s�uZ��Wy�W���ޟ�zXkE��1!/��/.�s�=׬x)pQw�zm�4�ss��s+ξ�͔ERY1�&��&��t����z��npiN�
�>`�do[twd�'�{��Y��=a3k��HE-�Lr��.�"���I����a�d�'cm��� ��s<������ia��Jw���d���0LX;D�}2�'s�|�ɿn[� �<���]pL�8O(^Cp��1��m���ʰi�y�j蠨���]�6c�Ф�&[���:dZͅ{��i0b�`��t��p��R>��c�/�P�B4���}+�G�&�L7_��4�eZ�O��h ;v=�L��z��¤��̗ �J�,�����M���6r��AFA�$d�ֽ���K��_wРY��u�Na	_�q�z�\N��iM��Y^(`�Q������E�% ��l�!�/v�xY���a0�G�ҡ�w��`6̛�*��:[oq���b39D�.�P+�O�U�z�H'%�[7��6�H���`8g��G�N�����)d��
&�'/�|�P�zl���B]Ra�l 7�����>d�ص|]<��Y3+��/!�����M��3�^p,7����T�Z	�n� ����3HK�(���j��^*xs)�h}YQ�ӹ�8߮�EQ�)c��e'�s��rvf�����*��
����!!b����j���ˮ #�,����5�{�Ml�	�f7��(�<�)w? [	���~���Z�Kԫ4�C�}?e�`|�<]X=,�/n��~������07���D9�jE
.����V��ɉ6��{x�s���;��N(���P��KC��{�q}�Ol�w����:X�{b�!)%F����W7e:��-ד�T[�n��Z���> t�{W|^�"9;<Hoy}aS���l��Q�r^�� J  ���`�b8�U�.�]���$��%g��ũ����N�zw=K7����C���`���`����S����RId�D���WBM�I�I)~I�e����Ț�e���Ү�<�՟���/��������:��ɱ@����My�}�ԭH��������]��bwWT^Sᓞ``�����pfo�O)/c����f�������A��p����[��ӱk�����=j�� �%��B�F�(V}⼨3�=a�����>�S�����歀�Y}�Θ���
�9��%5���?�z�'���g�=M0�x�:1^x28h���I�u��\\\�?�QyG      R   &   x�3�420��52��J�I��L���425 �=... |�%      [   6   x�3��HMLQ0�2�0L�L!S.CN�Ĥ��"�Ģ�T.#N����=... }�      �   S  x���Yo�@ �g��7���,�����Gh�L���j���*�h�Mvf��,_6��|x�	="�NR?�G�M���׽�Q脝N>��Cq�����-S �_�F�X�����r�Q���(��6��S���Ͳe�ʞ/�lg��Z�-4]����]z2(��	��|s6��J��}g��˾��'��FuFj�W����?V%)�%)x�N�̕D�sR_``����F����Je	�Vg���"�uj��I����:�8#%S��4	���7��KU�e�t�ݭ���[N�j�~qA*�9�;�*jK�B�-IF�k������-�Тb�௶��7;���      ]   }  x���MO�0���)��6I��i�b;r)�ihB���#]�e���?c]����s���& 7]�ͧX�2�zl%�o{�K���[�q�8bk8��Vb�o�Ӹu1�5� sT��f?�ö(�æ*��XK�����k�]}�ETw��2��c���Á��ֳ����q�R�>-�(5��M;�>com#�e�]X��]�c��|����pzTX�T.X�T.Y.R�b�Le�r��4zJ�B��ˠ+z�zxz��e|}ش��aܭ�l�^�4橞Z$~��?���~��E�6~}���D�3�;J�:��J�ү�v$�+}��|M�ɉ�&��mdo4~��}?��E������:q��e�����I�5��D�ad�r�e�/ ��      \   �  x����jA������A�#�u���SŅ���L�f���0��o��#i��>S>3��4!5�F^������'0f����ϯ�����������ဇ<��G�@��	k#i,%BDb|8��>/p�J���f\�@&�֔J���;��*�Ɛ�ڙr%1&���0��;�mf��u�uMTi�����Č��k����7�Roe��|5	���.S#��4�W��}�#�P�k�xTz���;ߟ~v
W�N��.�o��Ċ@�.T��&��z�ІؔG8׷�-;Ze qIr�l�f��e�n�j��J�Q#(�n�K��{��GY3�jQ�Hh����@��1��`ͣ�%�遼A���$�$�0>�+ O�͞y�f�*���̕���o�s�e"l���P��]���j'>�8�ҘH�K�d�6X7�K���t�U6!���(���8ePo�ܨ�FR�$
9���_5'Ң�u&����;��81K���"�)֑PQ�#}Kc�.��dI�q� �z� ws��a�+�ޗ-xvL�Yr`�"^�0�v!��cΫԨ�j1�ȣY�e�`���,<pYg�����ݛeA%N��6�I��J�4Y]#��<�|_�����4��{����dT7x���B��+d�������bք������0|È��X��y�Ç�
=wȄ�2���)���}9?>=^��o�x<��3�      _   6  x���mo�6�_3��_@
�Ȼ#��C��@�mN� E�M6�Y����,���؜��F��x?���(��|�\�-�ƺ��p�yn�3˻���;	b>~���O@�`�?�/Z�Z�\]�S�f2=�����ӷǇ<����������pZ��L�^�����������󷗧ϏPp�x1����Y�L�&g�Z�h��'�V1���@✸zphdp �������Ф?6Kqn��#�,�A\.Q��7��گ��G�د�����`������8�����A����11F5B������'9y��p%�� 9�m��}����Y�_^^��� ���z<+�b�������A���\��k��#����ǎ�e�?��h&D�ʌ����%����.}�4,84�1t�-0������I��0��b#��Ùw77�V�&�1�C�ZSm<#1�_�Y������pz����%����M�&w9 ;%&-)g�c_��,����*S=�2��2�7?�դ����
�,�}�!3o�a �X�A�!��4�� �-��m+���uu��S��5��z7�J�_�/�b�V�(�F���>;+����aeս��H��>D�8�3����1l_��CՎ����֪1g�`��:� œ��y�P"�� p@_��W�C�jۓ����&aYj����#@3CZ��?��!<��rF�2#\&��� �ۊ�S	��C:��ڔ��	�V��`K;�%�K�|F,�Cd�;)�\d**l,c)N)(%ut���:��l���B��c`rJv�/�1*��>ZXmj���:1�0N	D�#A��~�B>H���Q �v�E�����%{�1�B�4���x8B��:�b��đ��g��6O8<'GDN�e�$����w�B�q*���R�@��}���ȉ9G?7pl��-�ʜ�)|�X���A�a���6PN�,�hxcޖ�8��I�`L)��X(��S'0*`[ 8���X0�Zq+zP׏� �{9����&��@yz��r}��d�Pۜw7�^HKO��u��qn�����ּ�a���ó6�/j@h�x�P��I������g��˝�~��� ��<Ky�C!�5}7#�ʇ	90��WQ�QMo�
��iI՝�:tc������u5�����r����i؏�z������_.�'\�5È�g4����}��ɲD���k�9lr ]^Xs ��6j���2۶K�n���HxD����a�k�A�E[��`���k�_@ж�ӓ�#7�r���c�c��s�#e��`�v�z:9�ۋ��� �t""      `   �  x����O�0 �������������#�_f410'�����n['�˒����~��n��s�(�^�e�	)�L��@I�BI?����l��̲��6��̋��6�k-�7�Z)��,�+�T9o�~,j�z=}�,+��4)ǯ��i�KEN�\�ίX��8my�\�N<��0t�`��c9���r�ԁx}�4f���7Y�dV9D;e���$��&Z��c�#�PE���R4q��t�<��d���(<�0�lB��h@���iԲ=�ua ��D4
�(�Fuo��K���^�K��p�*��𲌻/a���:&�c��VY��8U�ͬk;[�	㋘�g1�XWe��X��{��iU	z<[��6��ms':Y-n��b	�� �
�*[tgNE)�N(�&3�T�Bov�:4t������?%`�>      b      x��][W[9�~v�
=���x���7���&v.=k^����Cl�6�d~�����m ��6=��ʖ7�t���J���q����w�z�^����¯�������B5��D|�ߗu��?��罷����t� �4~�o:�*���j�\����3�g)�Բ-][��ч.U.�h�`����r6o��W�Ak0��^��U縥�v�W!��OU^5�U:44Yi�������!�S�12����ڔ���ӿ<�8/u�:���T�f��*��$k�d06am0��*��������q �1;�r�y<_Բ�i�*�JA�J����J��:g���H����2J ��Ռ�Ro}Y}K(�t��`��>/�U>���²�G*k+oa�h
��*�~GB���2[�D��|r[�G�&����8��LF��_������J������iQ)�V���u�	M�H�-7����;z�0V9�I�#mq���D��u��u��BC	iLmP�)u��
���?�������m��]L��q�2�a�������f-�G�S�����R�H�W?�~�}���x<�CG�$�0*ځ�R���3�s
�u�55�=��M֘P9���{Yi�0���3I���(�I.�*A�f���o���jh�ƒ��.EЯ�m>�|�8?�=۰Y��#�*Kxo2}�/���_n����~y���l2&V`H����l��L��WN;���Kq�l.��0�����c"��ػ����=���/:��V%��5�F��*gk�J��f4>��
� (ݚ	�����;=>�]�z��0�*F��&�D�U0/ML�`]�|C=��*��@�����FG%���d�H[-���K��%y�8B1
�u�k�ltd���!���h%�*0��қYc��*��Q���a��J��Nِ�f�f�{#���ƙhwf�$؃�pX��Z5��h
��;V���anB)�3Z�]i�"I��uu�nR&Uh��5��-�Iq�' ���6 ��-�0הz���?�	�	��L�$�V�C�\(H�$M!��A����n�����pv��m�J`Hж�*�B��t�(�ZVH��fa�6�Vv$P�`!�Oc�H���_�>���B J�p�H����h�K�0XW%SS���Jv���%m�'LgX�5v���$� )��Q��3����f�1oM#�%���%GcZ� ����v�{�_tOEtV��M�=B h�%���"��l��MZZ�����(���A;�w��Vd��/�,� �$� M�|E�;��01a�`]cM���"�d��Qy~�0`��ڕ9>�'�^uλ0��S��!� ���U�|�*3C ?Ȇ�g��@�g1Y��[3�ez���QP/�^>G�*�x�(�)(�X�*�#�%m^��}6�����@ � :_�a��
���-_N�$� z��Wa<8�rW�sM0�d#��A*O.(9���u�T�4`[��1"ç��Y�����_��U��U���mZ�`A�B�q������2�c�x1�����ئ?x=�E>$���`]�TCQ�d�b4G�@:0�5�Wɫ]ŘŰ���J�=���"8��F�0�S��U��6��<a�qL:&0�.�S�v5��AS�}->�>.'�B�_��U��g�����c�ǰ8O�8�RÀC`Ӯ�=�t�*�V(Q�t��1j�����W�s,Gj�Ԍ� �1�\obл�oX�E\ގ��%FXo��F�Fe� ���u��5lh9#���y]Y��*����]Y�z�<t68ǀ�/p�����!R*\���&/sH!�!��8��z��䡲ck	�0������f���%S�ƚ�#�+^�X&�����{�����O�h�x��q� hcm�A�#Z&��:liM#x��"���LR UJ5(s�3�%��������M�>���84� Wej|X�I'�IS _c��s��Z����P�ϣ��W���e���G�����~�o�:���Ғi�#}����sDA#�加��`�u��d���4�nF6��A@��0�R3XG�X�Q��磑<t8�h�j�K�g:��eO���YlRN�)�Q�a�����z̖�p���L������TqW���c�u��m1x��2w jv�0�)���1V6��8"d0�O��(`�w(
`���f>��;��E��;�7���M�?���u�:�
�u�l(��L6��=J���e�x�������|�׍�Gf�O����|���f4���Kt���l�-�s����Rq5����3)E�6)	�|���T;3(�cYQ�5!���%B�#G�@k�(����>�`$��)��
�Ɍw.�]!���Ռ�c=U�At>Q����u5�uU�5�& h!A�R�6��`�����O�B*(�E�R�G�q�Aؕ�D��$':U[@S/3X�뵦��v�Kɮ�1^��Z����,b�9k�����-��CÙ�:�wd�2��ő�s�"tS@�2}c����2����t��')�*�!�aKV~s����j6�3�u����Φ����w���M�����h9�M�3[P�=5c�^�O�Іo��t���N:��i9�jL���*�dw�@1������K8�4R�aH]��)F��2��`�0+#&>M� j��V���o.�.B|��0h��/�A��Th�B�"e� b0�6�B�,h�䲊����qZp��c��Ñ,�cV�n�&��0��r�
1��r��
�j�H�.\A��:�E��sVȃ.
� 'RR4�0>Xkv\�w^��u����wu���-J%�&���cqM���=� �p�	�a	F����`�_�nҜ~v2�@�΀���j��g�����bp�[2���=8�����`)�LnH^\&F��I4ȸM�0�8���TOi0ĳ֫���O�f�������y��EhDR�WP3����������hղ5�04`�!��6�P�#�0���RA'z�0.���H��ș%#1��0XG�B�3){�`�X�*81ņqIY��#ضZ\��%��&�ȭ�MĤSa�����٭�[ �6�!~a�˸+�{z޽/;W�i$�L�X�1F��=n�H�u�qM��D���?>E�7��iiî#k��!Do9���c(�0X���PzP�x��AZ'�%cܼ0��ư+osU �~���˓GzL����J��r��Xig5�"D�0 ���ْF SF�x>��p',�(���L��s��::��\+�&Ur�"���di�1�eW�o�7#1�u�����1�?^>��TIa�RZ�*rzy����8ߌ�M��$�5����ih�);l�g�������a�k�nW!K�?�9q�y?6 ����%,�e��˜d	R[��Y���|���ö�j��f9���n�7���˅Ȓ.x��Ǻ�I�lx*`��|Tš"�|7�5}�)����K��~�w���#aۋ�w����������i��x؎N|�,?�7oO��R���'�1H����3`�
��Zk�i�4��7�/0ڂ}�)8IJn�X���������WëN5 !� �u	�TI�b�T�:�T`J��*��V��f����rLw� �@�Ua�,.���h��Dx�E�����|k?@Ecxĕ�0X8�5u4֙jX��6`n�ۖL�uF+�v�8�n'\M���¢��{��r�f��v��`��@�{ޭ��JE��]�-
�1��P]?=��ψ�٧��r�{�����?l�(��Q�@N��a
����1J�r��e������m�J�����+��O�������<���m�Zx�Ɖ�@���S!�hн����3-��CV(zܺl�z��?�h����ƥd�4݈��5�j��T&[$�UYށX(X�g�f���sy�u2�6X�5tV��`5�c��x^�`�i��bY��\q���x~�DM�7� ]��<!4o]F�M��Lo��DIk}�4|
N,(h�����n>�
b���� ?
  ������k��P]��z�߈��1���G� #,�U���3���r����S9�O������+��T�E�V4�_�LF�~����l*E�$n�s�V,t��o��݃���ۋc܂�Cn�nD��O��I�3��j��Zt�c!�S���ە;o����@����<\ͮ?ΒC�1��������?�K�p�8oz����1q�o�=&��tt�],o0�=�^��p4�(^�qHbo2]LnƂ��~>0�?�2����n<�O��K'��]K>��v�ri�}��]����m����3�_~�wN&K���>�}���`������zZq 3%)�����x9�-�Nb���{P�Z%�W*���f4F���dL �ʥc��������Ć�̀F{�^g�&7_A�݌o￈_V�ś����@/O��0H�[����B0i^J�RV��E��l!.�Hڽ_ ������]�\�~;���DJn�o0^�*�OKqt��}}�I���B���y^�����z����@���	0Xږ2z�#��ʚ�k�8��a�jI�����*�l�H"����s��S�-��kx��8�,�i[��3q���V)�҇�Dy�E�Kl�T�l;��u�����&/�N&�!h�}ѝL��/{�O�}�%x�Tr������ AQ�&�)�����iy�E;x�{G�|P�S���)��'ln�g���y�O�t�12!��Om�\ �\���Ts5������D ..IgN4s�I�\���8>F�$�T*��1�r�\�9~�w&�=x[NZs��KE�5�:fO(~�q�Ke���x�{2P^�<�?݉+Н"a�<߳c���1u�C)=o*6�|2�'� 8�v��Q���x^A����8�~)���k�t��y�04.1a�go�5��3�I��]T5�H�x�����M]F����G� Q^�I��f�����<3Fzxß�P��K].�L����A���V[?��\�*ܡ�`O�`�b��-��s]�a\��gx��.
c���������d)>ќ<'?�#���P�@A bJ�x�ֳÑ�dm��#Q��{?�˯w�u��|T<StI���#�K'�ox����+�8���L0��R���~�*kR��w�KG;��8�{��2>��g/����qߐ��M��H�c=��^����`h{
F�|���/���ȧ��>� &�{}gzX\֪�d�����>_������gb���>�s&Z��{0#�4-���`d�L {��ep��IRd��&��~���
��������7uA��`@��	B�j�oaR���_�T+�B�g�?<�������� ��ڲ	�sD��X��ʛ_C�,�o��M�)ĩ�$�2��_P
�7Z�~U=<4B�ej��m���Hg�t��m����5��ֳi+�jV�C���ӧ����\�C��-.'��l�� ���� ����3�1�S.a�T�l��M��_��*�?/p�}����/3��H/��)�D�K��6�� �#R�vs	��9�mR�u�A��\�QN������)XÁ,���Vlu}D�|3p1_�E)X&xkT̥�>����>;ɷ�1`�[�%y_�~������h_���J&��ɟ�����/�>�֯��_[�*#�:4�x���E-��
BV�~��M�t�N�!R�.)���h��/:�F="y�*�w���?H�ol�8�/�H��G���S�SJ��n�1����(^����3�?�H?x!��I�x��4k��^�X?<h[�����/W��Bn�A`���\������7V��&����ѧ��?���?[������qi?6˦��93Y�?��F���3�m�\�2�����*�p��jυC�_�\+�+s����pscz��:{��u�$�E#@�Y�L����2&?��^��<q(w���~N߃�%`���X�=��=�L�ylW�Fo�CN̣P���B�C�}j�]Qa��+כ��o��Ѝ���<�XZ�n=�����Z��g�3QB-��O���H|�$����&�_�m��J��\�T2�~�J�n4ح�3��Z�c�����)�z�ƥ[�'zo�;�_���{�C����������R���Pr���u>�𭍾чxg�M�b]���^k�F;i�S�j�WV5�l\͟ƀ{�_����S��_Ztqo0�h�4y&�ǵ��\lR匇,6�>�]lh-,�
,ǚ.��#���ڑ�=��S�ľ�CHf���Q7�H�_4­��.OB�#���'���f����J>�YCi�(�F|�o��`p���LӃ�g������a�
��<�����lP�Z�W�y��u�vwoH��f~�4��ۦ��?��x|����1~���"�O�� I����fj<��G���A]�#�iu��Cq���7��J�cj`�Iu3J�󋦡��ڰM��nC���r���uzzz�9~�7������O��B�4�>٤�N/<3�����?i��è(Օ��zs�iMc�֗W+M�l߆�Q�K�4��/Z�NFKO-�T?����4�g      c   i   x�U�1�0���á1�g,���H���p��� qC,��X8�#�z��dKRI�$AR��H�$ �I��L2�H��y����r?c���ʄD'Sz�ѻ����9�      e   �   x����
�0��s����I۵=��@elz��*��W)XX'4���{�Je=,�1�<M$���q{ޡk�4���ξ2N *�z$�>gX�sæ����J�eTѐ�aE�a��é,�FC���2\4�����h������{I��v�=�}p��١������.5t0,�g�b�W!Fh��]��mC-�f)W���.��>��H      g   �   x�u�1
1E��^`���fLzO�Ղ�����GDa���̃�߯Z�/Z�˭�R�����:I�ZJY����-��$�Oj�����=9��{?�?Sֶ�@���A�#�1)F
���uuja,�ڄ���6j�&X@�	��s���M-�M,�	�P�7���-��)��|,0߀����b>�;U�gl����.Ղ|t��cK��^�A�J-�|�Yx��9���-�      i   �   x����
�`�����������$�J�мD��,���I'I!:��c�a$1	"FD�(�� ���!*�A6˃�	��q��u��&�Iތ�O���%�i��M��չ6x��l����kcː���E�	,�����MU�W��l��K��ncO�~�u:�u�����7�M@��a/P�}i      j   �   x���ˊ�@Eו����[I&]�	4C��E�4�!��?�0�ѵ�[��Uah*L���~���p:���vj� ̬��?�T g��ml$�r�_���\��~|����SF
�@YRC��Ӕ\Ś[:�r�v�&��'��Y� ~
F��ۥ;ޯ�ˏ�_�rS��˪45�Y)���!K����P�      k   &	  x�]�Yn�:���Ud}ak��HG�Ek2(�������*���g�bMTYU�,n��kx���T�f�1.v�ݔPk�v��e�������e{a{1�]ݘ嫙�>n~X���D�u�7�f�� ���I*�9�+dPC�ٮ�IC��VYH��܇�e}���a�5��<B�g��4��ڣ}y;�ۜ��̛���ȣ
���P;*q�C�6&T�Wp+�Hmv�Is�c��v3G��4Ƞ��&-O���}�+�*/"g�^�\A��&�0�q{x�(͓��֨xz��ڬn����l!޲�7��<˭���F��7�A�A�^�]�j�AWx�aﺩ�i}4��� �r	T8�=�2�a�aM2��=�7��y8i�s�>��m:Ó-�i��M�XT������u��Gg	+�]J@ԅ_z��`_��� ����� �8�Gv3�h��FX�]�1e8��ˋ��[���2+G�/$#��	��=�'��!5�$�*��6��R��󺗂��	�ҟi�z>�V5P�QԙŎ���� �XF�(�Tz��ET, �?#��{�����5��	r�����ͪ �G��W9´Ct�h,�i�y@��ܭ ��� e��#�v�N���!7�$���.*�0̂|�.YqE{MX�{�;X��O&��C����B ��mW5En���&�ê�o܈���ecrI2����z�k5(,�'�a	��>e	�2<�꒶&d$� ���&��̧���2���co�v�n 7��%pe� ���w�����J$�$��<�Hp��j�F�Z#(�܀����w����0
%"�e�;\>L8���=���IP*_ی[��(��9�\"���H\�zp��9����0�mP3wT���jBo�kʍT�)�	�w,��ܚ��_�N�r�B��U3D/>d�ZT�1��{*���Eǌ��Dg¤#N'��ʼ�kC���_��g�����yfB����
%�i�'Y�K"���| S�ɩ�o���=�����_��)��ls,qJnfFaޠ���^-���P��"��E�|��B�����GQ���ڏ�(�a���3'ݭ��������m��_�P}��ym&�^���[���45�v�9�[v�����R2LL)�T�eI���-�6���%��Gۚ���}\LQ�ۑ�$�::�#B�}�a��@���d�G��)r%�����Ŗi9���
5�S��n���bEP���iUY+u�Wy�� �#���	���0��v3��O��S�Z��1����x�5QMI{�k������m�D����nD��%-��3FoI�>p����9��J�s�T�i2U`�AZsI**#5ZQ��0�Ìv����Fv,�܄ĈR�O!UZ@��^0�v	��V��|K-����l����X�6����c����担��~�1�\e�w��>F�Bh��HK�HS�"͙����9����܈G#EBQe�1�+���r��� �.�McNn%�&���;_��E�8�t�2l�>����-�vRr�OUC5�a���<*�#>�l#�B͓<4]b5�1Jߩ =�&�n�M�hx�KD�os��t�X�s`O���T��B�&ñnGR�Yc���=�۷<�BxYu���ۙ�r����xB�V���؞�gV��#�=�\_X�#��a�K2�ɛ�K�6��L޹F��fe�k���U�4�1�4���o�%h�N
���>�Y�H�S*M�|�q
��D��;7��2���B�t�l$���a�G
f��k���Ť��j|��F���!�'L��f�|�C�q�8`�� D����ȕ�=ҷSP���e�1ҹZ}�)���)w	i�� �G@�G�	��9�ɖ�	P��*F^�6��h��U+��P Y�a� �Hc��#>C!���(���<�c�D�b��=�"y7�=�Дm�jӣ@q�'�4R��{��_�?Z�D�;�V��Z ��;�<��n���{A�|���XdFԜ�PS�)�]�	��;�y^�v ߡziBUR��r�����Ө��5�J��,vl[�yD��{��<
�����*����J��TN��=�t�~`+���D��A��+A�����Q���g��@���yX�%�8����{����Ǵ��9>�PJ�v��gX�.F���N�����!�jE��2��	J�?�|	UYzsycV�`S�S�4}�]Pg���^o�Pg9DCF(��k���w�+�s<)�)C��~x�Y���v:J"k{�����������      l   �   x�-�K��0D��0#~	�,:�@�Ѩ���9�����r��h�ӻhZ##��y��a:�/2u�8#z�^F���X5���u�Ū��M��6�8?i��+L#3V�BK���3�s���H\i,K�Ww�zē9���P��$u[�`K	�2݁H��nL��TK�{�����Ӗ.�V���9��'E��+ъ����Nc;��}�M\�s�Ah����x;r�����ϼ��Z�]�G7r&uߏ��)����[�      m      x�t�۲�:�5z�~�y�}�*&g��
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
&%���w1c�='�an���~# 3�Nv-�� �T�]`��>jÃZK��e��mV�N��BT�`����s�x���{���X��������&2x��*2�)�6�-�a��g����A!=� �l~�|�,f�i�A�)}�T�Ђ�����"�;�5����\^   �^�@���Q"�Q�3��	R��A�Jk&�R��cT�ń8��i��!��wF���6�q�\��"}n��s�5���/.�|=�Y#$��LW��2��N]��wwI��r�|n�S�sk�z�n1�Y��^�D����a��\����3�Ξ��ik�����_N�0s���[�K��y�Ї��r�}�y\1<��(G���&-�`�sȐ1�3�g������%1$ϘsJ���v�B!���_}���9hJ�Ϗ����Q��l      n      x�՝�rG����S���=��mzd�2v�OsA����dz�	��"=HfUz���d\��c�?6_����[�^����3�΃?���_�z��_|����������]�ݽ�z���?���ŷ���|�zQ�� y���/z���O���Ç���G�W�A��pn����7�?�����g���>��Y�g�l\*/^�y������+�&��s��WŢm��vk>kBv����>�^-��tqw��������w/>����n��+e4��$����voV#At��٩�'0����	l21�������A����Z��I !�W�1Kb:�`�y=�H�\�w�JG5b���⹵ƻ���G7��R�k�H��{
��hJA�֍�&�c<u��z34��&�cmh2h�
��������˳�Og��|��db�D<�b0��ub��\G�8zȱ�d���w��5��ĺ�Lv�M*����(�u���5&/��܃��k�6R艡�rP#��<P��*q��c���_?("�DVUu�+
y���j6e��No" S����No⹷q����vq�������;���ߗ�>МN��r]�&=b�}�i��p�N��yך��ȝZ�	�xԓ���mL�'� ��eZ!lT[!r�e�XW\��L�,�C=5=:˕����Bg�PԖ���\%&����Q:�+�>8M��N�
�9��6�E��s�l�^k�,���ʪ[ ��o�ջ�)R��h=���4���4�T�B�Z�l����jS]PmԽ�.R�ܰA�{���"�����?��u���Fo��3�\��s�z+勮7�)uN�5��/~��V������	Y���xڈAm�B;UB����^;EB:�Ũ2��Ԅ�zp�xjoҹFQv��=�� ��5�L Ѡ��8+���E�s�9�L��������ۋOWg���y���<�/?|}qy������W�ng����_w����]c�{��Y (LhzX��Xt�Tށ���6=j�r����j�p�G��۷͈_�{w������'��g�o�T��S�{ÐVZ��uJVKX�g�H�:%�g�h2ze��`�Ja� ���RՂ?G0�Vu�KM#`�HE���{�X!����/��K�"O_Dy�R�*�����>��0\L���GDn"u��O3-�������I2?��|�Lc�>�kO�rF�C��1�i��:�x�3���a�+a�S
;4���������Z��C����!*��D�=�.�#S���?hh�-$t� ����o�HZ�z3	{^��B�-�vƞ����۫wW���:����c����~��ǫ�O�n�~��﷗W����߼������ہ]7pW�\H��@������R���h�Dz�Kq%צb����{��/��v��e?��ꅁ �����1�?�վ[�RL@r�(��R�]��-'Tq�fv"��V��Ҕ'�d8��O͸g��@'虄�{���%��s��Q莵��g �2������iK�v{K�o⨽�r����ץ7DTRYt=�թa~ݟ�=�<�˞������?��^��ˏﯿ���5����Wv�Ь�S0�2�V֏&P8� L��O<�~)��˗�i��G@�&��P��Ir��:�VCs�֤z��ܾ`�`i"՟�پD��ЙP��W?~�pX�N-*�1���_}��F�F�c��2�dFr[�Ip��F�"m�n�Y7��E�e3��: <���)�+�]v���4�Mu}Z��:i��o���[�v�rݣ�v�f&�� �훾����|���-MN�ya�$y�����Z��(��[��ɢ�%��+vi��F�dFށ����5���H�'��n�_��N�(�k��^�Igtӛ�f{��E�DBz�s�?��t�����V2�d���c��13���C,a��Yw$e�qq	3Hf������/a�dROݐh�!와Uy4�6
fݾ�#�*3I��	���f�!��H&��aR�C��̺�\��,!J
�3(,�_*T������P�
��w�E�HBG��A�)E��l���2m�Ej6����~��� ?�&S'�Y�̒�K�c����������������oo��:�n9'�����\]�}��_q��ج"����Aovk{&�����}W�[�úb���r��:i�-�G��4ߛ�m�4k����\���aZ�y�(u���e�'U�Y=4��x��%S�bO��2z\�Q2�S1>)�p��,�Խ��ۥ�yK�{fBgH�2����e��Ł#��䡽���q ���*ی#��l�}�X��>�R$q��z	F��p���p`�\��P���>���^6�sL,:�>�=��T^N�|��E��_���./�=̊,�ؽ��{�`>�t��ks�H��e�$7�����|�[��πC�E�nS�'1���0Z��Hw�S�;�y�M�5��<�L�],��r�4B��@/������{����՚�i�M��v���,�����d�\�-="�Q�+�ޑW:()���\r�����V�z��A��Ap��I���u��s���Y����9�?�F��+�
��+�C�D,�J�B�r|W�� ���hR�^���*���WY1@*U]��7�JR��C����X�%�˓cG��q�� ���!����L�`�Y�^��S쉎.��kj���OJ��R�� �x��?�-x�;�Ƚ|�
?.#0=�k=9�g�h<G��#�x�$�^q�Z���^�#��e��7pHX�@Ie0Hp�ݣ�����D���Ň�/�^��I:��H�%�$����ũZ�0sϬg�D:�����WȀE�U�f��L�?��vE����� �il�G7�+ċ����KT�{&FCMj���!��S�&�S�2C	E�G��p'���J��.���S�c�L��F�f>����G��=6�����3���'J-��LW��Q]�T+Hv�m�,7I������$Ջ
'��Q���X��t�aӂ��}���"H+��~�;���|`Zm=I���X�
�)'ȑg�yp�f�W�>8�`������.g	�hp�W�"���8�z^�� S�`��>Je'���b�e,�\Oy�Ju��� ��o+�z������(�`)c!�˜�G����L���X�2�ar��ou��1����'��1����CV���_T?��ԯ��/�����\,��xN�^�`)Y�!$��o)Y8�Qm�*#��]%W�>��a�HV����yL�~�'��ځAm�*��o���L煣�D����w���T��vJyx��-X7�F:������K�^0��ѐ���`C�|GCamz�	f3�k �0�sx`�|�3�pH����ƕ���!`�s��r��<���)�K��Z���P��)�� >Y���MP�I���P�k�����r����&��'p9��uůӁ`��1Pts�SQ����Ҫ����3�9Ձ�+�$�����qE�̱ ;B�����"����/.����`����9;�t�	\D�D�5ڏ�����S}IC�t��4)4$�p��ŕ>�4�Ay��3��y���4.�;f��Hɚ�FL*�N�J��]a ���~����| K/���0�Yn�l^�����γ�[��7�`�(��q3߁���p���	b=]fŅ�q.��E΋���aH�k�%��5̨O�k_����� �L�e0�!�����<�B��st��/��� ��:��0��i�TU�Ը�=�	R����<���R߁��P�˳7�[&8R��L�j��oz�xq(I�*?Oӻ��P�I;~�X=�1q.�[4		��]��tk]��A��BDg�(**M
mD�+v�|�xy�^���ǯ�8tn���o5x���cǆ�e	9���4!�Ȉ�\L�}80(^r�\0SQ@�S1���r�7k�GD�t�Q�i^�`L�t�zLڵyf��LO��5�%����W�_űz�s��xzL*�Yf+W &�Q8�5����TP�]�	h؁    � ����&�h�S�=M,Îɑ�������	X4芦w@���&�I�{�Qu������&��ެ�֍f���,q��
�KU�;*#p�w�)��jMm"�����Z��2UX�+S�e��Wp���9�:�%p�F�H;��f��MD� J�8��8�#옙��1ivj1/��8��=jBvLω~A�ɻ�>���&i����{���S�&�``R�dP�O�07$�L���M}��%3�C����_�9�f�3^1.2Hf!/'�N�(��y=&��|W�	f6�zҮH�,�s}>���|W�YW�x��H�?��NjV�ҬDK�=�`��)�>x�Ѯx�U���"Օ���V�⢌�s��+sֈ�&��qȪ�ࡸL6��̀��O�(���0�U�~�H�,���tE�fy>'��U&�*C��aEqϤ|G��'�
l�,vf�Hy8�L3���L��5��56��Kdr�ǣ
o�O	��!(N�(�%��p*�;0�^}������>vC}��]����y��K��*$���M\�=�Ц4aS七��4RSZ�-�ɕ�w�E[$�����zuyyv}��#�d]^.���h��j���Oq�x?G���I;�1��s���Yu"�{�o���F�XQf5�6�A��[5�|�莨�4��(��n�>�d��'ae�H���rτ:�g�ܑ,l��i���J��H[<}~^�h���LMD�Fc#pm5�8��K&�c�c�~�Լ�9�"i���Drvu�� �|�g%��g%/��R�ZS�v�K����k�T�!���ʻ�L�f�e�JRd�f�Z�x��A*��%㎨0<�+W��C�bH?� �U��Q�&r$�G?8+��Na�=�����$���y�9�%3q�8�[�P&`T�T����`ʽ�eLX���&�U�]����)��Wp�@=��� �����_i(q���W�(����KPH���&`E?�"B�`��z��r�^S�1���%Z�,�6�8��8D�Ü5����k$�5��k?39fg������윧薍�k?3=EԕKqOٺ�L�����c&��`mh�3�L�Et��޺�LG�����>G'q���o ���*n��?01�)�n��ȱ�P�B=����'T��D�bQչ��@�M����(Q��������(ѥP2�9�0JM�L��N�7!JM�P.o��!I���z���'z�09LR�( 4���L�B8$KPL��I��ϬSe�U(R��zt�9�0Eɤ�@C�h5f��L�\�p7v��!e���]��ؖ�Y?հo�F�_�J3
�O����(k8R�8ś��%3q6x{����1TV�D��<i��cF�f��c<�,a-��,��[��"NO�%�0Gɤ+2�4�9I&��!�t��ϽE@�Og�XC)6�bg\Rܾ��`��R�'ť���)�S/���;����z��N��4=IK�>'S��E�&�L
��g/&�k�{f���閇��E���OfQ#�C)<��g�]}\�`"Ǒ���3������q����:����k2�d�PSQo�[�����A1�vl��&��G���u޿�DY/�6Z�u�O;@z�P�E�����L\C1�B�Y0�sŻ��:��]�������?}��x�����l��_?R����;3V��[����\"3Ŗ�n���|�Ut%��=#�S��mg�	+�H�>0�N�{f��(8���O~�� ��:����n��4��~��UIl��f���XNpW[����F��k�b��L�v���>����zY�(z'��3Ny�z+�`R�ihη� �\�����EҘB�Nq	�X�
�9*6g'o68AE{���c4��(	�8��Wa�gi�*L�'(O�"�	CnZ����a�ʪ*�Gp=3�}�N}�d�u/��#a�!iж;� Ҍ@�s��7��)�C0�G�mgHeR�+�� ���K]ݒ1�>�BRɴT7�
��1H����S���ß.������<�����ŧw�� �o(@[Z!尞F(R��&���:	\4���l�MB���qS�O���ĄN ���Ӯ#���L��.��;��T6Y�ia��r�H�N�2�a�.dA�"e�(�{��R*����I��Jgi����xh6�#�H��"���>�o[��?m�u"H0r�0/��5'�����(���ޤ��1M�
�
��Տ߿����Uid�\rT3Tb�]���Rz�8��
��4$��}���Qʝ:mTG2J5��ހuJ#�� Gf$��Ǳ9N_��U���q�F�Ӆ�C��Զ������/�~s�=�<��(l#o�2�/[��FV=0����s=J�4����Yy�Mc�
�@R�֏��CU��g��ܞ5)h_H�����rp6{��ua��#���e��w�nW=��7��P���p�=�%���jo�R�\�Sb�Ϧ�ZL M�t��t��[X�st�Ѭ�S��x{�j�Ŕ&�Cb�NM�������0�.����履Yʬ���9o���XRF��M͐�I%sє��E�T�j}�v�!Ւ���~�ۆ,%�\q������b��;�������RI�J���Lu��RQ!r�8����o]��-[��<5$Rd�pB���D>}�x�&rb�,�k[�T������e�HmF���;Ge�c��,\�)��q��<:��"�9K0�R=N)����J�J��"5�����"���ꂚ��R�K8�:��&�ᛧ/����{��ƢS�⻿�ϛo�_8`'ވ۴��-��9�3:��d;uc��\�H�Hm�G����$�[�Ԇ{�TF:}����-Zj�B
����rq�:�0zG*��h��	)�0�rAG�R��Þ�]Pj�B
E�4|�)���	���+���/g�Pg�����A��&d`RJ�����L�3�)�ާz���������m�;T������ƒ�����������FjbEvVyZ�w����3)����'@Zh�����3O�3�4��U@��������H=����N�RɪlR<�<�zYW����-���%?����	�)j����:�{���<�W~������&{c��Y�f:�g{b�:Mͤ%4J�-0�^.���_�DfuʛIo�ר����N��������К-�K.r.7�eؗ�YU��f�\lo���
��ݑU��l���Ȱmփ�Q��޸�x�A2i�`J:<��<$���3B�nZ�#��΋(�"/7
�����8�ƈ�ؠ���梨�W�J�\�Y���+��q�rD���o�B:>�g8����	��,�(�f��Ե!���j��՛o^����oU�W��F�U�@o���X<��@
%*2.��֛$R	�L<����(u
ǎ�
C}����N�q��(��.�q8稳��Q]�`lD}6J��)B�3��4�pD����J��L_L��Y��ʲl7�R��g��mR��60 G�Q?61�����A��K�RG��(���!J�]yb؀-���9�p�Ζ��������a=�g�h���IW�S-J� E�R���R�(Y�c�����<-n��!)�U��Qլ$������g
���ߘ6��b�V"�~�b�&��b��t��,ټ����.�M��$)Y�T��D��x''ٞ��%o�%/ٜ�sФ��Mu��qy���� R&0i���HNu	���$emX��k�ܓ4���#2V�7t,d�ï茥�����6��e+��\�z(&��L���Gdܞgz��G<�Z�<3H&P2��N�@�4�(�SP�+G	��g��/;9�̪@�8��>�<��zS�q��;*Ph��#Q�
R@rþ����|��ts{wT¨��b'L(&���	N���݆mG��ގ��a[;Bo�Y��}&Ȇ*�}0�p�\J�k���X;c�syx#ђ��z���Q	Nk`�au�u��ȱ��DC�I4��Z���/R]����O3�������K`�Y�K�ohܺZ��]��`\�O�kX��=�h����{��a�%8��c���H��� �  �l�ys1`��&��51?�R��>��)����D�`���j;�ԥ]���k��%V}��;k�_'u�"��X]o��:YB�Ny\;Y��@�@i��]'Kh��Yv�.QE𡶕*�&z��hR]�0�]�T��5����es6xKɾ)~S(n�fn�	�;��C,qt��iU�Ll~��(5�*n��~f߉U�ܧ~�
���N�"?��mox��,qA@�)V����wJ�8���},f�e�����^9��cv=��+���ߒ�JI�V��>�nC�
N�jP^����6�����un mLAؕb'?���К�؂�%v"ݖ�Ӌ��m� 3]a���d�ۘ���r&wr_����mP���`[��y�$��x��v���6��|xz�����S~�����&`i��#�$��ty��N��"�=RD�~�A�9M��G-�����;��76m�p���of�-��0��Y��(�'�m��*����N���"�Cjvn8T�m��#����F�7�3�d��j�a�$���^��p�=�.W�o�>�0B��k3Ĩ�I�#BJ�Pߓ/c�l�j�ԁ�Ü-��Ĺ~��dё��-=�Y�����[������;kG7ak�'p5���gzo����=Z�0aF��u3�>���)<�����bQ*!���/Z�����͈]=Om;:��2M��r=Z)e�(�b&et���ru'�;��>3vK�:&�.��Xdù���[��@�c-e�Z�Vg{��b�/^6t|��ƨ'f��q���#�/��Q�`�a�Ґ!#r�`��P�')�g��eG���ȩ]�C�rJ���tS�-���Ds�p[�A��B��L�,5������"�Ǘ���al������7�6�965��i+�H�=�Q�Ӥx�F:�|��Y��l稫��b�}���Z�rS�oZCw�z��6������]O1���+�N��f�̸/�`��H�ǘ�������F`h��S���Xt�h�r}q���\�8�_�<��g��w>*(�	i܄��j�P�`�L����77�h�\�K��Y0�娒-�
e,��K����^DK�V2#%���Lc����U�Z �&9��f�x�7j�q虘�9����ł�������nŢ���*=�R�w�mQ�Vh��'Dog[�Qz�N�e��<+&������P������<��\g{&U�Mz鍊s=��[׶���櫯��?�oh�      p   �  x����n�0�5y
^ �\}l�Q�HU��R+U}��ꢯ��3��Fa� `���ሉ˽�E�q2�:o��:m7��/85�
-���y��2� �x���㎣��4����;`��)��w^�=m^���x��\V���|�W��q//���//���ʾ�&��ɯ��7��C��.Jt$��L+Ѫ�J��D���!��*���$^CX�[Ƨ�?����TW�wG2Ɲ�l	���k;@����	^��=�2>}���儒�Q��+7VuK��#H�M��H�,�vu��5~)|ϧNy|��X��1m�F3/L3
Gb��p�h��u eG�ۤR��`�-x��`��,�&Ϭh��饸x��ʃi;����En����u���&��f�YM�IQu0����P�)�migr��7>��ʚ4�B[�"���D���W�P�Y=�zNA�m��,�Zcs��Ya��Ą�-B��E!�(�]��m0��/	�]T&m�PT�
x쬺��m8��d�!5����
�7��Kh��+>L��b�C�!oBC��n��$�����jluK���m&�q��s�g���9BC��n"�A��-3��R�=��g�Q���E�^.#aQ9un��y��Թz�π���p���f�
�6��������1�gT��VY�੭p�39\�m,|.� �^�߮���*����ޛ9i�c�?�!�Sڐ�W�Y��moٚ����X�	�E�ZJ�w����}��'      q   C  x����N� ���]�i)��n��c�.���,S�����o]Fˡ������`%*(*	�nOb��B)�rs�v�è��j�N3i͟���m�^;M�4ͪ�{X�^��L�?�mO��I���!9�`��o����Y��Yoro�(���@�qvƋ<z��`��f��"#C���� �v&����Mpb�ǆ`b���0|����˝��𿈫x��v���+�6A�v��E=u��N��$I8�֔���v�!�U?]�<oR3@�'=�D��Cُ��B���A�8��ܣ��n��
�����{�مq�����M$      s      x��\�r9�}��
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
>����&��yϖ��HJ�H��F0A7��.�h�f�pH3uv�H�ͦ��I�F�)0�l*�*x)�^P��6�J�k���Cv���?n蠥��@ߕ�Z[���	t�Җ���S);��m2D�hST>bS���x^��8tiIi�l��Q�+/勹���(հO���W�y�Nl�,:�X�\��ST��o�G��b��!�>�*��JF���f6�&*h��Q�Z���:��J맿M���y9J'      t   �  x���[o�:ǟ�O�/ pyd��n�4T��<U�\0!7H M��ӟ�%ĹР�2
������O�E,�`D��rl��֫�KZ���U%¾�@��}ö&�eY�e�p4�����,{�֬��ӷw��e�P<���C�
�#���M\_���V�[��b�� ���6���#:r� �0�d�P�R6۱�$�&.�L���EjtbO��*�w��c˗w%�:ٰ8�$m��[Q;�e#y�^����\���i1�3 ��<�.�iS]瞍u/����I"��=E(��nx6ƽtR���T���+�.�`i�?�F~`��s��(���G��k�L"*��B�¢��=6���������{�`�sS��=�S���r1����XW���m���~��mv��,��O%�~f�⽙�G3�>Ӣ���9(��yG ��sx��v
bg��E>�N��ۢ��,K7��넺�%g�?�9g�耆m���.��.=َ݆+ȧ	ߪ���a׏���P'\W�z�]�[��kլ�L"��3OO����x����"�m��Ü�ʣ�"J��
�� �B�N,�%�.��	U��}���*��o���`�Ƨ^*��(� GZ�0=j�L�*3/�Ģ1;Ye�G�ɯJ�_LEˋ�q���-��"
/�R�����9}��`���Z�S���N��NPL腎��4�ټ��0�>P�B+_Ʌ���O
�|$�u�` �CǾ$�{D*l�CA�&��y���GQ�KV�t�P�h6(����]6໖Z*�����k|;n��zR֦ݛ ֵ���I�[ ��K��Qqy,��(���۲;	@m(z�u��&҇�U.�P/Ŭ���}� ���}��y5�xX�N�dq�ck̶o� i��:��$L\��}��ix�-�&l�	!Y3�@ϫ+��%.g�!�A�x\u�k����n�����.��A�!�t�Oۊr��'M���N�~/Wp��=�v�@�s�������>��|xx�p^Ey      u      x��][w�H�~�O��3cBUq)�V2�@�"i���z�X+�eG�'��.B�J7{��v�����|��~񼸘.�۶ɇ�8�@m\P��g��Q��u<�7"�vi�E�0�"1��ilL�4p��i�,|S
�/�Il\E������$N�4��2�g~y~\����w�x4��e��5��afv��O/���x�-n狯�|k6��ٔ�Kf_ڶ����޶��«�	�������ujS.{a;&��Ծt|�g�q��b������]��������`����Ŀu���?������Ƿ=ߘ�⣘
s��Djf�D��x2á�k�:b��0�k��@�6���e��n �8�v��0���5�������b9/�����l���m�N[P�d/�a��F���qH�Q�#�	R �ٌ�����A�ㄻF&��8��N7ꦢ�au�b"�8�� >za�*����>D�X��ձ�.��G)��7Mz�5|T��ȢQl�"��6�Lō"8I��9m��М���n��a\�8���]��na���r��pm�5C��$��^�G�����M�S��"�-������-�X�y�ޥX�S�:* }���R�?�r�4@r�P�@��Fwb@nht"ѻa�9�G\x�IO��ɍ����3�)#
�!��=L,�E\߶�CJ� S�Ԟm;`ޒq%����c#�n����$Ds)O���@�wD҄�5BIUƱx�Pf +>eG�$��d���^�����J ���1M�AwoDu��aDp�{O����v��B���$�v�"p�����c;�<�� i��q4�+�k�k�@�U�����!f���b1{.����% ���m�J�L�������g׵�Ù�*z��y�D����:	��8�E���(n'#`� }p�>��@-��H�	8ݶy+���=`!P%\�J��fQ�ٜ�k��->���uD(�k�M�s$���Nws��m�S8.�1%���D�A����O���$6s�QqW��
P�#icHԪ
���	�"�-����:��N��U�i��%$F�#)��3���]%��HsXPܚ�;�ý�/|7y�9[��3���余����yu����Θ/ng��?���e��t�J^��y�K9!f��8��rNԲ�l�-�����l2�:�;�Oe�R1R��d��`�st��C����ۄ}p|#��&�M?2��7jF	u<T�(�MICȵ#���w n�Z���	�D�����D ����9�?�&#�T�?�t>�\��� A3�&ă�/H=/�e�Fu�a�Gk%!���1���Vv��L��ۦ��f�����2fQ�.Y�B��} t�O�O������"��t�<z�2��-�����4���"N!^4.#<�W�q(n�����X����qY,�oBm��.�o5$?�=R�K�-N|'Pf �Z�x��لh��e���w��b`d��75k�Am#Lu�!
Z(��}�� �6���/�*�A��#yG)-��\ڞ�"6��K�:��$8�|�Ī8�v�e�g�%:n�}����b�3�݆�˨���,ץ�i=��z|9ب��*�s6��z�9�"M[�v֏��*b�E���\�Vd��j�2G��ꑜ��e�%��ՖзP�rCj��_�j ���!�N!21�n"d�:�{������g�'�L�a���*P�7w��&p�/mj1�0�b� ��OS��ܕ���;W|�M�MlG�o��U!��ă»��E+�������4P'��j��h!�p+e��~�خ�e6�9 9N�;	�(F�0�,�P���g�C�v52
��e�П�h�F��(R�%�Q��i��0�$��S�Uj�G;h'm�[f��M>o�%�C1�Z�1(6����VL܈��~Q�c&�'���v>�|>�'�h-��=��ȷ9u49
��%�������~Y���Y�������b�>ޖF� �"�#4��}�c�vv�eYK U��h�j/k�d�?�#��It�R<��s�j9�:�|�S#ꎶ<&b];�a=��_��e�l���$�҆S��溜v�Ցxz��������YT�z�Q_@��F��o���-�8�r2��h
�4kk���wo�_������ڻTH��2�����j�(��
�T+�gpTH#�zO���7*Y,�U[��M�^��iO�!W���SR����ԵOBbk���Y�%F�Q6 �2�f:
�8�,_�|�G��|������gY���B����#5ٿd�E�tj�q$M�:���{�ǡ9@��ٌC�~QyB�s�|zY�^�$�V���Z�����G�.E�%�H��!׮k��o/���~�!��\��RG'��9�s��e �.q�f�%�u�!�Ҍ�U?���8D6(uƙ�� a�8�����*�0 �>��F.o�7x�J�W�-e�~��蹫x`LB�dnZ�}]?��\��>���9xy ��T���
���s��晝�$���A>D?�}a��oC�����{:oN�. �	���+1d��n�]���t�6���½�X��\f�;���G��X����7������d[�1��n7���lj���i6��8afe-/�^xn%R�˔���-���A�l#z�������l�Ø�*ӂF�a�v��fb�Us��$��1V�Ѫ��b:�v��U�Ss�Y�x�E���Ĥ�����6�%��"ު:]�F��գ�e�jzZ��8�����x�7�Q�4Xb��i �n�}+k�!�hB�%�N�f���7�s�<��N޺I�C8uq�zH�6�,P�g�'�oS�v0b�b�V��I�I>�b��TGa>?���e���0[�`& ؂��Ld���d�1�7{���	
��ė����8H���]j+"!��67:�$/�ݢql���C+������^	f����X~��ԱK۳8g:���B��W^���e�6:S�L8d9�1@������A, `-��4aս�����[fR0�b���A�Ψ4h1��7U�ť�T�N�o�s.���q-ϖ�"p@N��f��5s��{�N�>�A~п���e�rp��ҵ�7p#�"S�!B�H��������QQ�(�#;��@�4h,��U��6�T6��-Ul�u�O/��_~fZ,�3)~ߍ~q_���-᫧�
�H�5��yKb���l��Fڨ�5~w�M�e��W��{As�0Ր�/))�纜y4��u��'�����;ԃ[�� �k���	���`���Fe<���+��f|��V��2o�$���XzB���ֵ�u��v��>ʋ8۳9G�:@�090*�.C��L�e�s��:N�ƍ��vK�)��T�{���+�J��`#�]���j���/�,����BL��Eb�K�vV �Hx�� ��V_R$��ّ Ӹ���#_���u:J?�'�Od�X�#o��5�μ�1�M¸���,��A^¬�1^�^����g�;���=�8պC�3WڝC�� *�2�H����oBA�Z�#��'b�]?�k�>RZ���G
��x�mcU�N\' �����i��P>��%p�����&���!B
.!T�a���ݏ=���~�37���V�>B@��}�-�\��N\���0���-*�t~?[���*����������cL/>?���W��)�K;�b	��X�,��`��"�!G�Y^�v�zP QvX�D�*=��le_�U�,��[�M0Dh��A��e�Y�Y��c��T{j�X�R������7���k��J����BhX��5��O/�LmE��x�^>��|��%򱅑Ͽ�����>Sc�ȠgP�r� ~&6���*/��s�î��� T���y%����Jf&�b{����A �e��/柋�9z��Ú��|7(�^��7�t�p\?�V���\U�k�:�̞����y(sxb9>���:Uao<���#9�Lc�E�(�� �
  Y(�j���#ͯ�QYG��=�Ū8F�X�S���R���$r��c�B<�6���<:�����R
������VRx4xί.�&���Suxb8�����
~�f�r@ �g�^26F�"���>��<N�
Uqi��Uq���8��rjJv���B�:�W63��]�S|~�/�\�r���.)#���5n�Lv��۲��;v��Z]��Kg@�2�\�R��7��H�6,�i	��Y.�_��U�˪���䒹�Bjb�xݏ�?�SB���'ux9���J��؎����iI�<�ȨX�O�.�Ȩ����n ���=����eQ����.��d�Q��0~m�N9	Wv_s�F��%�
���Pz�q�A��O�k�	�M-��i���& �>4Z�+�[��C��,$.!��Н�0H9�^�:�0�E�H=m)�Ǐe�Y~~����1yQ�h�*�&~7q��70� ;�nƲ��lK �^$	����'�q��.�*/�c/�&�?}2�b�gG�9�va�P7�\~���J�:ubl���DI���f¤��Bt:��let:Y�6i@�l���4�fF0�F������W�3��'��	Q����F�(������ֿ!�h���'}i�@����xzf�����W���TN�=��&����Ж�v�������[��^:�r�@BT΄b�4s-i����FP��Jw�ؘ9��F���A��v�CM,�c��/�/'�O�����\=���2P�	�ÆW�����d�[�w$W���]+H�!��*�8c��RU�K�L�6�1ZZ8�W�w��V��ͱ�O�zx$\� }�H3]�6y8���2Cd��> ���J���@��t�/��`2eUܚOUN%Z����g�M'�zy����l�ǌ�6�b��U|A���t���s��Q����l�rZ��5�O`�XbT36��
��a��%R�Bq!� d�PH�?� 8��*ZI���
V�����Y=H����;��A�K�`��u���͆��|"�;>�@����نg7���/����̎��y�����U�T��e�����9V �q5�Q.I#�9�n�S
�� ib�����={�@zG��VU5͖�J�H��Z��R.Uh�O��Z/N��
�b9a[B��94�ܴ��+B3[&�ښ�O1�Z�M���{��\��{�o�Mh#N�:�z$@d��;�2����xFLqw�h{x��eJm�d���k�fR���*������ȭ��
?����o���E��®}��r�� b%�.��f�R�Y�-E�	fëgG�����i,c��e �=u�8l�R�n|A ͸��0����f�=L�b;.>.��q��.���^9��t�ٴ�%��M�K�7��)f[��V�S�oR�+a�E��(.Ǩ%�0���.2�t�4������%� _?80lܤ�dQ�f�&�\����u�"g�����w.�(Zv�<�� #ZI�7��@B��>s����ݜ���:v��r�v�2a�(ԕ7`�c��-T6,RTF��R˜�*],�Z/� Kz<���"�l`�'a;z)n[�JH��eKY��Y���p<q�l����a�F��0�^��Q��b�G�O6kAvv���e+W;_̟�ۮV�� �!��\��>%�=XDo �b~�f�]U�,����L%�y+I_g�����݃a7������s�
���h*͘Ep�סdtS��F�9��~����,����J�l^U��uCBw�4�I�IS�G��\~�M�ql�*�k?��m;�H�rurCiZ��M�W��ֳb�3���h`߬ �pM�P��m����r��4p}͞��	\<��)p1�5J㩉됆����X�7ecmc��:]��y�ۋP��jd�,�l���Lr��)��9��ku�`��[c]f��8:��g2��nd)��#Y*2�L���������Zd�;��}d^���f��&h��4�d~����u�	cN+PyWY��k��� 2WrGG�NZ�Usa�n��v�������+ar�O���F9P]�
��}r�d�a�0��\�-�	�fk���!6��n_�3�2�ǡ�iYxl���}&I<��ŧ��J���vx�t�f=]�z���7���LQB��s� ��T�3Q�+%hl���^wC�ַɯ��S�	�s���E@�4m��%��p\.�r�\H��e�M�l��ԧ�V돇��˭��.f� ������#[��=u)B��Xk� ҧA�'Dv'}˱�u�l'P�r��h2�d��v6��L!��R�^��l��|�QΘ�bu�E�u�ߧ.���鴽���a\���'�}E%��n�������qj�\������#$�ٛ<���Z(-&q8<�(�(�8 >r�ڨ��U�P��M\2�����́?��wcP<|�:�Զ��@���j��uV��p�G���̣���f����i�`t����Ot�KԖ�����*��/FX��S���X�el<=#�줫�fQ;Vրd �'jń���nuv��JY�e����a��6؝����ذ��B&�;�ypl⻾9�=��~���u�N�c-�,�eT�� S�sU-(n'-큑ŝZ!��K���x���va�')w|�b:�݃�srA�m��q"��C���M͵q]�D���K���@*+> !	#K�}��)���2�>�a���w���|��(jU��rZ�po�NJG��y_��hp�u<��+�X�@�r>̡r����,��R�?��~��� l��      v      x��]�r�6��=y
�������X;��FN�nj�\kbkmKZY^��v��!H�9��P��,��>��w@1�4kc�ƝnL�8_C&��ý˟�?W��5���%�5��vw����5���e}�nv/��޼��y����Us��~�jw�����?�o߿�[���[*�}��?���_�߽z�����}����&�0�nc����������v�O������Q` _�#��ݯ߾����CC����b�x��ͪC_���տ�7�v?o��~w󰇁+o,h��1z�
\�n��ۇ|�[�?<��1y߀��O�����;�}ҀOC�_��&��_�7-z7�>��#���_^-{��������[�p�m��,�h��}�n�3���O>�D�0�O��1�B����H{�Y"=��kE?���@�L��e�|,�{����g�<Aq��w�����?/���|rަӥg	~7�O�����ϟ����y��~���ɵ�_�����M�I���y����f�3��/����e��U�x9���������~Q�ov���k��ױ5֩��� ���;?�B0O�����j��}}-���@�F68n,T�e���ow�o�b�����4��qC�"B��;"H�fn�߱}"ד������l
�P�H̯��Y�d<��ѥid����*Bp)��� A��������CS�fcl��w����O�J�������%�U�r���3~�`�c���_����|���حl��aPZc������������#�\��gk����9?��jnklam���_�q���ؚ�n�F�'"���T��*�d��a�NĚ��#�;��'@���q͟���A%�a��C�di�{�ᷧ1�p2���ʨVz���32��	����
b�4A��u��u�A������������~6����Lfo �L���!�EҾ�}ך1�p\�� f������n�&C�A�0O
�ҝKs��9=������k�U��|�6�+��a��fU6F��+�`ǩl��MRncRźl!�9�ɬ�w��*uv2n �16YK`���3O��W/�O+��d���=��y����������]
�P%��=wJ��慶����Y	������A�<�������vd5宓-���>y2{ �u���S�<�z�D�S#�ק�꾭�CݧO����a�,$�v`�|;��)�.K�0�j����c#HY-�����}(t�t��bf O�đ���=�~��'�$���ח���n��k43�>�:��#$^�}�����GC�,��h����R��p,�S�`ZAp�9HGi�u,��&��p��nU,�
	� mO�7-��11���XZr�{�&�����!)J 	h �P�H6�y�8?��$L�"��o|�g�צ_?�o�M��:�� L��'E|&���ka��[�4E�� �Ľ�JE<26�pz�Ğc0V��*���׋�כ҂����S#&�ˮ��|"+l[������[����:2�e�D!���B��]4c���0a)�~=�S~O}�0D:�6����t�*�aǨo�����2��	������Y����q@��b���]����#2�/<���f���ý�C���!����RQ:?"�h����:��Q;�>����m�kg�b��+���}�_�(߆�2p�9�)���P���������9�4@o�,d����9�����Mg��������/���8�4j6�Y�B�gL�cy�"o$��]����2"���~a�]̳gg����)�*V�X���GJ�pH �B_� m��%�&\SCgU�q�b�BE�ײ=���y��ߪ��-�.��߫�H�Ux�؎5s���w��^��^MȋS3�T�K,��Wl�mJCńs�/���98���I�9������8��UF��BQ6�T�Q
��S�{
�L��I�`CtbG�.~{����T��rgn�Nk�Nc��V��k����>�l58���xf�AJ��A�&n޾y��wd�1��������v�ڨ����3� �3���1e����_ɳ���Ǜ�ݟ�7���< �������\���t�
2 ��Y�{V�������Z��m������Օ�[&%8���՝�.������a������Z0�_�@�U�I�po���t޲C�$u�qT���>T	��h�1]'͛��5��F)d:ahظ��G�A_%�7���qm� S8�·.51�\%%�ǫ��t��vJ�@�s��uT8+6�3�im�*_��3�a�L�x�6E��T	�f��Ii<)�#LT.o����0��E�@�x*��KY�/��X�.�Kl��FȺI��ا!ч�d]ne��B�u��E�y��]0���Tp����������t��B^���K��O�S��G��27^�X��3���Dd�^�A0@��6�*@����G|�W��}x� R�u�#X��b��r���^�,i�`�^�˞�k�w�0���XEWa9�e�Ł�%���p�{�g�sM����g�0	x\$+�Jo�
s���NS0����#�����j��ks�Σ�Z'�z�D)��م�P,�q�N�}_f���6�GpE��Τ�M�b���r��!aԋ {�={eE#{��\1��œ�U]u�4�O�a��S�o��ٺ��vo
x<��M����?���䑓�]��a�U��;ƀ(:	���,��8J8�1	(I�Ѽ�R/u��u��c������6�T��8��g{�f���$u����j���0_0!%���Y|�^���s��a��Gl�ڝ^�q��4�J��i�2A����Õ��E���Q�{_�J�l�>>�b.�+Q�]$�"R�(��&;$7Rygiu���_F���/b�Z�Ӭ�ǿ�`�
�!Y��7��E�JFf��Y1Y�z�CBQ�P�:`I<x}?ꪚ&ԅS�>><����:��(�(�k���>���X��;���'���2���#���Ml��6��`�����i(�6M���J��F� �b�j��>9�Z0�祭�:n���1<8�a�Ac�E)�D�ۼ�z�Rg��6�j��£�$X-0_�����ЦU&DVX*����80�����u(r���A��j�v�K�!�$�� 1�P�C�@�I�Dj=#���X#ev���&�N&��P�ya�AG��T�Q��C�Y����d�4���	��3�cժY�'��89a�;��Q�Gam�|�~� �*p�޽�E(�!��T��,���q|Nф��顉f����8�}�}��s��O����A��%�*�P �|�A�|qH�����оAܟ-!N!kR���F..��t���U8z"������k'6�O�p*9��Y�Z�m�F\ɯ'�,��-�cUt�������.�s�*�rd���j�]�.Ů_�U%kʿL�ǲꦪfӝ?r<����:���Բ-��Q�j�� ���P��M�@^�k���[����?�ն4w��&eC^�AW��΋`�$ ��DW%��/�bk!�~��ݞ(e�S0��ۡ�s":�R;��eA]R���t��⺈N��k����\�15z٪(��3e�v��ωvG@��do�1ڑ�>Q���P:�}ѭv��0�wG>�5�tm�m&�R�^�rN	�#�0Xq��yqþ�~;Q� ��/uv�%d����AU�	q��:.(�b�Ӿm���W�����6��Jh�;�w������¥f0�ϑ�I�LT�G�)n�r�D��=;5��"�C�~�e���� ��
��ĺk����;��e�l.<9�B����W6A�"S<a~�Ok�O��!_�{J�.�N�zQ���ӕ�g-�)����PY�P�H�䛿�Y�w� �l0cjA���왢��<�Q#�(�}�����`��}`�=ډ� {�8�����70�� Vڍ�U�х*�'>߾�UU�7���˿���$�)W�9/D5�=+�SV%oD�S��Z?���l1G $  R��»�m߿�+V@�j��S�^�w�	�`��(�z+���"�|���8���0�����1i#���id�";�Z#9TQb�C�VR鬕�}cc~С��'9:j����+�k9`�U.����`�o��X6	���s�����:��ɱ�|TP���(9��}2 W��� %�:�?�쩑U��/̏��q��"w��hK��ߓetcY�5b+Pl��uf+m�q�����Hd4F�m��nV�_g*DGr�����.]~�F���9ECǁ�|�Q��9ļm��l���p(Y�6�V���Cs��4Ərlp�z���?���@�5��s��R���ي����d�G8��|B��Օ~Ȳ�V�C��?U�a*vG�?85U��9�����Ez�E�S�B2�-\�+�9m�y�0C=h��#Tl�巤!ĔO���Qj�`\��ڃ�4��f|�,�3�*8�������������u��_@�����_��j\�g۞X|c,t��kU�/��	.L�_ �jC�8$����Sq�� ,	����_�84��[*�?���k�#����vG�~]Q�g.V�� ?q��!�E/�;�9
\mD�5�R^?3�9��[9��P�4�y�x�y���Q\[�n;�2Pl�q�HW��ߎ�h~q��u~N3��7�9��F��ه|�7�~Ќt�"�Q���0�!ֲ�D���n�l�u�C<:Sy��ɣ���[�|8���}�JEa3�(CB~<�$��xֺ�s��}9��E�7�?���6��BZ�x����t�CDR1%.�v��bN�N���5c&�F/
Q�7w�L�)�$�O�
W�DOD��L�X�ߗ�CIŢ�"�������j�)�N���_^�*�yU�(C�3�V75���+K�MZ�L#1m�u]����7�	NCB��"H/����$1u��!��&�&�9�&�@���L�{$Zߟw�w�[�	�'�v�,M�����c)[����uu�I�k̄����?�1^�5�⤿CWk�$�$$tV.�0I��]ء\Ҥ>C"-�	)��H�ck�dlq(n�텝"����:i�H�����'E6Ѧra�8K�$`!��8x7���1�:x�'��5=h���}r�rKb�/�Xخ���Ncx~>ABe���,*���-6ļ#0�i�-�B~�N��#؅��vw(�ko���F��??�R���ƌ��ʗ����Ձm�k��]W�4��!쭲�H�w�c>c��꜂:��z���W��b2�"8Z�u{�+�1o_D��:�z'F������A�����o��տ��      x      x������ � �      {   �   x�e�Q�0D��S�	����g�L��]�Ʋ%K!r{������f�E�IOaF�T�ғd�>a�ohh7����a$u�h.J�3�̉T����a�,cv�H�mR27}�*y♂k5�%|��:I���^�L*aL�z��ߖ��r���i�JK���xsF����>	-ߎ��q�3o�͑�콲־ Ƀt8      |   ,   x�3�tK,�U�MM�H��,N,����2��J�rS22�b���� ��      }   5   x�3��/-JMNU0�2������lc.8ۄ��6�2��͸��ls�=... �{�      ~   �   x�]�K
�0���=��
�7m�ґ�%��B��~Ӂ���|p�����~������F�3�l}�P/����p,�L� �G/j�P� �p`b��)���-&?����嫎4�%Dէ��!��q?� hhQj         /   x��J�I��L���􂱸��r�sS�3���Ē��<N7_�=... �x�      �   3   x�3�I�PHK-I�PH+��U�,I͍/(�LN��M,P(IL�I����� E�      �   8  x���O��0�ϛ�6LnB�`"��V���FmH�M��T�"s��1~��?�I�5�L^b!��y���{6���p�ã(������!`�0�1&��>���Gb|Ϋ�Z'tص_��񚌚��)m�D��]��n������Z�8��`ekl��dI�`��QAG��8�,�B�
*�
&^�SӪL��"���9�&��7B�I�
��TLH�����i����h�]'I(N��z����Tc=K(+:��{kt�d�5�V�VKޗ�*�_@`s�n�����R֍ծ��r� }fW˛{�|5����,v��I���o`�,���i`�Ú���|����eA�

".�H\0*$.
��RP�v��<�p���!�B��I�l_:&t�X`�t��ꒁ��@��4�z�.2.и�ꠡ����V\0��w����@q���Kn4ny@��~�v��$����U����oL�O�g}��j.����y�|��7Xɏ*��^>O�c���x�l������c:d~�M�A���q}���('.���o�^�|}]�V T��k      �      x��|�rI��3�+���}�S%H	� y�T]���X�E�JT�������̤D�-++�Bf�p�r���>��������`������'BO������a�������,<��X����q���%݅��8����j���|5�Ь/���Y�򱹸���^O��#�l�,�hlQ�2/����PK�q��dXI6����Eo��ZW���{;ZO��|��w���8&�	q��D��0����<����6<=�����ۧ������R��>�g%=}yx�vo>]��/6���|9��ւ1ݙ:_�x�^#�N��EХ&gj�9Ƌ�:[��O6Z墮Uʠ��)!�T&a�����QS��Ty0U�a&n�1<ގ�?¿ß���ݿ���x~_����szz~(�������ϻ�00u}1��Y���_W�z�ڞn���z{ss5��~9_4�+�YY]2���K�&k����&8�X#,㉱ wK�`�2Q[F��6���LO����Q���f��-;a�]����ͯ��r�l��ѯ���yܜϖ�6�\��\�3:UL��)��[�D�J��u�)";F��͓��Y���xF�T��M�`����N�G.���_v���l�����)_��:!�*B*�T+&i�x�5�D�H,.������A%E���	�b"�D�����M�w��D�.�f��؎/��f5FA]4��������f�����W��|3;�Dw�\5�_�[�@z�TvA��L���{#��ffEME�ʂw�9#�B�i.�ͪ�D�YVO���Gͳ���<iO$�c9��.?4��>�xq}�,7����y<]]o.P!F��:ZN�8��]rQ�p���'��ǳ�%9�[�Nko)T��j�*�(�V��0
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