using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ConsoleApplication2
{
    public abstract class SingModel<T>
    {
        private static object ObjectLock = new object();
        private static T _Instance;
        public static T Instance
        {
            get
            {
                if (_Instance == null)
                {
                    lock (ObjectLock)
                    {
                        if (_Instance == null)
                            _Instance = GetSingModel();
                    }
                }
                return _Instance;
            }
            private set
            {
                _Instance = value;
            }
        }

        private static T GetSingModel()
        {
            var publicConstructors = typeof(T).GetConstructors();
            var privateConstructors = typeof(T).GetConstructors(BindingFlags.NonPublic | BindingFlags.Instance).ToArray();
            var defaultConstruct = privateConstructors.FirstOrDefault(x => x.GetParameters().Length == 0);
            if (defaultConstruct == null)
                throw new Exception("不存在私有的无参构造函数");
            if (publicConstructors.Length > 0)
                throw new Exception("不允许有共有的构造函数");
            return (T)defaultConstruct.Invoke(null);
        }
    }

    public class Stud : SingModel<Stud>
    {
        private Stud()
        {
        }
        public string Name { get; set; }
    }


    public class Staff : SingModel<Staff>
    {

    }
    class Program
    {
        public static void Main()
        {
            var b = Stud.Instance;
        }


        public static Action GetAc()
        {
            int temp = 2;
            return () =>
            {
                Console.WriteLine((++temp).ToString());
            };
        }

    }

    public class MyHash
    {
        //容器实体
        private struct bucket
        {
            public object key;
            public object value;
        }

        private LinkedList<bucket>[] buckets = null;//容器
        private int count;//已存元素数量
        private int step = 10;//扩展时增加的数量

        public MyHash()
        {
            IninialBuckets(step);
        }

        private void IninialBuckets(int length)
        {
            if (buckets == null)//如果为空，则初始化容器
            {
                buckets = new LinkedList<bucket>[length];
                return;
            }
            //否则，则扩展容器
            length = length + buckets.Length;
            var newBuckets = new LinkedList<bucket>[length];
            count = 0;
            foreach (LinkedList<bucket> linkList in buckets)
            {
                if (linkList == null)
                    continue;
                foreach (bucket item in linkList)
                {
                    int index = GetIndex(item.key, length);
                    InserintoBuckets(index, item.key, item.value, newBuckets);//重新排列
                }
            }
            buckets = newBuckets;
        }

        private int GetIndex(object key, int length)
        {
            return (int)((uint)key.GetHashCode() % (uint)length);
        }

        private void InserintoBuckets(int index, object key, object value, LinkedList<bucket>[] buckets)
        {
            var linkList = buckets[index];
            if (linkList == null)
                linkList = new LinkedList<bucket>();
            if (linkList.Count(x => x.key == key) > 0)
                throw new Exception("已存在key:" + key);
            bucket item = new bucket()
            {
                key = key,
                value = value
            };
            linkList.AddLast(item);
            buckets[index] = linkList;
            count++;
        }

        public void Add(object key, object value)
        {
            if ((float)count / (float)buckets.Length > 0.62)//如果大于0.62。我们就扩展我们的容器
            {
                IninialBuckets(step);
            }
            int index = GetIndex(key, buckets.Length);
            InserintoBuckets(index, key, value, buckets);
        }

        public object Find(object key)
        {
            int index = GetIndex(key, buckets.Length);
            var linkList = buckets[index];
            if (linkList == null)
                throw new Exception("不存在此键");
            bucket item = linkList.FirstOrDefault(x => x.key == key);
            if (item.key == null)
                throw new Exception("不存在此键");
            return item.value;
        }
    }
}
