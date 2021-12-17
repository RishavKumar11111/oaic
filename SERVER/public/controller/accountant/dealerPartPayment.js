var app = angular.module("myApp", [])
app.controller("myCtrl", function($scope, $http) {
    var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    var dist_id = document.querySelector('meta[name="distcode"]').getAttribute('content');
    $scope.PayDetailes = false;
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
    $scope.loadApprovalPendingPaymentListByFinYearWise = () => {
        $scope.loader = true;
        $http.get('/accountant/getFinYearWisePendingApprovalList?fin_year=' + $scope.fin_year + '&dist_id=' + dist_id)
            .then(response => {
                $scope.invoice_list = response.data;
                $scope.loader = false;
                $scope.show_invoice_list = true;
                $scope.paymentInvoice = false;
            })
    }
    $scope.loadApprovalPendingPaymentListByFinYearWise();
    $scope.loadDealers();
    $scope.loadList = function(x) {
        $scope.approval = x;
        $scope.approval_id = x.approval_id;
        $scope.indent_amount = x.indent_ammount;
        $scope.invoice_amount = x.invoice_ammount;
        $scope.invoice_date = new Date(x.invoice_date);
        $scope.indent_date = new Date(x.indent_date);
        $scope.indent_no = x.indent_no;
        $scope.invoice_no = x.invoice_no;
        $scope.subTotal = x.ammount;
        $scope.paid_amount = x.paid_amount;
        $scope.pending_amount = x.deduction_amount;
        $scope.remark = x.remark;
        $scope.dl_remark = x.dl_remark;
        $scope.less_cgst = 0;
        $scope.less_sgst = 0;
        $scope.selected_dl_id = x.dl_id;
        $http.get('/accountant/getDelearDetails?dl_id=' + x.dl_id)
            .then(response => {
                $scope.dl = response.data;
            })
        $scope.tax_mode = x.gst_rate == null ? 1 : 2;
        $scope.gst_rate = x.gst_rate;
        $http.get('/accountant/getApprovalItemsForPay?approval_id=' + x.approval_id)
            .then(response => {
                $scope.invoice_items = Enumerable.From(response.data)
                    .GroupBy((item) => { return item.implement && item.make && item.model; })
                    .Select(function(item) {
                        item.source[0].quantity = item.source.length;
                        return item.source[0];
                    })
                    .ToArray();
                $scope.invoice_items.forEach(element => {
                    element.taxableValue = parseInt(element.quantity) * parseFloat(element.p_taxable_value);
                    $scope.less_cgst = parseFloat($scope.less_cgst) + (parseFloat(element.quantity) * parseFloat(element.p_cgst_1));
                    $scope.less_sgst = parseFloat($scope.less_sgst) + (parseFloat(element.quantity) * parseFloat(element.p_sgst_1));
                    if ($scope.tax_mode == 1) {
                        element.invoiceValue = parseInt(element.quantity) * (parseFloat(element.p_invoice_value));
                    } else {
                        element.sgst = element.cgst = ((parseFloat(element.taxableValue) / 100) * $scope.gst_rate) / 2;
                        element.invoiceValue = parseFloat(element.taxableValue) + parseFloat(element.cgst) + parseFloat(element.sgst);
                    }
                })
            })
    }
    $scope.showDetailesOfPayment = function() {
        $scope.pay_now = $scope.pending_amount - $scope.deduction_amount;
        $scope.paymentInvoice = true;
        $scope.show_invoice_list = false;
    }
    $scope.sendApproval = async() => {
        $scope.approval.deduction_amount = $scope.deduction_amount;
        $scope.approval.sub_total = $scope.subTotal;
        $scope.approval.paid_amount = $scope.paid_amount;
        $scope.approval.pending_amount = $scope.pending_amount;
        $scope.approval.pay_now = $scope.pay_now;
        $scope.approval.remark = $scope.remark;
        try {
            var req = {
                method: 'POST',
                url: '/accountant/updatePartPaymentApproval',
                headers: {
                    'csrf-token': token
                },
                data: $scope.approval
            }
            await $http(req);
            printElem('approval');
            setTimeout(() => {
                window.location.href = "/accountant/dealerPartPayment";
            }, 500);
        } catch (e) {
            window.alert('Failed to send approval. Please try again');
            console.error(e.data);
        }
    }
    $scope.back = function() {
        $scope.remark = '';
        $scope.deduction_amount = 0;
        $scope.paymentInvoice = false;
        $scope.show_invoice_list = true;
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