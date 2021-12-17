var app = angular.module("myApp", [])
app.controller("myCtrl", function($scope, $http) {
    var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    var dist_id = document.querySelector('meta[name="distcode"]').getAttribute('content');
    $scope.PayDetailes = false;
    $scope.itemsList = false;
    $scope.show_invoice_list = false;
    $scope.paymentInvoice = false;
    $scope.showPrintIndent = false;
    $scope.loader = false;
    $scope.fin_year = c_fin_year;
    $http.get('/api/getFinYear')
        .then(response => {
            $scope.fin_year_list = response.data;
        });
    $scope.loadDealers = function() {
        $http.get('/accountant/getAllDistWiseDelear?fin_year=' + $scope.fin_year + '&dist_id=' + dist_id)
            .then(response => {
                $scope.dealer_list = response.data;
            })
    }
    $scope.loadInvoiceListByFinYearWise = async () => {
        $scope.loader = true;
        const response = await $http.get(`/accountant/getFinYearWiseInvoiceList?fin_year=${$scope.fin_year}`);
        $scope.invoice_list = response.data;
                $scope.loader = false;
                $scope.show_invoice_list = true;
                $scope.paymentInvoice = false;
    }
    $scope.loadInvoiceListByFinYearWise();
    $scope.loadDealers();
    $scope.loadList = async (x) => {
        try {
            $scope.loader = true;
            $scope.tax_mode = x.gst_rate == null ? 1 : 2;
            $scope.gst_rate = x.gst_rate;
            $scope.invoice_no = x.invoice_no;



            $scope.selectedVendorID = x.dl_id;
            $scope.selectedInvoice = x;



            const response = await $http.get('/accountant/getInvoiceItemsForPay?invoice_no=' + x.invoice_no);
            $scope.itemsList = true;
            $scope.show_invoice_list = false;
            $scope.payItems = 0;
            $scope.payList = response.data;
            $scope.payList.forEach(element => {
                const quantity = element.ItemQuantity;
                element.TotalTaxableValue = element.PurchaseTaxableValue * quantity;
                element.TotalCGST = element.PurchaseCGST * quantity;
                element.TotalSGST = element.PurchaseSGST * quantity;
                element.TotalInvoiceValue = element.PurchaseInvoiceValue * quantity;
                const onePercent = element.PurchaseInvoiceValue / (100 + element.TaxRate);
                element.TotalLessCGST = onePercent * quantity;
                element.TotalLessSGST = onePercent * quantity;
            })
            $scope.loader = false;
            const dealerResponseData = await $http.get('/accountant/getDelearDetails?VendorID=' + $scope.selectedVendorID);
            $scope.dl = dealerResponseData.data;
            $scope.$apply();
        } catch(e) {
            console.error(e);
            window.alert('Unexpected error');
        }
    }
    $scope.enterPaymentDetail = async () => {



        $scope.selected_items = $scope.payList.filter(x => x.checkbox);
        $scope.invoice_items = $scope.selected_items;
        $scope.subTotal = $scope.selected_items.reduce((a, b) => a + b.TotalInvoiceValue, 0);
        $scope.less_cgst = $scope.selected_items.reduce((a, b) => a + b.TotalLessCGST, 0);
        $scope.less_sgst = $scope.selected_items.reduce((a, b) => a + b.TotalLessSGST, 0);

        $scope.pay_now = $scope.subTotal - $scope.less_sgst - $scope.less_cgst;


        $scope.paid_amount = 0;
        $scope.deduction_amount = 0;
        $scope.apDesc = $scope.selected_items.map(e => { return { permit_no: e.permit_no, mrr_id: e.mrr_id } });

        $scope.invoice_date = new Date($scope.selectedInvoice.invoice_date);
        $scope.indent_date = new Date($scope.selectedInvoice.ApprovedDate);
        $scope.indent_no = $scope.selectedInvoice.indent_no;
        $scope.invoice_no = $scope.selectedInvoice.invoice_no;
        $scope.invoice_amount = $scope.selectedInvoice.invoice_ammount;
        $scope.indent_amount = $scope.selectedInvoice.POAmount;
    }
    $scope.showDetailesOfPayment = function() {
        $scope.pay_now = $scope.pay_now - $scope.deduction_amount;
        $scope.paymentInvoice = true;
        $scope.itemsList = false;
    }
    $scope.sendApproval = async() => {
        let approval = {
            fin_year: $scope.fin_year,
            dist_id: dist_id,
            dl_id: $scope.selectedVendorID,
            invoice_no: $scope.invoice_no,
            indent_no: $scope.indent_no,
            sub_total: $scope.subTotal,
            deduction_amount: $scope.deduction_amount,
            pay_now: $scope.pay_now,
            remark: $scope.remark
        }
        let updateInvoice = false;
        if ($scope.payItems == $scope.selected_items.length) {
            updateInvoice = true;
        }
        try {
            var req = {
                method: 'POST',
                url: '/accountant/addPaymentApproval',
                headers: {
                    'csrf-token': token
                },
                data: { approval: approval, apDesc: $scope.apDesc, updateInvoice: updateInvoice }
            }
            let response = await $http(req);
            $scope.approval_id = response.data;
            $scope.$apply();
            printElem('approval');
            setTimeout(() => {
                $scope.loadInvoiceListByFinYearWise();
            }, 500);
        } catch (e) {
            window.alert('Server problem. Please try again.');
            console.error(e.data);
            $scope.$apply();
        }
    }
    $scope.showIndent = () => {
        console.log('indent View');
        // $scope.showPrintIndent = true; 
    }
    $scope.backToInvoice = () => {
        $scope.itemsList = false;
        $scope.show_invoice_list = true;
    }
    $scope.back = function() {
        $scope.remark = '';
        $scope.deduction_amount = 0;
        $scope.paymentInvoice = false;
        $scope.itemsList = true;
    }
});
app.filter('convertToWord', function() {
    return function(amount) {
        if (amount != undefined) {
            var words = new Array();
            words[0] = '';
            words[1] = 'One';
            words[2] = 'Two';
            words[3] = 'Three';
            words[4] = 'Four';
            words[5] = 'Five';
            words[6] = 'Six';
            words[7] = 'Seven';
            words[8] = 'Eight';
            words[9] = 'Nine';
            words[10] = 'Ten';
            words[11] = 'Eleven';
            words[12] = 'Twelve';
            words[13] = 'Thirteen';
            words[14] = 'Fourteen';
            words[15] = 'Fifteen';
            words[16] = 'Sixteen';
            words[17] = 'Seventeen';
            words[18] = 'Eighteen';
            words[19] = 'Nineteen';
            words[20] = 'Twenty';
            words[30] = 'Thirty';
            words[40] = 'Forty';
            words[50] = 'Fifty';
            words[60] = 'Sixty';
            words[70] = 'Seventy';
            words[80] = 'Eighty';
            words[90] = 'Ninety';
            amount = amount.toString();
            var atemp = amount.split(".");
            var number = atemp[0].split(",").join("");
            var n_length = number.length;
            var words_string = "";
            if (n_length <= 9) {
                var n_array = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0);
                var received_n_array = new Array();

                for (var i = 0; i < n_length; i++) {
                    received_n_array[i] = number.substr(i, 1);
                }

                for (let i = 9 - n_length, j = 0; i < 9; i++, j++) {
                    n_array[i] = received_n_array[j];
                }

                for (let i = 0, j = 1; i < 9; i++, j++) {
                    if (i == 0 || i == 2 || i == 4 || i == 7) {
                        if (n_array[i] == 1) {
                            n_array[j] = 10 + parseInt(n_array[j]);
                            n_array[i] = 0;
                        }
                    }
                }
                var value = "";
                for (let i = 0; i < 9; i++) {
                    if (i == 0 || i == 2 || i == 4 || i == 7) {
                        value = n_array[i] * 10;
                    } else {
                        value = n_array[i];
                    }
                    if (value != 0) {
                        words_string += words[value] + " ";
                    }
                    if ((i == 1 && value != 0) || (i == 0 && value != 0 && n_array[i + 1] == 0)) {
                        words_string += "Crores ";
                    }
                    if ((i == 3 && value != 0) || (i == 2 && value != 0 && n_array[i + 1] == 0)) {
                        words_string += "Lakhs ";
                    }
                    if ((i == 5 && value != 0) || (i == 4 && value != 0 && n_array[i + 1] == 0)) {
                        words_string += "Thousand ";
                    }
                    if (i == 6 && value != 0 && (n_array[i + 1] != 0 && n_array[i + 2] != 0)) {
                        words_string += "Hundred and ";
                    } else if (i == 6 && value != 0) {
                        words_string += "Hundred ";
                    }
                }
                words_string = words_string.split("  ").join(" ");
            }
            return words_string;
        }
    };
});