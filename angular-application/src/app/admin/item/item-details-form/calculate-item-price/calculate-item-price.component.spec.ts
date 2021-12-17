import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CalculateItemPriceComponent } from './calculate-item-price.component';

describe('CalculateItemPriceComponent', () => {
  let component: CalculateItemPriceComponent;
  let fixture: ComponentFixture<CalculateItemPriceComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CalculateItemPriceComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CalculateItemPriceComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
