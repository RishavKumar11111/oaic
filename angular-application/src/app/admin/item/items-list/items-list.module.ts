import { EnterPackagesModule } from 'src/app/admin/item/item-details-form/enter-packages/enter-packages.module';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ItemsListRoutingModule } from './items-list-routing.module';
import { ItemsListComponent } from './items-list/items-list.component';
import { EnterItemDetailsFormModule } from 'src/app/admin/item/item-details-form/enter-item-details-form/enter-item-details-form.module';
import { CalculateItemPriceModule } from 'src/app/admin/item/item-details-form/calculate-item-price/calculate-item-price.module';
import { PreviewItemDetailsModule } from 'src/app/admin/item/item-details-form/preview-item-details/preview-item-details.module';
import { SharedModule } from 'src/app/shared/shared.module';


@NgModule({
  declarations: [
    ItemsListComponent
  ],
  imports: [
    CommonModule,
    ItemsListRoutingModule,
    FormsModule,
    ReactiveFormsModule,
    EnterItemDetailsFormModule,
    CalculateItemPriceModule,
    PreviewItemDetailsModule,
    EnterPackagesModule,
    SharedModule
  ]
})
export class ItemsListModule { }
