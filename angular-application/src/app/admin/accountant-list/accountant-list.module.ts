import { FormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { AccountantListRoutingModule } from './accountant-list-routing.module';
import { AccListComponent } from './acc-list/acc-list.component';


@NgModule({
  declarations: [
    AccListComponent
  ],
  imports: [
    CommonModule,
    AccountantListRoutingModule,
    FormsModule
  ]
})
export class AccountantListModule { 
  constructor() {
    console.log('ADMIN accountant LISST Module called');
    
  }
}
