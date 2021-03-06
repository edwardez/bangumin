import {Serializable} from '../Serializable';
import {SubjectBase} from './subject-base';
import {SubjectCollection} from './subject-collection';


export class SubjectWatchingCollectionMedium extends SubjectBase implements Serializable<SubjectWatchingCollectionMedium> {
  /**
   * 话数
   * example: 27
   * difference between eps_count?
   * format: int32
   */
  eps?: number;
  /**
   * 话数
   * example: 27
   * format: int32
   */
  totalEpisodesCount?: number;

  /**
   * total number of volume(undocumented in API, only applies to book?)
   */
  totalVolumesCount?: number;

  collection?: SubjectCollection; // seems like only 'doing' is returned?

  constructor() {
    super();
    this.eps = 0;
    this.totalEpisodesCount = 0;
    this.totalVolumesCount = 0;
    this.collection = new SubjectCollection();
  }

  deserialize(input) {
    super.deserialize(input);
    this.eps = input.eps || 0;
    this.totalEpisodesCount = input.eps_count || 0;
    this.totalVolumesCount = input.vols_count || 0;
    this.collection = input.collection === undefined ? new SubjectCollection() : new SubjectCollection().deserialize(input.collection);
    return this;
  }
}
