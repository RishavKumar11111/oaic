import { NgxPrintModule } from 'ngx-print';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { InitiateRoutingModule } from './initiate-routing.module';
import { InitiateComponent } from './initiate/initiate.component';
import { SharedModule } from 'src/app/shared/shared.module';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { PoModule } from 'src/app/report/po/po.module';
import { SearchBoxComponent } from './search-box/search-box.component';
import { SubsidiesOrdersComponent } from './subsidies-orders/subsidies-orders.component';
import { NonSubsidiesOrdersComponent } from './non-subsidies-orders/non-subsidies-orders.component';
import { OrderEntryFormComponent } from './non-subsidies-orders/order-entry-form/order-entry-form.component';
import { OrderListComponent } from './non-subsidies-orders/order-list/order-list.component';


@NgModule({
  declarations: [
    InitiateComponent,
    SearchBoxComponent,
    SubsidiesOrdersComponent,
    NonSubsidiesOrdersComponent,
    OrderEntryFormComponent,
    OrderListComponent
  ],
  imports: [
    CommonModule,
    InitiateRoutingModule,
    SharedModule,
    FormsModule,
    ReactiveFormsModule,
    PoModule,
    NgxPrintModule
  ]
})
export class InitiateModule { }
