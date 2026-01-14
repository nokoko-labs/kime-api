import { RedisModule } from '@/cache/redis.module';
import { ConfigModule } from '@/config/config.module';
import { DatabaseModule } from '@/database/database.module';
import { Module } from '@nestjs/common';

@Module({
  imports: [ConfigModule, DatabaseModule, RedisModule],
})
export class AppModule {}
