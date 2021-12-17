import { ToastrService } from 'ngx-toastr';
import { Component, Input, OnInit, Output, EventEmitter } from '@angular/core';
import { CommonService } from 'src/app/services/common.service';

declare const document: any;
@Component({
    selector: 'app-vendor-registration',
    templateUrl: './vendor-registration.component.html',
    styleUrls: ['./vendor-registration.component.css']
})
export class VendorRegistrationComponent implements OnInit {


    @Input() selectedVendorID: any;
    @Output() backEvent = new EventEmitter<string>();

    Data: any = {};
    constructor(
        private serviceService: CommonService,
        private toastr: ToastrService) {
        this.loadDistrictList();
        this.loadStateList();
    }

    ngOnInit(): void {
        this.loadAllVendorDetails();
    }


    goto1stPage() {
        this.backEvent.emit();
    }


    loadAllVendorDetails = async () => {

        this.Data = await this.serviceService.get('/admin/getDlAllDetailByDlId?VendorID=' + this.selectedVendorID);

        this.bussiness.LegalBussinessName = this.Data.LegalBussinessName;
        this.bussiness.TradeName = this.Data.TradeName;
        this.bussiness.PAN = this.Data.PAN;
        this.bussiness.GSTN = this.Data.GSTN;
        this.bussiness.BussinessConstitution = this.Data.BussinessConstitution;
        this.bussiness.IncorporationDate = new Date(this.Data.IncorporationDate);
        this.bussiness.ContactNumber = this.Data.ContactNumber;
        this.bussiness.EmailID = this.Data.EmailID;
        this.bussiness.WhetherMSME = this.Data.WhetherMSME;
        this.bussiness.WhetherSSIUnit = this.Data.WhetherSSIUnit;

        this.service.Turnover1 = this.Data.Turnover1;
        this.service.Turnover2 = this.Data.Turnover2;
        this.service.Turnover3 = this.Data.Turnover3;
        this.service.CoreBussinessActivity = this.Data.CoreBussinessActivity;

        this.selectedDistrictList = this.Data.AppliedDistrictList.map((e: any) => { return { dist_id: e.DistrictID, dist_name: e.DistrictName } });
        this.goodsOrServicesList = this.Data.GoodsOrServicesList.map((e: any) => e.Service);

        this.authorisedSignatoryList = this.Data.ContactPersonList;
        this.principalPlacesList = this.Data.PrincipalPlacesList;
        this.bankAccountsList = this.Data.BankAccountsList;


        this.isCompleteStep1 = 'complete-step';
        this.completeStep1Bar = 'complete-step-bar';
        this.completeStep2Bar = 'active';

        this.isCompleteStep2 = 'complete-step';
        this.completeStep2Bar = 'complete-step-bar';
        this.completeStep3Bar = 'active';

        this.isCompleteStep3 = 'complete-step';
        this.completeStep3Bar = 'complete-step-bar';
        this.completeStep4Bar = 'active';

        this.isCompleteStep4 = 'complete-step';
        this.completeStep4Bar = 'complete-step-bar';
        this.completeStep5Bar = 'active';

        this.isCompleteStep5 = 'complete-step';

        this.goToStep1();
    }





    stateList: any = [];
    districtList: any = [];
    loadDistrictList = async () => {
        try {
            this.districtList = await this.serviceService.get('/getDistrictList');
        } catch (e) {
            this.toastr.error(`Network problem`)
        }
    }
    loadStateList = async () => {
        try {
            this.stateList = await this.serviceService.get('/getStateList');
        } catch (e) {
            this.toastr.error(`Network problem`)
        }
    }
    step1 = true;
    step2 = false;
    step3 = false;
    step4 = false;
    step5 = false;
    stepper = true;


    step1Complete = false;
    step2Complete = false;
    step3Complete = false;
    step4Complete = false;
    step5Complete = false;


    principalPlace: any = { Country: 'India' };

    authorisedSignatoryList: any = [];
    principalPlacesList: any = [];
    bankAccountsList: any = [];
    selectedDistrictList: any = [];
    bankAccountDocumentsList: any = [];
    district: any = '';
    authorisedSignatory: any = {};



    bank: any = {};


    bussiness: any = {};
    MSMECertificate: any;
    SSIUnitRegistrationCertificate: any;
    service: any = {};

    selectedBankAccountNumber = '';
    isCompleteStep1: any;
    completeStep1Bar: any;
    completeStep2Bar: any;
    isCompleteStep2: any;
    completeStep3Bar: any;
    isCompleteStep3: any;
    completeStep4Bar: any;
    isCompleteStep4: any;
    completeStep5Bar: any;
    isCompleteStep5: any;
    userID: string = '';


    addAuthorisedSignatory = () => {
        this.authorisedSignatoryList.push(this.authorisedSignatory);
        this.authorisedSignatory = {};
    }
    removeAuthorisedSignatory = (index: number) => {
        this.authorisedSignatoryList.splice(index, 1);
    }
    modifyAuthorisedSignatory = (index: number, x: any) => {
        this.authorisedSignatoryList.splice(index, 1);
        this.authorisedSignatory = x;
    }



    addPrincipalPlace = () => {
        this.principalPlacesList.push(this.principalPlace);
        this.principalPlace = {};
        this.principalPlace.Country = 'India';
    }
    removePrincipalPlace = (index: number) => {
        this.principalPlacesList.splice(index, 1);
    }
    modifyPrincipalPlace = (index: number, x: any) => {
        this.principalPlacesList.splice(index, 1);
        this.principalPlace = x;
    }



    addBankAccount = async () => {
        const data = { originalItem: { VendorID: this.selectedVendorID, AccountNumber: this.selectedBankAccountNumber }, updateData: this.bank }
        await this.serviceService.post(`/admin/updateVendorBankDetails`, data);
        // this.bankAccountDocumentsList.push(doc.files[0]);
        this.bankAccountsList.push(this.bank);
        this.bank = {};
        this.selectedBankAccountNumber = '';
    }
    removeBankAccount = (index: number) => {
        this.bankAccountsList.splice(index, 1);
        this.bankAccountDocumentsList.splice(index, 1);
    }
    modifyBankAccount = (index: number, x: any) => {
        this.bankAccountsList.splice(index, 1);
        this.bankAccountDocumentsList.splice(index, 1);
        this.selectedBankAccountNumber = x.AccountNumber;
        this.bank = x;
    }


    updateDetails = async () => {
        try {



            // Validate step 2
            if (this.selectedDistrictList.length > 0) {
                if (this.goodsOrServicesList.length > 0) {

                    // Validate step3

                    if (this.authorisedSignatoryList.length > 0) {
                        const contactPersonData = this.authorisedSignatoryList

                        // Validate step 4

                        if (this.principalPlacesList.length > 0) {
                            const principalPlaceData = this.principalPlacesList


                            // Validate step 5                                
                            if (this.bankAccountsList.length > 0) {
                                const bankAccountData = this.bankAccountsList;





                                if (await this.validateAllsteps()) {
                                    console.log('Uppdate code here');
                                    // const formData = new FormData();
                                    // const request = new XMLHttpRequest();
                                    // formData.append('PANDocument', this.PANDoument);
                                    // formData.append('GSTNDocument', this.GSTNDocument);


                                    // if(this.bussiness.WhetherMSME == 'Yes' ) {
                                    //     formData.append('MSMECertificate', this.MSMECertificate);
                                    // }
                                    // if(this.bussiness.WhetherSSIUnit == 'Yes' ) {
                                    //     formData.append('SSIUnitRegistrationCertificate', this.SSIUnitRegistrationCertificate);
                                    // }

                                    // for(let i = 0; i < this.bankAccountDocumentsList.length; i++) {
                                    //     formData.append('bankAccountDocument', this.bankAccountDocumentsList[i]);
                                    // }


                                    // this.password.newPassword = SHA256(this.password.newPassword);
                                    // this.password.confirmPassword = SHA256(this.password.confirmPassword);

                                    // const serviceData = { districtList : this.selectedDistrictList, servicesList: this.goodsOrServicesList, serviceDetails: this.service }
                                    // const allData = {
                                    //     basicDetails: this.bussiness,
                                    //     serviceData: serviceData,
                                    //     contactPersonData: contactPersonData,
                                    //     principalPlaceData: principalPlaceData,
                                    //     bankAccountData: bankAccountData,
                                    //     password: this.password
                                    // }

                                    // formData.append("Name1", JSON.stringify(allData));
                                    // request.onreadystatechange = function() {
                                    //     if (this.readyState == 4 && this.status == 200) {
                                    //         const response = JSON.parse(this.responseText);
                                    //         if (response.isSuccess == true) {
                                    //             // window.alert('Vendor details successfully saved and successfully created the UserID.');
                                    //                 this.userID = response.userID;
                                    //                 this.goToStep7();
                                    //                 this.stepper = false;
                                    //             this.$apply();
                                    //         } else {
                                    //             window.alert(response.message);
                                    //             this.$apply();
                                    //         }
                                    //     } else if (this.readyState === 4 && this.status != 200) {
                                    //         window.alert('Network problem. Please refresh the page and try again.');
                                    //         this.$apply();
                                    //     }
                                    // };
                                    // request.open("POST", "/registerVendor?_csrf="+token);
                                    // request.send(formData);
                                }





                            } else {
                                this.toastr.warning(`Add Bank Account Details First`);
                            }

                            // Validate step 5


                        } else {
                            this.toastr.warning(`Add Principal Places First`)
                        }

                        // Validate step 4




                    } else {
                        this.toastr.warning(`Add Contact Person's Details First`)
                    }




                } else {
                    this.toastr.warning(`Please Add All Services First`)
                }
            } else {
                this.toastr.warning('Please Add All Services First');
            }

        } catch (e) {
            this.toastr.error('Sorry. Network problem. Plaese try again.');
            console.error(e);
        }
    }
    validateAllsteps = () => {
        return new Promise((resolve, reject) => {
            if (this.step1Complete) {
                if (this.step2Complete) {
                    if (this.step3Complete) {
                        if (this.step4Complete) {
                            if (this.step5Complete) {
                                resolve(true);
                            } else {
                                this.toastr.warning('Please Save Bank Details')
                                resolve(false);
                            }

                        } else {
                            this.toastr.warning('Please Save Principal places Details')
                            resolve(false);
                        }

                    } else {
                        this.toastr.warning('Please Save Contact Persons Details')
                        resolve(false);
                    }

                } else {
                    this.toastr.warning('Please Save All Services')
                    resolve(false);
                }

            } else {
                this.toastr.warning('Please Save Basic Details First')
                resolve(false);
            }
        })
    }
    finish = () => {
        window.location.href = `/login`;
    }

    saveStep1 = async () => {
        try {
            if (await this.validateStep1()) {
                const data = { "Name1": JSON.stringify(this.bussiness) };
                const response = await this.serviceService.post(`/admin/updateVendorBasicDetails?VendorID=${this.selectedVendorID}`, data);
                if (response.isSuccess == true) {
                    this.toastr.success('Successfully Updated Basic Details of Vendor.');
                    this.userID = response.userID;
                    this.step1Complete = true;
                    this.goToStep2();
                } else {
                    this.toastr.error(response.message);
                }
            }
        } catch (e) {
            this.toastr.error('Sorry. Network problem. Plaese try again.');
            console.error(e);
        }
    }
    message: string = '';
    saveStep2 = async () => {
        try {
            if (this.selectedDistrictList.length > 0) {
                if (this.goodsOrServicesList.length > 0) {
                    const data = { districtList: this.selectedDistrictList, servicesList: this.goodsOrServicesList, serviceDetails: this.service }
                    const response = await this.serviceService.post(`/admin/updateVendorServices?VendorID=${this.selectedVendorID}`, data);
                    this.message = response.message;

                    if (response.isSuccess) {
                        this.toastr.success(`Successfully Services are updated`);
                        this.step2Complete = true;
                        this.goToStep3();
                    } else {
                        this.toastr.error(`Failed to update Service details, try again.`);
                    }
                } else {
                    this.toastr.error(`Add minimum 1 Service`)
                }
            } else {
                this.toastr.error('Please apply minimum for 1 district');
            }
        } catch {
            this.toastr.error('Network problem. Please refresh the page and try again');
        }
    }
    saveStep3 = async () => {
        try {
            if (this.authorisedSignatoryList.length > 0) {
                const data = this.authorisedSignatoryList
                const response = await this.serviceService.post(`/admin/updateVendorContactPersonDetails?VendorID=${this.selectedVendorID}`, data);
                this.message = response.message;

                if (response.isSuccess) {
                    this.toastr.success(`Successfully Contact person's details are updated.`);
                    this.step3Complete = true;
                    this.goToStep4();
                } else {
                    this.toastr.error(`Failed to update Contact person's details, try again.`);
                }
            } else {
                this.toastr.error(`Add minimum 1 person's details`)
            }
        } catch {
            this.toastr.error('Network problem. Please refresh the page and try again');
        }
    }
    saveStep4 = async () => {
        try {
            if (this.principalPlacesList.length > 0) {
                const data = this.principalPlacesList
                const response = await this.serviceService.post(`/admin/updateVendorPrincipalPlaces?VendorID=${this.selectedVendorID}`, data);
                this.message = response.message;

                if (response.isSuccess) {
                    this.toastr.success(`Principal places are successfully updated.`);
                    this.step4Complete = true;
                    this.goToStep5();
                    // this.isCompleteStep4 = 'complete-step';
                    // this.completeStep4Bar = 'complete-step-bar';
                    // this.completeStep5Bar = 'active';
                } else {
                    this.toastr.error(`Failed to update Principal places, try again.`);
                }
            } else {
                this.toastr.error(`Add minimum 1 place`)
            }
        } catch {
            this.toastr.error('Network problem. Please refresh the page and try again');
        }
    }
    saveStep5 = async () => {
        try {
            if (this.bankAccountsList.length > 0) {
                this.step5Complete = true;
                this.isCompleteStep5 = 'complete-step';
            } else {
                this.toastr.error(`Add Minimum 1 Bank Account`);
            }
        } catch (e) {
            console.log(e);
            this.toastr.error('Network problem. Please refresh the page and try again');
        }
    }

    validateStep1 = () => {
        return new Promise((resolve, reject) => {
            if (this.bussiness.PAN.length == 10) {
                if (this.bussiness.GSTN.length == 15) {
                    this.bussiness.PAN = this.bussiness.PAN.toUpperCase();
                    this.bussiness.GSTN = this.bussiness.GSTN.toUpperCase();
                    this.bussiness.LegalBussinessName = this.bussiness.LegalBussinessName.toUpperCase();
                    this.bussiness.TradeName = this.bussiness.TradeName.toUpperCase();


                    // this.PANDoument = document.getElementById('PANDocument').files[0];
                    // this.GSTNDocument = document.getElementById('GSTNDocument').files[0];
                    // if (this.PANDoument != undefined) {
                    // if (this.PANDoument.type == 'application/pdf') {


                    // if (this.GSTNDocument != undefined) {
                    //     if (this.GSTNDocument.type == 'application/pdf') {



                    // let msmseStatus = this.bussiness.WhetherMSME == 'Yes' ? true : false;
                    // let RegistrationStatus = this.bussiness.WhetherSSIUnit == 'Yes' ? true : false;
                    // let msmeIsUpload = true;
                    // let regIsupload = true;
                    // if(msmseStatus) {
                    //     this.MSMECertificate = document.getElementById('MSMECertificate').files[0];
                    //     if(this.MSMECertificate == undefined) {
                    //         msmeIsUpload = false;
                    //         window.alert('Please upload MSME Certificate');
                    //     } else {
                    //         msmeIsUpload = true;
                    //     }
                    // }

                    // if(RegistrationStatus) {
                    //     this.SSIUnitRegistrationCertificate = document.getElementById('RegistrationCertificate').files[0];
                    //     if(this.SSIUnitRegistrationCertificate == undefined) {
                    //         regIsupload = false;
                    //         window.alert('Please upload Registration Certificate');
                    //     } else {
                    //         regIsupload = true;
                    //     }

                    // }
                    // if(msmeIsUpload && regIsupload) {
                    resolve(true);
                    // } else {
                    //     resolve(false);
                    // }




                    //     } else {
                    //         window.alert('GSTN Document should be a PDF File !!')
                    //         resolve(false);
                    //     }
                    // } else {
                    //     window.alert('Upload GSTN Document');
                    //     resolve(false);
                    // }







                    //     } else {
                    //         window.alert('Account Document should be a PDF File !!');
                    //         resolve(false);
                    //     }
                    // } else {
                    //     window.alert('Upload PAN Document');
                    //     resolve(false);
                    // }

                } else {
                    this.toastr.error('GSTN must be 15 digit.');
                    resolve(false);
                }
            } else {
                this.toastr.error('PAN must be 10 digit.');
                resolve(false);
            }
        })
    }

    goodsOrServicesList: any = [];
    goodsOrServices: any;
    AddGoodsOrServices = () => {
        if (this.goodsOrServices) {
            if (!this.goodsOrServicesList.includes(this.goodsOrServices)) {
                this.goodsOrServicesList.push(this.goodsOrServices);
            } else {
                this.toastr.warning('Item already added.');
            }
            this.goodsOrServices = '';
        } else {
            this.toastr.error('Please select Goods/Services first')
        }
    }

    AddDistrict = () => {
        if (this.district) {
            const dist = this.district;
            if(dist == 'ALL'){
                this.selectedDistrictList = []
                this.districtList.forEach((e: any) =>{
                    this.selectedDistrictList.push(e)
                })
            }
            else{
                const distIDs = this.selectedDistrictList.map((e: any) => e.dist_id);
                if (distIDs.includes(dist.dist_id)) {
                    this.toastr.warning('District Already selected');
                } else {
                    this.selectedDistrictList.push(dist);
                }
                this.district = '';
            }
        } else {
            this.toastr.error('Please select District first');
        }
    }
    removeDistrict = (index: number) => {
        this.selectedDistrictList.splice(index, 1);
    }


    removeGoods = (index: number) => {
        this.goodsOrServicesList.splice(index, 1);
    }








    goToStep1 = () => {
        this.step1 = true;
        this.step2 = false;
        this.step3 = false;
        this.step4 = false;
        this.step5 = false;
    }
    goToStep2 = () => {
        this.step1 = false;
        this.step2 = true;
        this.step3 = false;
        this.step4 = false;
        this.step5 = false;
    }
    goToStep3 = () => {
        this.step1 = false;
        this.step2 = false;
        this.step3 = true;
        this.step4 = false;
        this.step5 = false;
    }
    goToStep4 = () => {
        this.step1 = false;
        this.step2 = false;
        this.step3 = false;
        this.step4 = true;
        this.step5 = false;
    }
    goToStep5 = () => {
        this.step1 = false;
        this.step2 = false;
        this.step3 = false;
        this.step4 = false;
        this.step5 = true;
    }




}
