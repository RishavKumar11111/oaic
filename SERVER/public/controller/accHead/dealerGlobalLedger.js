var app = angular.module("myApp", [])
app.controller("myCtrl", function($scope, $http) {
    $scope.page1 = false;
    $scope.page2 = false;
    $scope.page3 = false;
    $scope.printIndent = false;
    $scope.printMRR = false;
    $scope.printApproval = false;
    $scope.printApproval = false;
    $scope.loader = true;
    $scope.fin_year = c_fin_year;
    $http.get('/accHead/getAllDistList')
        .then(response => {
            $scope.distList = response.data;
        });
    $scope.showLedger = (dl_id) => {
        $scope.loader = true;
        $scope.page1 = false;
        $scope.selected_dl_id = dl_id;
        $http.get('/accHead/getDistWiseDealerLedger?dl_id=' + dl_id)
            .then(response => {
                $scope.ledgers = response.data;
                let data = response.data;
                $scope.totalCredit = 0;
                $scope.totalDebit = 0;
                data.filter(e => e.date = new Date(e.date));
                data.sort((a, b) => a.date - b.date);
                for (let i = 0; i < data.length; i++) {
                    data[i].debit = 0;
                    data[i].credit = 0;
                    if (data[i].to == 'DL-' + dl_id) {
                        data[i].credit = data[i].ammount;
                        data[i].debit = 0;
                        $scope.totalCredit += parseInt(data[i].credit);
                    } else if (data[i].from == 'DL-' + dl_id) {
                        data[i].debit = data[i].ammount;
                        data[i].credit = 0;
                        $scope.totalDebit += parseInt(data[i].debit);
                    }
                    data[i].balance = i == 0 ? parseInt(data[i].credit) - parseInt(data[i].debit) : (parseInt(data[i - 1].balance) + parseInt(data[i].credit)) - parseInt(data[i].debit);
                }
                $scope.loader = false;
                $scope.page2 = true;
            })
    }
    $scope.loadDelears = () => {
        $scope.loader = true;
        $http.get('/accHead/getAllDelears')
            .then(response => {
                $scope.dlList = response.data;
                $scope.loader = false;
                $scope.page1 = true;
            });
    };
    $scope.loadDelears();
    $scope.gotoPage1 = () => {
        $scope.page2 = false;
        $scope.page1 = true;
    }
    $scope.goto2ndPage = () => {
        $scope.page1 = false;
        $scope.page2 = true;
        $scope.page3 = false;
    }
    $scope.goto3rdPage = () => {
        $scope.page1 = false;
        $scope.page2 = false;
        $scope.page3 = true;
        $scope.printIndent = false;
        $scope.printMRR = false;
        $scope.printApproval = false;
        $scope.printApproval = false;
    }
    $scope.showDetail = async(x) => {
        $scope.page2 = false;
        $scope.loader = true;
        $scope.purpose = x.purpose;
        try {
            if (x.purpose === "advance_dealer_bill") {
                let response = await $http.get('/accHead/getAdvanceDlBillDetail?trans_id=' + x.transaction_id);
                $scope.td = response.data;
            } else if (x.purpose === "pay_against_bill") {
                let response = await $http.get('/accHead/getPayAgainstBillDetail?trans_id=' + x.transaction_id);
                let { td, mrrList } = response.data;
                $scope.td = td;
                $scope.mrrList = mrrList;
            }
            $scope.loader = false;
            $scope.page3 = true;
            $scope.$apply();
        } catch (e) {
            console.error(e.data);
            window.alert("Data can't fetch now. Please try again.");
            $scope.loader = false;
            $scope.page2 = true;
            $scope.$apply();
        }
    }
    $scope.viewIndent = async(indent_no) => {
        $scope.page3 = false;
        $scope.loadingData = true;
        try {
            let response = await $http.get('/accHead/getIndentDetailsByIndentNo?indent_no=' + indent_no);
            $scope.paymentList = response.data;
            var data = Enumerable.From($scope.paymentList)
                .GroupBy(function(item) { return (item.implement && item.make && item.model); })
                .Select(function(item) {
                    let length = item.source.length;
                    let newItem = {};
                    newItem.items = length;
                    newItem.implement = item.source[0].implement;
                    newItem.make = item.source[0].make;
                    newItem.model = item.source[0].model;
                    newItem.dl_name = item.source[0].dl_name;
                    newItem.purchase_price = parseInt(item.source[0].p_taxable_value) * parseInt(length);
                    newItem.tax_1 = parseInt(item.source[0].p_cgst_6) * parseInt(length);
                    newItem.tax_2 = parseInt(item.source[0].p_sgst_6) * parseInt(length);
                    newItem.final_ammount = (parseInt(item.source[0].p_invoice_value)) * parseInt(length);
                    return newItem;
                })
                .ToArray();
            $scope.paymentList = data;

            let info = response.data[0];
            $scope.indent_no = indent_no;
            $scope.indent_date = new Date(info.indent_date);
            $scope.dealerName = info.dl_name;
            $scope.dealerAddress = info.dl_address;
            $scope.dealerMobile = info.dl_mobile_no;
            $scope.dmName = info.dm_name;
            $scope.acc_name = info.acc_name;
            $scope.loadingData = false;
            $scope.printIndent = true;
            $scope.$apply();
        } catch (e) {
            console.error(e.data);
            window.alert("Data can't fetch now. Please try again.");
            $scope.loader = false;
            $scope.page3 = true;
            $scope.$apply();
        }
    }
    $scope.viewMrr = async(mrr_id) => {
        $scope.page3 = false;
        $scope.loader = true;
        $scope.mrr_id = mrr_id;
        try {
            let response = await $http.get('/accHead/getMRRDetails?mrr_id=' + mrr_id + '&dl_id=' + $scope.selected_dl_id);
            let data = response.data;
            $scope.dl = data.dl;
            $scope.received_date = new Date(data.invoice.receive_date);
            $scope.invoice = data.invoice;
            $scope.memoNo = '           ';
            $scope.memoDate = `           `;
            $scope.totalPriceInTable = 0;
            $scope.printData = Enumerable.From(data.data)
                .GroupBy(function(item) { return item.implement && item.make && item.model; })
                .Select(function(item) {
                    item.source[0].quantityReceived = item.source.length;
                    item.source[0].totalQuantity = data.invoice.items;
                    item.source[0].price = parseInt(item.source[0].p_taxable_value) * parseInt(item.source[0].totalQuantity);
                    $scope.totalPriceInTable = parseInt($scope.totalPriceInTable) + parseInt(item.source[0].price);
                    return item.source[0]
                })
                .ToArray();
            $scope.loader = false;
            $scope.printMRR = true;
            $scope.$apply();
        } catch (e) {
            console.error(e.data);
            window.alert("Data can't fetch now. Please try again.");
            $scope.loader = false;
            $scope.page3 = true;
            $scope.$apply();
        }
    }
    $scope.showApproval = async(approval_id) => {
        $scope.page3 = false;
        $scope.loader = true;
        try {
            let response = await $http.get('/accHead/getApprovalDetail?approval_id=' + approval_id);
            let { aprDetail: ad, apprItems } = response.data;
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
                dl_name: ad.dl_name,
                dl_address: ad.dl_address,
                bank_name: ad.bank_name,
                dl_ac_no: ad.dl_ac_no,
                dl_ifsc_code: ad.dl_ifsc_code,
                dl_mobile_no: ad.dl_mobile_no,
                dl_email: ad.dl_email
            };
            $scope.less_cgst = 0;
            $scope.less_sgst = 0;
            $scope.invoice_items = Enumerable.From(apprItems)
                .GroupBy((item) => { return item.implement && item.make && item.model; })
                .Select(function(item) {
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
            $scope.printApproval = true;
            $scope.$apply();
        } catch (e) {
            console.error(e.data);
            window.alert("Data can't fetch now. Please try again.");
            $scope.loader = false;
            $scope.page3 = true;
            $scope.$apply();
        }
    }
});

app.filter('convertDate', function() {
    return function(dateValue) {
        var newDate = new Date(dateValue).toLocaleDateString("en-US");
        return moment(newDate).format('DD-MM-YYYY');
    };
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