var app = angular.module("myApp", [])
app.controller("myCtrl", function ($scope, $http) {
    var dist_id = document.querySelector('meta[name="distcode"]').getAttribute('content');
    $scope.show_approval_list = false;
    $scope.show_approval_print = false;
    $scope.loader = false;
    $scope.fin_year = c_fin_year;
    $http.get('/api/getFinYear')
    .then( response => {
        $scope.fin_year_list = response.data;
    });
    $scope.loadDealers = function() {
        $scope.loader = true;
        $http.get('/accountant/getAllDistWiseDelear?fin_year='+ $scope.fin_year+'&dist_id='+dist_id)
        .then(response => {
            $scope.dealer_list = response.data;
            $scope.loader = false;
        })
    }
    $scope.loadInvoiceListByFinYearWise = () => {
        $scope.loader = true;
        $http.get('/accountant/getFinYearWiseApprovalList?fin_year='+$scope.fin_year + '&dist_id='+ dist_id)
            .then(response => {
                $scope.approval_list = response.data;
                $scope.loader = false;
                $scope.show_approval_list = true;
            })
    }
    $scope.loadInvoiceListByFinYearWise();
    $scope.loadDealers();
    $scope.showApproval = async (x) => {
        $scope.show_approval_list = false;
        $scope.show_approval_print = true;
        $scope.loader = true;
        try{
            let response = await $http.get('/accountant/getApprovalDetail?approval_id=' + x.approval_id);
            let ad = response.data.aprDetail;
            $scope.invoice_no = ad.invoice_no;
            $scope.indent_no = ad.indent_no;
            $scope.invoice_date = new Date(ad.invoice_date);
            $scope.indent_date = new Date(ad.indent_date);
            $scope.indent_amount = ad.indent_ammount;
            $scope.invoice_amount = ad.invoice_ammount;
            $scope.remark = ad.remark;
            $scope.paid_amount = ad.paid_amount;
            $scope.deduction_amount = ad.deduction_amount;
            $scope.pay_now = ad.pay_now_amount;
            $scope.selected_dl_id = ad.dl_id;
            $scope.subTotal = ad.full_amount;

            $scope.dl = {
                dl_name: ad.LegalBussinessName,
                dl_address: ad.dl_address,
                bank_name: ad.bank_name,
                dl_ac_no: ad.dl_ac_no,
                dl_ifsc_code: ad.dl_ifsc_code,
                dl_mobile_no: ad.dl_mobile_no,
                dl_email: ad.dl_email
            };
            $scope.less_cgst = 0;
            $scope.less_sgst = 0;
            $scope.invoice_items = Enumerable.From(response.data.apprItems)
                    .GroupBy((item) => { return item.implement && item.make && item.model; })
                    .Select(function (item) {
                        item.source[0].quantity = item.source.length;
                        return item.source[0];
                    })
                    .ToArray();
                $scope.invoice_items.forEach(element => {
                    element.taxableValue = parseInt(element.quantity) * parseFloat(element.p_taxable_value);
                    $scope.less_cgst = parseFloat($scope.less_cgst) + (parseInt(element.quantity) * parseFloat(element.p_cgst_1));
                    $scope.less_sgst = parseFloat($scope.less_sgst) + (parseInt(element.quantity) * parseFloat(element.p_sgst_1));
                    element.invoiceValue = parseInt(element.quantity) * (parseFloat(element.p_invoice_value));
                })
            $scope.loader = false;
            $scope.$apply();
        } catch(e) {
            console.error(e.data);
            window.alert("Data can't fetch now. Please try again.");
            $scope.loader = false;
            $scope.$apply();
        }
    }
    $scope.back = function() {
        $scope.show_approval_print = false;
        $scope.show_approval_list = true;
    }
});
app.filter('convertToWord', function () {
    return function (amount) {
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

                for (let i = 9 - n_length, j = 0; i < 9; i++ , j++) {
                    n_array[i] = received_n_array[j];
                }

                for (let i = 0, j = 1; i < 9; i++ , j++) {
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