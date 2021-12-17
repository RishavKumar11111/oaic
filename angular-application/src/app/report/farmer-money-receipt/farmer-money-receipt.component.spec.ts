import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FarmerMoneyReceiptComponent } from './farmer-money-receipt.component';

describe('FarmerMoneyReceiptComponent', () => {
  let component: FarmerMoneyReceiptComponent;
  let fixture: ComponentFixture<FarmerMoneyReceiptComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ FarmerMoneyReceiptComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(FarmerMoneyReceiptComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
