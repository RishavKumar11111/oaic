var app = angular.module("myApp", [])
app.controller("myCtrl", async function($scope, $http) {
    var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    var dist_id = document.querySelector('meta[name="distcode"]').getAttribute('content');
    $scope.print_page = false;
    $scope.enter_detail = true;
    $scope.c_date = new Date(c_date);
    $scope.system = 'farm_mechanisation';
    $http.get('/accountant/getAccName?dist_id=' + dist_id)
        .then(response => {
            $scope.acc_name = response.data.acc_name;
        });
    $http.get('/accountant/getDistName?dist_id=' + dist_id)
        .then(response => {
            $scope.dist_name = response.data.dist_name;
        });
    $scope.loadOrderNoList = () => {
        $http.get('/accountant/getOpeningBalanceOrderNos?system=' + $scope.system)
            .then(response => {
                $scope.order_no_list = response.data;
            })
    }
    $scope.loadOrderNoList();
    $scope.receiveOPBalance = () => {
        $scope.print_page = true;
        $scope.enter_detail = false;
    }
    $scope.back = () => {
        $scope.print_page = false;
        $scope.enter_detail = true;
    }
    $scope.submit = async() => {
        let data = {
            order_no: $scope.order_no.order_no,
            system: $scope.system,
            head: $scope.head,
            subhead: $scope.subhead,
            amount: $scope.amount,
            payment_date: $scope.payment_date,
            remark: $scope.remark,
            dist_id: dist_id,
            to: $scope.pay_to
        }
        try {
            var req = {
                method: 'POST',
                url: '/accountant/addPaidOpeningBalance',
                headers: {
                    'csrf-token': token
                },
                data: data
            }
            let response = await $http(req);
            $scope.receipt_no = response.data;
            $scope.$apply();
            printElem('receipt');
            setTimeout(() => {
                window.location.href = '/accountant/paidOpeningBalance';
            }, 500);
        } catch (e) {
            window.alert('Server error. Please try again.');
            console.error(e.data);
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