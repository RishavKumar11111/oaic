import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SharedModule } from './../../../shared/shared.module';
import { FormsModule } from '@angular/forms';
import { NgxPrintModule } from 'ngx-print';

import { VendorWiseLedgerRoutingModule } from './vendor-wise-ledger-routing.module';
import { VendorWiseComponent } from './vendor-wise/vendor-wise.component';


@NgModule({
  declarations: [
    VendorWiseComponent
  ],
  imports: [
    CommonModule,
    SharedModule,
    FormsModule,
    NgxPrintModule,
    VendorWiseLedgerRoutingModule
  ]
})
export class VendorWiseLedgerModule { }
