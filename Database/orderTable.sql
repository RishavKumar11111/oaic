PGDMP                          y            oaic    13.2    13.3     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16384    oaic    DATABASE     Y   CREATE DATABASE oaic WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_IN.UTF-8';
    DROP DATABASE oaic;
                postgres    false            �            1259    16537    orders    TABLE     n  CREATE TABLE public.orders (
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
       public         heap    postgres    false            �          0    16537    orders 
   TABLE DATA           �  COPY public.orders (permit_no, permit_issue_date, permit_validity, farmer_id, farmer_name, farmer_father_name, dist_name, block_name, gp_name, village_name, implement, make, model, status, permit_validity_1, permit_issue_date_1, fin_year, dist_id, engine_no, chassic_no, ammount, remark, expected_delivery_date, delivery_date, c_fin_year, date, system, paid_amount, order_type) FROM stdin;
    public          postgres    false    244   Y                  2606    16660    orders orders_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (permit_no);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    244            �      x��}kw�H��g�W���y�	U���JF��Hڽf�Y$���$rZ�OO��w�*@�t����i�C�����+��y}��T�m���q���$������$���x�oLy>N�fܼ��t�W��,��Y坫��3��b�j
_����d��3����2������1��J�w�8MRs��ַfV}�3G����~�<o*�����a��?�\�lE�Kf_ڶ?�/�<��U_�7C����p�yo��:�������Kj_:���q���j����>�W뇧���qm0[܅/㿍�o~����/���|c��|�ͤLyny��xq��s�r#>�Ɍ�)G��Gt�"��K�g�1�V1^0��¡f��Y\��Pm���O���������v�� *�ًaT�QD�q{�Ĺd���A�Hz6�. �j���F��բ����t��������bѼ�|���U(zA]=|�������Ͻt�y���V�$i�:�h����b��fγ�Pi� �9�1@��>�ݫ5�+�Mbc>΢�� �[���z7{�_������'õ׌�w�����w�Y���'��u�D���!~EQ��-�(�<H��-P�:* }���B�>�r�4@��܁$f�F�b@nn��|rã��JGAp�`g��&w_)�3�)#
�!��=L,�E\߶�CJ�S�Ԟm;`޲E-��.F1��Y�Y��R\ �����k����c��,@��T-�$�쐀X� ��F��,4�,^�	��!hr�{���>�3�U�?{�s�6ڭ��;8 �'�7���}�o��HK-���� ����W�W�zlP��Ql.�U��j�y���y����D�yZ�x�{v]�8SZEϱ=/��:<Q'�4 `Q��x�;*�)0D�>�֞�p�P��?��3��;4o,;�%�:V�\6�z�����mu���$m�#>oT6Gϑ�s����J[2]�p.�1%^¿���퀇����$6sŴ����+P�bHԪ
���	aC	����M|�W
��N��U�i��%$FQ")�f
�'�|i{�W҄'</!`Aq래�x�{M_�n�����,���$?�|�vg^}{y�|o<�o�����r���T�]׬�����bpʎc�n�l2�9�i�b>!�̇���S[���
r=lp�3{gg9=�J���M������d��G�썚ABy�����d�H����;�`Ǔ2��8�)��b��~G�O�Ɉ�U��.�O�o�%� a7�&ăЯL��KsA$�Q`���AQB�+@*��r��fu�6}�6�8.�vXM by	�Q(�x ����￉�C�:��#���i7����g���I�1pj��A��-"~ӹ��Wզ���`$��j��zjh�|���}ԐP�/�H1/Y`�wBe��Տ��M�F]�y�Q|��y��H����lo1��b���Q�"� D����t�qҧg����%f���� rvxi{� tJ.M��W����x��dPچ�pp��Kt�f�g�W�[�tgڻ-�9�Q�.�\���>�c�t*�9��`�J�Uhr6��z�%�"][�v֏��jb�Y��޹���8���be���ꑜ��m�%��ՖзP��!-��/Z5J��r����8�"g�`��u�+���Q&�0�}A��7w���&p\��b�1`�ĴC=�(��Wd��w��"p�MF�o��U!�ă»��E+�������4T';����k5@��Vd��~�خ�2���L�F.�q/�}5�'� 1K6�U�|(�CW#��$}W�C�Q�A�5"�G�J�G!��y	`xIl˧���h��v8Lڄ��<.:��2o;%�s�[�(6����A���h�~��������;�80z|�t(N��4Z:5�'{p�o���(�G��`�:�� ����YT@M���v��{�i�w�� 7��)�L�>�1�x{�˦�@��
�T�^�D�?�#��ItB�R</P��r���O��8�!<��v�c=��_�/�lٲ��I�e�*��r�C8�����m�	�)�E���Bbԗv��m:v�3,��x���Ɍd�h�<�֞���:�e=�.%�#�Q��ƻ�HV��2���B��j�(|m��*V$�ਐF�^M����(V�ԟ��{��FT���T\]���kOI=����R�>A�����b�geO�"�2��fF
����,_�=z�#�M>`J[�l�ҳ4��K�����g��ב��_2ע@�C���:�� :���{�ő���C�l�P�����9���xټ^��V���Z�����G�.E�%!N�>GC�]���7���+���zX|]�>(�R�����!�q	t�@��8�X��R�:�{��Ϫ
���C��D"�F���c�0p͉"d�^�����5����m�ߢ���vKY��k�(z��ӆ���8ك7�����a?ץ�O�Ƃ�����L^���Q�W����{� y�^�e���մL�9�����x}>�.��9C�&�f��Đ9���Qq����{��<��]���"�?�4�8��
��%�������*����87?���87>+C��ǻ�[x�f!ky���s�(�^V��F�����٠Y��->���}�-.�1�އ1�U�C�^�8_��Q��X͕{�IPkc��U���j4���7Wf�Y��6���e[�띞�6v%��"޺:]�E��5գ�e�jzZ��8����x�7�Q�,1��4�ظ��}���c4.��?N�n���� �y��:yg� ©�ix���)��Y���+y=�ة5j�Ę�+vLm����|~yz~�~��a& ؂�Ì���d�1�fNo�v�	�/uQU't4���^�R[Y9�ׁ4�c4�J��6]��g%����p�)��a� ���[.��[I��=+��"���1v��ɛ����>D�c�	�D$���	
��|Q��b�<��H�U���cWWfR0�b揢A�ͨth���o�+�S�8��Q�Ϲt�Kǵ<[���9	�ʚ�Ek���<�\}�5��׿��l��\=C�t�����(�����+����:�y�wT�*�wd��(�����q���m8U̗�@;x]�+����5�Ǘ�Tf^���fV�Q}5fշ��x�<��^�+�"2kT,�<Ĥ����N�h�5~w=��e��WS����`>�!q!^RR
�u�	���;���/���P���8l�j$�L�˓-���x	$,�a����0���e^�$���BxB���ֵB�u��n��>ʋ8۳� Ij��a>21j�.B��J����m]d`��E��Rz��1U�^��銵B�&.�H�)O���j������Q��+ hS>/S;+�R$<�/ �F)�՗��v$�t�c�/R��:O��Ę���%6���sq����s�ߎ�(�k�"K~ �F�IT�>��K>����t��OO��j�!H����)ڝC��!*�2�H�����BA��)��3����k�F�%��2��8R/	���:cp����U?�6��9B�� wK�F�����tjPx	�26-�����D�����ض��z���(��ȅ�1�kyyF�6��B���z���n�d�V�ɜ?�Z��1??~�?1���g�]f�ziGZ,A:�߃e�,��;h�p�;�n��A�딨T�g�������jW��`+�	��<8�a�V6�r��^�o0N��6��)u�/��q@*}����V��xj/����С,wF2!B*6�OՓ�>�C��7����{���e��ӊ�E��Z�ݹ���{j���;�	�?��61U���M෇$3f9&��������P3�8��Ge=���4�WO�i0RJ���?���^B�� �V,��K�)�Mm��#��^Y�R�ث�pO    α�£�sp�py/����Nթ�aU�;�Z�d59��M���=Wf����[F���vv���ٍ:�Z�:��Cp��E=SL��n��`A�@v#mcQeQ^Ģ8�����˷J��l���-E$�\kp�`��i/FNw���.tjuU����p�J݆�	����v,�i���������Ơ�e�|�)�d�%�А�:~�����N	������og����R�>#�n�jjB��],��O�*jxi������rS�����#����B�[Q��8K �m?R/��$Pv���iI��0��[3N1Y,�-��=$�i�K�ÞW��iM6�f!(����T�����L�#ɞ�;I�l�Y��g�����M����o2U*>?���GĮ�.��M`n�sn���;�n�ES�qe �d*�c�Ã׸�n�\�_ұ�}�?D1��S� [��X��=78�~��֤ ���y�/l���j2���p��x2F���4 k6EJ�>&�ȾPK*[{� ���Ch�'�j���V�(��h�ʛ�9�h��$@���0` NETc�:3��V��W�pH*��ݔ��b���J�;l~���@b�_A/rI�@BT΄b0s-͂�]�?^6����86f �\n���x�R9jO[�3�Hp/P��`�1a>y�ڀ�~B6O�gx��� ?l����?^ �lk~O1ArO�7ܷ���^,+`��p�N��vL���vd�����r��\f.�s�8.>c�0 ��|]�7����6X`�U�� ��I�K��ܙ�S�5����RnR�m^byv!�f���~��Qxߦ�c����.�TEN1n�u�p��kkDH�BÉ�A��p�a���(�O]��	;To��V(𓾕�������qΉ��½����q�,�V����(�L���@TŇ=<�����;�Q�� D.M-ק:�h<퐅T�y]��O��FWŰQ���F����n}�R7����mm��է�����1����&���N˰�RvFCe�.�*�,Q�c�1A�S��v�f,�`,MN6y��?6��wSv>����u���t�a�`n`��ռ����=�~=��3p�?2B�>���ܭ�(d`��qPk������K���3���܋��[�����0fP�homry�	���"�B���j�Ə
Gr�Rl��@ر-F_�_�&�׸�!XiL�)���U]�{�=kM���8�1T��*�~I�� ��icnY6Di6�hY�X7:���t�}��f
���u��m���J���f�l�DJ��#��^��(*#�2=>m9�ۻ��	���ˈ1�?��2�A�1�tc���,.�M�J�}�瓳��v�Y�`��:p�A��{L*+��f�������Ga�:��K`{Ԙ��G��Tݚ?j�9ݼ<=|�{���r�a�%��I#��ݣ6f
$��[�`9�ؘ��҅�166Y�OO�B��=���t������)Ptq���h%K�8�Ӽ���T%�t�e�Z����9B�r�}��'Q��__�=7���)x�>��+�^�0�[a�x�n��r�L����i��&�E���������A������t��B=��:*PfD�N��pe�0j�^K�ⷭ �3M�%��D�D�)!�wmc��YW��Ob�w�ň��Dc�q�"���������#���Ī��=��Qؠ~Q\d7`N�3 ��.��0�d�G�0�R/lh� 2�Ѷ��BgqZo|�OYnׁ�Q�z	����t��K;��1�b��F;A��5��� Y���O��|�"ഞ����$Z�Lְ�q��Gu�l�W8۬dM��D�pم����4L{P}����`u#��i��[5X�$��B#�4�W&.Ùc3 VAc�@�UvF_����|c��cs	2٬^��E�T�򕽨�-+U)9E����y>Q�2\7����_,������ 0��ˊi���r-])��@0#��R�ϭ��Y (��h�ń��z!�3���ܯ��\�zl�~6�Qa����,P�
�-�ROOƌz��g9�s�sV���H�¯vf���hyF���t��;P����d���va!U���Ii�"�X���'9=fc��񰵔��bJ���4N%wȁ�B����@�,�s>7�9H�j
v~�����K�~��n%�,*'��|➋�&������"�eF�Uu����Mb?pu7�6e�?lE�>h�'��n��Μ�L���. 
�-j9���tf��Ƣmw��ɣ��u�J	�2Ej[�`�;r�=$͢f�
�~F���A��#���m�A�|Hk}��I����V�,Bq�f�^ �n�:2�$��8 6�(�,�s9Uz�
�!�$)|e��U�y#��f �А��s��ӈ��`�Z�ba���*IRf��9-J�.�נDqW��5���´��+�!'�=��M:�O^��t�U���&q!�����������QR?�Y6�l݆�����0J��~��P��	.mk��"."Ŧ�洬�3/��ET+d�5�#�)z��1����! ���a6#�:���������록�u�U~�s(����As��3~��m��Y>�����!�t2w�/Gxfl���9�h�<�	���?3�&�X8n���{|�،x�7A����IuDG�h���{���<6[���>M�#&���I��a|�¬��xh�%n{F��9��K������4B�E��Q�+�����:��-�]/�G�ԺX�p�=�죞��:ؕT^:��8��5���c���PG�`����ZT|�`z88�`j�
�g;�f��	}��G�	E��з]�k���&�K��si�f4�8U1�b,n�@�7��u
t�f����.KG4Y�m�"#\p7�������QҢ\.�8�e�~]�y�-�,�툧� 7WYV;Np	B�*�������]��)���O��G|%rY�����R�q[���cL*�J��2۱�G��	��s�|�`�'v��j��TCW��.lv��i2-E�D��b���[�s#^�r>��y�=M�q�U3յ��!��`�た����[a�hѵbݕ#�#�9��v�	Y�t	�,��w������yu_=0Ʋ�<ݿl j/�,\���_+qx.����,�h;�-�i&d;l)�q;XK���4�6�c���?P�󪋴~��Y_i`k^Qz��yՁ�=6?O�_��I�&^:?�#�.���.�~`t��z�'�!Nb�x^��!}5��Y�w�U�H ��� �sp�C�ur�#}9u�~5W&3�nCN���	��0\Y�6Nb�1Y�1E[��BȈ�8z0�Y�!���Lز4��8������%������L��D`}�v��.xq�g7�f�W��N^���1bg,�>1E��]���L�:��[$�r��t�S���}���>w���pw]4����ε�3,q�T�k������,S�T<o(�u�3ǂ��5�ˆ� )�@��:���&������{hk>���+n���	�����
����c�Ak�ݺ�J)��X�`8�Rͨ\n%/����;�Nq�	a��sUݧ��K�z�Tbu~�㿲y�FK��ʉv�*ؤyƚ~�UvO7ۥg<�T�_j+�X��c���şo�OA� �r���z5�d]��/�)l�2��8�[����0aR����R>]�U����	Z���X��مЪg7[�S��E�82K�6+W���u)�S%�2�)标B��7Qu$�[F�y`� a�j���ب"��^�}�����?�,�;���9n8�ϝ�m�N:��3a��;D��2 ]���~��d��+	tQb��{)U���DN,L�_-��#Nl@��{pg[�lAq}����89)�5�(Wt_�e���K\�I������& u�sj���CQN0��N-|�� �s��fb��E��""9��ĉ���2�kfL~�)rbcBP4�O/?~|��|�g���S9؂He���H�/�`���8�I<�"�6[E��X>��ӄ�R�G����
A 
	  �~�x��LK���u�PTMx$v���]�Y� 2����G#IG&n���"��i���tѷ��@���RO��z��C��u����v�(�.F��+Q�[8e�$�"���B�H��n�J�:���q��Q����<M�r�#�Z�S ruCu�� ����*�v��w�W�v�Nɴ����̷�4�`vg
c���y�9�@q�ٮ����l؟��M\��+ �)r)�C�ɡ�L����d*"L\�$)��B�3dT4
R|��!�����t?t��+����,+�*}�������H^�3�'�E�	Qښ��vjA��_���m�:H��͓eb�=6'q��Rw�ig-�x��竒� 7X�e@(z8�gC� �=��K�[c���
m��x�$;X~Q�Wz����<#eQ@%x'b�����S��v@� �s;���kӱ1�������&뽭��~�a�� ������Nu���c��/�["��8>q��,Mc��q S2�\�H����6 ���;cy8���-ʲ8b1���:�L%N�*x�k兺gVm���t4?D��81�7�@Fr1+��� Q�E�j��R�G"��e+���n�Oӗu-Z;)�\�����O!�lB�����%�2[��\Tf0�'y#�z�k���	T@��y�_!���j����	��=_=�ڱb�pHY{��Wᾉ>��������5�o���������C��LJ����D�H���K�s��^�v:�A���ã�@-���W��tDl�|_#FUlB0. n6�4\�������=��GH�G�σ�������
�a�%��.Pi�\�0�KȱYb|��M�
}{�OQ�q�)�=hw�W�|�,Z�,�� ���(��a���*���m��ƃ��X�������)��c-X�-J�L�(�I��d{p^��O���Y�Ч@.�I
��`���G-��
>ū�.� 'Xř����l4|�Y���k�n��v<54�8P�4p���laG�TԵ&d8j�5D�M�X�A�@�Āp���ɫ;e;���:؉y���������o��>����b��v�9&�:f��F����֕e��Ef�0�?w�������(�&Y�wAP'l g:�(�ޯ�2�G)�����h�Ӿ�	���e$�k�n�����\>N��?�Q�89���*�8.V��,���������NAe��p�@z<�9�q��e�p�}����B��8WX���5k�*pʜ��ү*v'V<�����������p��T�`)�#�{B,\S�.�kr�� �������Z+������j��y����a�L������?[�\k��Si`;�����/��iC4���S���xl�1�rӈs�����o���˰B��z�k�:J�Ϛ�k�$�#ѓ��{�=?t�3�̶.����E���� U�R��.�i��R�7�`��{Fh1e�{v��V��P�u���x�O��f}��ow�,ʙ���{�C�.W1�M+��w�o�],m�%�t�J���i�����n�L������$�n7.��ߍA�[Ycœ=luڽ����,�y���GM7��E����L9��_�z�8QMߗ����+W���.���/�_��xp�A3�}Ɉ�Z�	�V���N/�.���@�b��M5-˜_��9W���]�S^?5ō�{��G5l���� �ߢ^}��^�Akؗs|��z������3�l�����m)����.)qzN,pl�uAD9�C�9��^}>�+Y��X��ۣ���ٰ�����,|���ۮ݂����P��Fb��&��i�ޢ�%�*V&H1%5AD#벫N<$��x��!ןߔ��'��1�s�6������X��v�au=s���5@�Y'�œ�I-�͹j��
��v���j�c��9��lz��݊s��91�	���#�r�F�-�	�����DM���v�b��8O�\X C�yzѧ%g�7]x�0�:H1t��X��A�'6q;�'���q�تСɖ~��e�7ե��w��h[IX�BB�q�:�<>E�9S��f�i�������;7���	9�z�G�^R߲u�M4ğ��࠸w'�����V�Y<�]�+^�?7R��mg���b�oRF����&�z��A���O���wqj�2_GŸ	�����
���C��Q�ۍa2���#h���E �~���z�Cݢ_����}�Ƕ�M��lu6r����>��+P�x9}ʰ�x�����[����?��x�     