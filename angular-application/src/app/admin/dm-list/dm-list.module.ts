import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { DmListRoutingModule } from './dm-list-routing.module';
import { FormsModule } from '@angular/forms';
import { DmListComponent } from './dm-list/dm-list.component';


@NgModule({
  declarations: [
    DmListComponent
  ],
  imports: [
    CommonModule,
    DmListRoutingModule,
    FormsModule,
    // ReactiveFormsModule
  ]
})
export class DmListModule { }
