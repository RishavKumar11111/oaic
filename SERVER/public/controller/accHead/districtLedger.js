var app = angular.module("myApp", [])
app.controller("myCtrl", function($scope, $http) {
    $scope.fin_year = c_fin_year;
    $scope.loader = true;
    $scope.header = false;
    $scope.page1 = false;
    $scope.ledgerTable = false;
    $http.get('/api/getFinYear')
        .then(response => {
            $scope.fin_year_list = response.data;
            $scope.header = true;
        });
    $scope.getAllDistrictLedgerData = async() => {
        $scope.loader = true;
        try {
            let response = await $http.get('/accHead/getAllDistrictLedgerData?fin_year=' + $scope.fin_year);
            $scope.ledgers = response.data;
            $scope.distLedgerList = response.data;
            let data = response.data;
            $scope.TDLCredit = 0;
            $scope.TDLDebit = 0;
            for (let i = 0; i < data.length; i++) {
                $scope.TDLCredit += parseFloat(data[i].credit);
                $scope.TDLDebit += parseFloat(data[i].debit);
            }
            $scope.loader = false;
            $scope.page1 = true;
            $scope.$apply();
        } catch (e) {
            console.error(e.data);
            window.alert("Network error. Please try again.");
            $scope.loader = false;
            $scope.$apply();
        }
    }
    $scope.getAllDistrictLedgerData();
    $scope.showDistWiseLedger = (dist_id) => {
        $scope.page1 = false;
        $scope.header = false;
        $scope.loader = true;
        $http.get('/accHead/getAllLedgers?dist_id=' + dist_id + '&fin_year=' + $scope.fin_year)
            .then(response => {
                $scope.ledgers = response.data;
                let data = response.data;
                $scope.opening_balance = 0;
                $scope.totalCredit = 0;
                $scope.totalDebit = 0;
                data.filter(e => e.date = new Date(e.date));
                data.sort((a, b) => a.date - b.date);
                for (let i = 0; i < data.length; i++) {

                    if (data[i].to == 'DS-' + dist_id) {
                        data[i].credit = data[i].ammount;
                        data[i].debit = 0;
                        $scope.totalCredit += parseFloat(data[i].credit);
                    } else if (data[i].from == 'DS-' + dist_id) {
                        data[i].debit = data[i].ammount;
                        data[i].credit = 0;
                        $scope.totalDebit += parseFloat(data[i].debit);
                    }
                    if (i == 0) {
                        data[i].balance = parseFloat(data[i].credit) - parseFloat(data[i].debit);
                    } else {
                        data[i].balance = (parseFloat(data[i - 1].balance) + parseFloat(data[i].credit)) - parseFloat(data[i].debit);
                    }
                }
                $scope.total_credit = $scope.totalCredit;
                $scope.total_debit = $scope.totalDebit;
                $scope.loader = false;
                $scope.ledgerTable = true;
            })
    }
    $scope.back = () => {
        $scope.header = true;
        $scope.page1 = true;
        $scope.ledgerTable = false;
    }
});

app.filter('dateRangeFrom', function() {
    return function(items, fromDate, scope) {
        var filtered = [];
        if (fromDate != undefined) {
            scope.ledgers.sort((a, b) => a.date - b.date);
            scope.opening_balance = 0;
            for (let i = 0; i < scope.ledgers.length; i++) {
                if (Date.parse(scope.ledgers[i].date) < Date.parse(fromDate)) {
                    if (i == 0) {
                        scope.ledgers[i].balance = parseFloat(scope.ledgers[i].credit) - parseFloat(scope.ledgers[i].debit);
                    } else {
                        scope.ledgers[i].balance = (parseFloat(scope.ledgers[i - 1].balance) + parseFloat(scope.ledgers[i].credit)) - parseFloat(scope.ledgers[i].debit);
                    }
                    scope.opening_balance = scope.ledgers[i].balance;
                }
            }
            angular.forEach(items, item => {
                if (Date.parse(item.date) >= Date.parse(fromDate)) {
                    filtered.push(item);
                }
            });
            scope.totalCredit = 0;
            scope.totalDebit = 0;
            filtered.sort((a, b) => b.date - a.date);
            for (let i = 0; i < filtered.length; i++) {
                filtered[i].balance = (i == 0) ? parseFloat(filtered[i].credit) - parseFloat(filtered[i].debit) : (parparseFloatseInt(filtered[i - 1].balance) + parseFloat(filtered[i].credit)) - parseFloat(filtered[i].debit);
                scope.totalCredit += parseFloat(filtered[i].credit);
                scope.totalDebit += parseFloat(filtered[i].debit);
            }
            return filtered;
        } else {
            return items;
        }

    };
});
app.filter('dateRangeTo', function() {
    return function(items, toDate, scope) {
        var filtered = [];
        if (toDate != undefined) {
            angular.forEach(items, function(item) {
                if (Date.parse(item.date) <= Date.parse(toDate)) {
                    filtered.push(item);
                }
            });
            scope.totalCredit = 0;
            scope.totalDebit = 0;
            for (let i = 0; i < filtered.length; i++) {
                filtered[i].balance = (i == 0) ? parseFloat(filtered[i].credit) - parseFloat(filtered[i].debit) : (parseFloat(filtered[i - 1].balance) + parseFloat(filtered[i].credit)) - parseFloat(filtered[i].debit);
                scope.totalCredit += parseFloat(filtered[i].credit);
                scope.totalDebit += parseFloat(filtered[i].debit);
            }
            return filtered;
        } else {
            return items;
        }
    };
});