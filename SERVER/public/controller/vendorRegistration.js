var app = angular.module("myApp", [])
app.controller("myCtrl", function ($scope, $http) {
    var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    $scope.stateList = []
    $scope.bankList = []
    $http.get('/getStateList')
        .then(response => {
            $scope.stateList = response.data;
        });
    $http.get('/getDistrictList')
            .then(response => {
                $scope.districtList = response.data;
            });
    $http.get('/getBankList')
            .then(response => {
                $scope.bankList = response.data;
            });
    $scope.step1 = true;
    $scope.step2 = false;
    $scope.step3 = false;
    $scope.step4 = false;
    $scope.step5 = false;
    $scope.step6 = false;
    $scope.step7 = false;
    $scope.stepper = true;


    $scope.step1Complete = false;
    $scope.step2Complete = false;
    $scope.step3Complete = false;
    $scope.step4Complete = false;
    $scope.step5Complete = false;
    $scope.step6Complete = false;


    $scope.userID = '';
    $scope.principalPlace = {};
    $scope.principalPlace.Country = 'India';

    $scope.authorisedSignatoryList = [];
    $scope.principalPlacesList = [];
    $scope.bankAccountsList = [];
    $scope.selectedDistrictList = [];
    $scope.bankAccountDocumentsList = [];
    $scope.district = '';

    $scope.back = () => {
        window.location.href = `/login`;
    }
    $scope.goToStep1 = () => {
        $scope.step1 = true;
        $scope.step2 = false;
        $scope.step3 = false;
        $scope.step4 = false;
        $scope.step5 = false;
        $scope.step6 = false;
        $scope.step7 = false;
    }
    $scope.goToStep2 = () => {
        $scope.step1 = false;
        $scope.step2 = true;
        $scope.step3 = false;
        $scope.step4 = false;
        $scope.step5 = false;
        $scope.step6 = false;
        $scope.step7 = false;
    }
    $scope.goToStep3 = () => {
        $scope.step1 = false;
        $scope.step2 = false;
        $scope.step3 = true;
        $scope.step4 = false;
        $scope.step5 = false;
        $scope.step6 = false;
        $scope.step7 = false;
    }
    $scope.goToStep4 = () => {
        $scope.step1 = false;
        $scope.step2 = false;
        $scope.step3 = false;
        $scope.step4 = true;
        $scope.step5 = false;
        $scope.step6 = false;
        $scope.step7 = false;
    }
    $scope.goToStep5 = () => {
        $scope.step1 = false;
        $scope.step2 = false;
        $scope.step3 = false;
        $scope.step4 = false;
        $scope.step5 = true;
        $scope.step6 = false;
        $scope.step7 = false;
    }
    $scope.goToStep6 = () => {
        $scope.step1 = false;
        $scope.step2 = false;
        $scope.step3 = false;
        $scope.step4 = false;
        $scope.step5 = false;
        $scope.step6 = true;
        $scope.step7 = false;
    }
    $scope.goToStep7 = () => {
        $scope.step1 = false;
        $scope.step2 = false;
        $scope.step3 = false;
        $scope.step4 = false;
        $scope.step5 = false;
        $scope.step6 = false;
        $scope.step7 = true;
    }

    $scope.addAuthorisedSignatory = () => {
        $scope.authorisedSignatoryList.push($scope.authorisedSignatory);
        $scope.authorisedSignatory = {};
    }
    $scope.removeAuthorisedSignatory = (index) => {
        $scope.authorisedSignatoryList.splice(index, 1);
    }
    $scope.modifyAuthorisedSignatory = (index, x) => {
        $scope.authorisedSignatoryList.splice(index, 1);
        $scope.authorisedSignatory = x;
    }

    

    $scope.addPrincipalPlace = () => {
        $scope.principalPlacesList.push($scope.principalPlace);
        $scope.principalPlace = {};
        $scope.principalPlace.Country = 'India';
    }
    $scope.removePrincipalPlace = (index) => {
        $scope.principalPlacesList.splice(index, 1);
    }
    $scope.modifyPrincipalPlace = (index, x) => {
        $scope.principalPlacesList.splice(index, 1);
        $scope.principalPlace = x;
    }

    

    $scope.addBankAccount = () => {
        let doc = document.getElementById('uploadBankDocument');
        if(doc.files[0]) {
            $scope.bankAccountDocumentsList.push(doc.files[0]);
            $scope.bankAccountsList.push($scope.bank);
            $scope.bank = {};
            doc.value = null;
        } else {
            window.alert('Please upload Bank Passbook/Bank Statement/Cancelled Check.')
        }
    }
    $scope.removeBankAccount = (index) => {
        $scope.bankAccountsList.splice(index, 1);
        $scope.bankAccountDocumentsList.splice(index, 1);
    }
    $scope.modifyBankAccount = (index, x) => {
        $scope.bankAccountsList.splice(index, 1);
        $scope.bankAccountDocumentsList.splice(index, 1);
        $scope.bank = x;
    }


    $scope.register = async () => {
        try {



            // Validate step 2
            if( $scope.selectedDistrictList.length > 0 ) {
                if($scope.goodsOrServicesList.length > 0) {

                // Validate step3
                
                if($scope.authorisedSignatoryList.length > 0) {
                        const contactPersonData = $scope.authorisedSignatoryList

                        // Validate step 4

                        if($scope.principalPlacesList.length > 0) {
                                const principalPlaceData = $scope.principalPlacesList


                                // Validate step 5                                
                                if($scope.bankAccountsList.length > 0) {
                                    const bankAccountData = $scope.bankAccountsList;


                                    


                                           if(await validateAllsteps()) {
                                            const formData = new FormData();
                                            const request = new XMLHttpRequest();
                                            formData.append('PANDocument', $scope.PANDoument);
                                            formData.append('GSTNDocument', $scope.GSTNDocument);
                        
                        
                                            if($scope.bussiness.WhetherMSME == 'Yes' ) {
                                                formData.append('MSMECertificate', $scope.MSMECertificate);
                                            }
                                            if($scope.bussiness.WhetherSSIUnit == 'Yes' ) {
                                                formData.append('SSIUnitRegistrationCertificate', $scope.SSIUnitRegistrationCertificate);
                                            }
                                            
                                            for(let i = 0; i < $scope.bankAccountDocumentsList.length; i++) {
                                                formData.append('bankAccountDocument', $scope.bankAccountDocumentsList[i]);
                                            }
                        
                            
                                            $scope.password.newPassword = SHA256($scope.password.newPassword);
                                            $scope.password.confirmPassword = SHA256($scope.password.confirmPassword);

                                            const serviceData = { districtList : $scope.selectedDistrictList, servicesList: $scope.goodsOrServicesList, serviceDetails: $scope.service }
                                            const allData = {
                                                basicDetails: $scope.bussiness,
                                                serviceData: serviceData,
                                                contactPersonData: contactPersonData,
                                                principalPlaceData: principalPlaceData,
                                                bankAccountData: bankAccountData,
                                                password: $scope.password
                                            }
                        
                                            formData.append("Name1", JSON.stringify(allData));
                                            request.onreadystatechange = function() {
                                                if (this.readyState == 4 && this.status == 200) {
                                                    const response = JSON.parse(this.responseText);
                                                    if (response.isSuccess == true) {
                                                        // window.alert('Vendor details successfully saved and successfully created the UserID.');
                                                            $scope.userID = response.userID;
                                                            $scope.goToStep7();
                                                            $scope.stepper = false;
                                                        $scope.$apply();
                                                    } else {
                                                        window.alert(response.message);
                                                        $scope.$apply();
                                                    }
                                                } else if (this.readyState === 4 && this.status != 200) {
                                                    window.alert('Network problem. Please refresh the page and try again.');
                                                    $scope.$apply();
                                                }
                                            };
                                            request.open("POST", "/registerVendor?_csrf="+token);
                                            request.send(formData);
                                           }
                
                                            



                                } else {
                                    window.alert(`Add Bank Account Details First`);
                                }

                                // Validate step 5


                        } else {
                            window.alert(`Add Principal Places First`)
                        }

                        // Validate step 4




                } else {
                    window.alert(`Add Contact Person's Details First`)
                }



                                    
                } else {
                    window.alert(`Please Add All Services First`)
                }
            } else {
                window.alert('Please Add All Services First');
            }

        } catch (e) {
            window.alert('Sorry. Network problem. Plaese try again.');
            console.error(e);
        }
    }
    validateAllsteps = () => {
        return new Promise((resolve, reject) => {
            if($scope.step1Complete) {
                if($scope.step2Complete) {
                    if($scope.step3Complete) {
                        if($scope.step4Complete) {
                            if($scope.step5Complete) {
                                resolve(true);
                            } else {
                                window.alert('Please Save Bank Details')
                                resolve(false);
                            }
            
                        } else {
                            window.alert('Please Save Principal places Details')
                            resolve(false);
                        }
        
                    } else {
                        window.alert('Please Save Contact Persons Details')
                        resolve(false);
                    }
    
                } else {
                    window.alert('Please Save All Services')
                    resolve(false);
                }

            } else {
                window.alert('Please Save Basic Details First')
                resolve(false);
            }
        })
    }
    $scope.finish = () => {
        window.location.href = `/login`;
    }

    $scope.saveStep1 = async () => {
        try {
            if(await $scope.validateStep1()) {

                    // const formData = new FormData();
                    // const request = new XMLHttpRequest();
                    // formData.append('PANDocument', $scope.PANDoument);
                    // formData.append('GSTNDocument', $scope.GSTNDocument);


                    // if($scope.bussiness.WhetherMSME == 'Yes' ) {
                    //     formData.append('MSMECertificate', $scope.MSMECertificate);
                    // }
                    // if($scope.bussiness.WhetherSSIUnit == 'Yes' ) {
                    //     formData.append('SSIUnitRegistrationCertificate', $scope.SSIUnitRegistrationCertificate);
                    // }
                    // formData.append("Name1", JSON.stringify($scope.bussiness));
                    // request.onreadystatechange = function() {
                    //     if (this.readyState == 4 && this.status == 200) {
                    //         const response = JSON.parse(this.responseText);
                    //         if (response.isSuccess == true) {
                    //             // window.alert('Vendor details successfully saved and successfully created the UserID.');
                    //             $scope.userID = response.userID;
                                $scope.step1Complete = true;
                                $scope.goToStep2();
                                $scope.isCompleteStep1 = 'complete-step';
                                $scope.completeStep1Bar = 'complete-step-bar';
                                $scope.completeStep2Bar = 'active';
                    //             $scope.$apply();
                    //         } else {
                    //             window.alert(response.message);
                    //             $scope.$apply();
                    //         }
                    //     } else if (this.readyState === 4 && this.status != 200) {
                    //         window.alert('Network problem. Please refresh the page and try again.');
                    //         $scope.$apply();
                    //     }
                    // };
                    // request.open("POST", "/saveVendorBasicDetails?_csrf="+token);
                    // request.send(formData);
            }
        } catch (e) {
            window.alert('Sorry. Network problem. Plaese try again.');
            console.error(e);
        }
    }
    $scope.saveStep2 = async () => {
        try {
                // if($scope.userID) {
                    if( $scope.selectedDistrictList.length > 0 ) {
                        if($scope.goodsOrServicesList.length > 0) {
                                            // var req = {
                                            //     method: 'POST',
                                            //     url: `/saveVendorServices`,
                                            //     headers: {
                                            //         'csrf-token': token
                                            //     },
                                            //     data: { districtList : $scope.selectedDistrictList, servicesList: $scope.goodsOrServicesList, serviceDetails: $scope.service }
                                            // }
                                            // const response = await $http(req);
                                            // $scope.message = response.data.message;
                                            
                                            // if(response.data.isSuccess) {
                                            //     // window.alert(`Contact person's details successfully updated.`);
                                                $scope.step2Complete = true;
                                                $scope.goToStep3();
                                                $scope.isCompleteStep2 = 'complete-step';
                                                $scope.completeStep2Bar = 'complete-step-bar';
                                                $scope.completeStep3Bar = 'active';
                                            // } else {
                                            //     window.alert(`Failed to update Contact person's details, try again.`);
                                            // }
                                            // $scope.$apply();
                        } else {
                            window.alert(`Add minimum 1 Service`)
                        }
                    } else {
                        window.alert('Please apply minimum for 1 district');
                    }
                // } else {
                //     window.alert('Please add Basic Details First');
                // }
        } catch {
            window.alert('Network problem. Please refresh the page and try again');
        }
    }
    $scope.saveStep3 = async () => {
        try {
                // if($scope.userID) {
                            if($scope.authorisedSignatoryList.length > 0) {
                                // var req = {
                                //     method: 'POST',
                                //     url: `/updateVendorContactPersonDetails`,
                                //     headers: {
                                //         'csrf-token': token
                                //     },
                                //     data: $scope.authorisedSignatoryList
                                // }
                                // const response = await $http(req);
                                // $scope.message = response.data.message;
                                
                                // if(response.data.isSuccess) {
                                //     // window.alert(`Contact person's details successfully updated.`);
                                    $scope.step3Complete = true;
                                    $scope.goToStep4();
                                    $scope.isCompleteStep3 = 'complete-step';
                                    $scope.completeStep3Bar = 'complete-step-bar';
                                    $scope.completeStep4Bar = 'active';
                                // } else {
                                //     window.alert(`Failed to update Contact person's details, try again.`);
                                // }
                                // $scope.$apply();
                            } else {
                                window.alert(`Add minimum 1 person's details`)
                            }
                // } else {
                //     window.alert('Please add Basic Details First');
                // }
        } catch {
            window.alert('Network problem. Please refresh the page and try again');
        }
    }
    $scope.saveStep4 = async () => {
        try {
            // if($scope.userID) {
                        if($scope.principalPlacesList.length > 0) {
                            // var req = {
                            //     method: 'POST',
                            //     url: `/updateVendorPrincipalPlaces`,
                            //     headers: {
                            //         'csrf-token': token
                            //     },
                            //     data: $scope.principalPlacesList
                            // }
                            // const response = await $http(req);
                            // $scope.message = response.data.message;
                            
                            // if(response.data.isSuccess) {
                            //     // window.alert(`Principal places are successfully updated.`);
                                $scope.step4Complete = true;
                                $scope.goToStep5();
                                $scope.isCompleteStep4 = 'complete-step';
                                $scope.completeStep4Bar = 'complete-step-bar';
                                $scope.completeStep5Bar = 'active';
                            // } else {
                            //     window.alert(`Failed to update Principal places, try again.`);
                            // }
                            // $scope.$apply();
                        } else {
                            window.alert(`Add minimum 1 place`)
                        }
            // } else {
            //     window.alert('Please add Basic Details First');
            // }
        } catch {
            window.alert('Network problem. Please refresh the page and try again');
        }
    }
    $scope.saveStep5 = async () => {
        try {
            // if($scope.userID) {
                    if($scope.bankAccountsList.length > 0) {
                        // const formData = new FormData();
                        // const request = new XMLHttpRequest();
                        // for(let i = 0; i < $scope.bankAccountDocumentsList.length; i++) {
                        //     formData.append('bankAccountDocument', $scope.bankAccountDocumentsList[i]);
                        // }

                        // formData.append("Name1", JSON.stringify($scope.bankAccountsList));
                        // request.onreadystatechange = function() {
                        //     if (this.readyState == 4 && this.status == 200) {
                        //         const response = JSON.parse(this.responseText);
                        //         if (response.isSuccess == true) {
                        //                 // window.alert(`Bank Acccount Details are Successfully Updated.`);
                                        $scope.step5Complete = true;
                                        $scope.goToStep6();
                                        $scope.isCompleteStep5 = 'complete-step';
                                        $scope.completeStep5Bar = 'complete-step-bar';
                                        $scope.completeStep6Bar = 'active';
                        //                 $scope.$apply();
                        //         } else {
                        //             window.alert('Please try again. Failed to save due to network problem.');
                        //             $scope.$apply();
                        //         }
                        //     } else if (this.readyState === 4 && this.status != 200) {
                        //         window.alert('Network problem. Please refresh the page and try again.');
                        //         $scope.$apply();
                        //     }
                        // };
                        // request.open("POST", "/updateVendorBankDetails?_csrf="+token);
                        // request.send(formData);
                    } else {
                        window.alert(`Add Minimum 1 Bank Account`);
                    }
            // } else {
            //     window.alert('Please add Basic Details First');
            // }
        } catch {
            window.alert('Network problem. Please refresh the page and try again');
        }
    }

    $scope.validateStep1 = () => {
        return new Promise((resolve, reject) => {                
                if( $scope.bussiness.PAN.length == 10) {
                    if( $scope.bussiness.GSTN.length == 15) {
                        $scope.bussiness.PAN = $scope.bussiness.PAN.toUpperCase();
                        $scope.bussiness.GSTN = $scope.bussiness.GSTN.toUpperCase();
                        $scope.bussiness.LegalBussinessName = $scope.bussiness.LegalBussinessName.toUpperCase();
                        $scope.bussiness.TradeName = $scope.bussiness.TradeName.toUpperCase();
                        
                        
                        $scope.PANDoument = document.getElementById('PANDocument').files[0];
                        $scope.GSTNDocument = document.getElementById('GSTNDocument').files[0];
                        if ($scope.PANDoument != undefined) {
                            if ($scope.PANDoument.type == 'application/pdf') {
                
                
                                if ($scope.GSTNDocument != undefined) {
                                    if ($scope.GSTNDocument.type == 'application/pdf') {
                        
                
                
                                        let msmseStatus = $scope.bussiness.WhetherMSME == 'Yes' ? true : false;
                                        let RegistrationStatus = $scope.bussiness.WhetherSSIUnit == 'Yes' ? true : false;
                                        let msmeIsUpload = true;
                                        let regIsupload = true;
                                        if(msmseStatus) {
                                            $scope.MSMECertificate = document.getElementById('MSMECertificate').files[0];
                                            if($scope.MSMECertificate == undefined) {
                                                msmeIsUpload = false;
                                                window.alert('Please upload MSME Certificate');
                                            } else {
                                                msmeIsUpload = true;
                                            }
                                        }
        
                                        if(RegistrationStatus) {
                                            $scope.SSIUnitRegistrationCertificate = document.getElementById('RegistrationCertificate').files[0];
                                            if($scope.SSIUnitRegistrationCertificate == undefined) {
                                                regIsupload = false;
                                                window.alert('Please upload Registration Certificate');
                                            } else {
                                                regIsupload = true;
                                            }
                                            
                                        }
                                        if(msmeIsUpload && regIsupload) {
                                            resolve(true);
                                        } else {
                                            resolve(false);
                                        }
        
                
                
                
                                    } else {
                                        window.alert('GSTN Document should be a PDF File !!')
                                        resolve(false);
                                    }
                                } else {
                                    window.alert('Upload GSTN Document');
                                    resolve(false);
                                }
                
                
                
                
                
                
                
                            } else {
                                window.alert('Account Document should be a PDF File !!');
                                resolve(false);
                            }
                        } else {
                            window.alert('Upload PAN Document');
                            resolve(false);
                        }
                    
                    } else {
                        window.alert('GSTN must be 15 digit.');
                        resolve(false);
                    }
                } else {
                    window.alert('PAN must be 10 digit.');
                    resolve(false);
                }
        })
    }
    $scope.saveStep6 = () => {
        if($scope.password.newPassword = $scope.password.confirmPassword) {
            $scope.step6Complete = true;
            $scope.register();
            $scope.isCompleteStep5 = 'complete-step';
            $scope.completeStep5Bar = 'complete-step-bar';
        } else {
            window.alert('Please add Basic Details First');
        }
    }

    $scope.goodsOrServicesList = [];
    $scope.AddGoodsOrServices = () => {
        if($scope.goodsOrServices) {
            if(!$scope.goodsOrServicesList.includes($scope.goodsOrServices)) {
                $scope.goodsOrServicesList.push($scope.goodsOrServices);
            } else {
                window.alert('Item already added.');
            }
            $scope.goodsOrServices = '';
        } else {
            window.alert('Please select Goods/Services first')
        }
    }

    $scope.AddDistrict = () => {
        if($scope.district) {
            console.log($scope.district);

            if($scope.district == 'ALL'){
                $scope.selectedDistrictList = []
                $scope.districtList.forEach((e) =>{
                    $scope.selectedDistrictList.push(e)
                })
            }
            else{
                const dist = JSON.parse($scope.district);

                const distIDs = $scope.selectedDistrictList.map(e => e.dist_id);
                if(distIDs.includes(dist.dist_id)) {
                    window.alert('District Already selected');
                } else {
                    $scope.selectedDistrictList.push(dist);
                }
                $scope.district = '';
            }

        } else {
            window.alert('Please select District first');
        }
    }
    $scope.removeDistrict = (index) => {
        $scope.selectedDistrictList.splice(index, 1);
    }
});
