import { Injectable } from '@angular/core';
import { CookieService } from 'ngx-cookie-service';
import { ToastrService } from 'ngx-toastr';
import { BehaviorSubject, Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { CommonService } from '../common.service';

@Injectable({
  providedIn: 'root'
})
export class LayoutService {

  
  CSRFToken: string = '';
  UserRole: string = '';
  UserName: string = '';
  UserID: string = '';
  DistrictID: string = '';
  CurrentDate: any;
  private breadcrumbSubject: BehaviorSubject<string>;
  breadcrumb: Observable<string>;
  constructor(
      private service: CommonService,
      private toastr: ToastrService,
      private cookieeService: CookieService
    ) { 
    this.breadcrumbSubject = new BehaviorSubject('');
    this.breadcrumb = this.breadcrumbSubject.asObservable();
  }


  setBreadcrumb(breadcrumbList: any) {
    this.breadcrumbSubject.next(breadcrumbList);
  }
  setCSRFToken(token: string) {
    this.CSRFToken = token;
  }
  getCSRFToken(): string {
    return this.CSRFToken;
  }
  goToLoginPage() {
    window.location.replace(`${environment.server_url}/login`);
  }
  async logout() {
    const response = await this.service.get('/signOut');
    if(response) {
      this.cookieeService.deleteAll();
      this.goToLoginPage();
    } else {
      this.toastr.error('Unable Signout. Try Again');
    }
  }

  setUserRole(value: string) {
    this.UserRole = value;
  }
  getUserRole(): string {
    return this.UserRole;
  }
  setUserName(value: string) {
    this.UserName = value;
  }
  getUserName(): string {
    return this.UserName;
  }
  setUserID(value: string) {
    this.UserID = value;
  }
  getUserID(): string {
    return this.UserID;
  }
  setDistrictID(value: string) {
    this.DistrictID = value;
  }
  getDistrictID(): string {
    return this.DistrictID;
  }
  setCurrentDate(value: string) {
    this.CurrentDate = value;
  }
  getCurrentDate(): string {
    return this.CurrentDate;
  }
  isLoggedin() : boolean {
    return !!this.UserRole;
  }



}
