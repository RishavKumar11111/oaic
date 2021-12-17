var app = angular.module("myApp", [])
app.controller("myCtrl", function($scope, $http) {
    var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    var dist_id = document.querySelector('meta[name="distcode"]').getAttribute('content');
    $scope.showTable = false;
    $scope.show_print_page = false;
    $scope.loader = false;
    $scope.fin_year = c_fin_year;
    $http.get('/api/getFinYear')
        .then(response => {
            $scope.fin_year_list = response.data;
        });
        
    $http.get('/accountant/getDMDetails')
        .then(response => {
            $scope.DMDetails = response.data;
            console.log($scope.DMDetails);
        });
    $http.get('/accountant/getAccName?dist_id=' + dist_id)
            .then(response => {
                $scope.AccountantDetails = response.data;
            });
    $scope.loadList = () => {
        $scope.loader = true;
        $scope.show_print_page = false;
        $http.get('/accountant/getItemsForDeliverToCustomer?dist_id=' + dist_id + '&fin_year=' + $scope.fin_year)
            .then(response => {
                let available_stocks = [];
                let indent_generated = [];
                let invoice_generated = [];
                let paid_items = [];
                $scope.items = Enumerable.From(response.data)
                    .Select(function(item, index) {
                        if (item.status == 'received') {
                            available_stocks.push(index + 1)
                        }
                        if (item.status == 'generated') {
                            indent_generated.push(index + 1)
                        }
                        if (item.status == 'delivered') {
                            invoice_generated.push(index + 1)
                        }
                        if (item.status == 'paid') {
                            paid_items.push(index + 1)
                        }
                        return item;
                    })
                    .ToArray();

                setTimeout(() => {
                    available_stocks.forEach(index => {
                        document.getElementById("orderListTable").getElementsByTagName("tr")[index].setAttribute("style", "background-color: green;color:white;");
                        // document.getElementById("orderListTable").getElementsByTagName("tr")[index].setAttribute("style","color: white;");
                        document.getElementById("orderListTable").getElementsByTagName("tr")[index].getElementsByTagName("td")[6].getElementsByTagName("button")[0].setAttribute('style', 'color:white;border-color:white;');
                        document.getElementById("orderListTable").getElementsByTagName("tr")[index].getElementsByTagName("td")[6].getElementsByTagName("button")[1].setAttribute('style', 'color:white;border-color:white;');
                    })
                    paid_items.forEach(index => {
                        // document.getElementById("orderListTable").getElementsByTagName("tr")[index].setAttribute("style", "background-color: pink;");
                        // document.getElementById("orderListTable").getElementsByTagName("tr")[index].getElementsByTagName("td")[6].getElementsByTagName("button")[1].disabled = true;
                    })
                    indent_generated.forEach(index => {
                        document.getElementById("orderListTable").getElementsByTagName("tr")[index].setAttribute("style", "background-color: yellow;");
                        // document.getElementById("orderListTable").getElementsByTagName("tr")[index].getElementsByTagName("td")[6].getElementsByTagName("button")[1].disabled = true;
                    })
                    invoice_generated.forEach(index => {
                        document.getElementById("orderListTable").getElementsByTagName("tr")[index].setAttribute("style", "background-color: pink;");
                        // document.getElementById("orderListTable").getElementsByTagName("tr")[index].getElementsByTagName("td")[6].getElementsByTagName("button")[1].disabled = true;
                    })
                }, 500);
                $scope.loader = false;
                $scope.showTable = true;

            })
    }
    $scope.loadList();
    $scope.showDetailes = function(x) {
        $scope.x = x;
    }
    $scope.subTotal = 0;
    $scope.showDelivery = function(x) {
        $scope.permitno = x.permit_no;
        x.invoiceValue = x.p_invoice_value;
        $scope.subTotal = parseInt($scope.subTotal) + parseInt(x.invoiceValue);
        $scope.x = x;
        $http.get('/accountant/getPermitDetail?permit_no=' + x.permit_no)
            .then(response => {
                $scope.indent_no = response.data.indent_no;
                $scope.indent_date = response.data.indent_date;
                $scope.invoice_no = response.data.invoice_no;
                $scope.invoice_date = response.data.invoice_date;
                $scope.mrr_no = response.data.mrr_id;
                $scope.mrr_date = response.data.mrr_date;
            });
    }
    $scope.showInvoice = () => {
        $scope.showTable = false;
        $scope.show_print_page = true;
    }
    $scope.deliverPreview = async() => {
        $scope.showTable = false;
        $scope.loader = true;
        try {
            var req = {
                method: 'POST',
                url: '/accountant/updateDeliverToCustomerStatus?permit_no=' + $scope.permitno + '&remark=' + $scope.remark + '&expected_delivery_date=' + new Date($scope.expected_delivery_date),
                headers: {
                    'csrf-token': token
                }
            }
            await $http(req);
            $scope.loader = false;
            $scope.$apply();
            printElem('invoice');
            setTimeout(() => {
                window.location.href = '/accountant/deliverToCustomer';
            }, 500)
        } catch (e) {
            $scope.loader = false;
            window.alert('Server Problem. Try Again!!');
            console.error(e.data);
            $scope.$apply();
        }
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