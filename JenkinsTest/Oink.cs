﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JenkinsTest
{
    public class Oink
    {
        public String Name { get; set; }

        public Oink()
        {

        }
        public Oink(String name)
        {
            if (null == name)
                throw new ArgumentNullException();
            Name = name;
        }
    }
}
