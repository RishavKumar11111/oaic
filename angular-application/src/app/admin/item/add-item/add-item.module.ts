import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { AddItemRoutingModule } from './add-item-routing.module';
import { AddItemComponent } from './add-item/add-item.component';
import { EnterItemDetailsFormModule } from 'src/app/admin/item/item-details-form/enter-item-details-form/enter-item-details-form.module';
import { CalculateItemPriceModule } from 'src/app/admin/item/item-details-form/calculate-item-price/calculate-item-price.module';
import { PreviewItemDetailsModule } from 'src/app/admin/item/item-details-form/preview-item-details/preview-item-details.module';
import { EnterPackagesModule } from 'src/app/admin/item/item-details-form/enter-packages/enter-packages.module';


@NgModule({
  declarations: [
    AddItemComponent
  ],
  imports: [
    CommonModule,
    AddItemRoutingModule,
    FormsModule,
    ReactiveFormsModule,
    EnterItemDetailsFormModule,
    CalculateItemPriceModule,
    PreviewItemDetailsModule,
    EnterPackagesModule
  ]
})
export class AddItemModule { }
