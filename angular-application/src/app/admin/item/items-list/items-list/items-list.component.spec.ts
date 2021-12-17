import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TestingModules, TestingProviders } from 'src/app/common/common.modules';

import { ItemsListComponent } from './items-list.component';

describe('ItemsListComponent', () => {
  let component: ItemsListComponent;
  let fixture: ComponentFixture<ItemsListComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ItemsListComponent ],
      imports: [TestingModules],
      providers: [TestingProviders]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ItemsListComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
