var app = angular.module("myApp", [])
app.controller("myCtrl", function($scope, $http) {
    var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    $scope.loadingData = false;
    $scope.first_box = false;

    $scope.changePassword = async () => {
        try {
            let data = {
                oldPassword: SHA256($scope.oldPassword),
                newPassword: $scope.newPassword,
                confirmPassword: $scope.confirmPassword
            }
            var req = {
                method: 'POST',
                url: '/changePassword',
                headers: {
                    'csrf-token': token
                },
                data: data
            }
            const response = await $http(req);
            $scope.message = response.data.message;
            if(response.data.isSuccess) {
                window.alert('Password updated successfully, Login with your new password.');
                window.location.replace('/login');
            } else {
                window.alert('Please try again. Failed to update your password');
            }
        } catch (e) {
            window.alert('Sorry. Server problem. Plaese try again.');
            console.error(e);
        }
    }
});